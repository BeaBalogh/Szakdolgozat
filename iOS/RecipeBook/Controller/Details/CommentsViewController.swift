//
//  CommentsViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 19..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import HCSStarRatingView
import GrowingTextView
import AVFoundation
import Photos


class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 
    var comments: [Comment] = []
    var recipeid: String = ""
    let recipeService = FirebaseService.shared
    
    @IBOutlet weak var tableView: ContentSizedTableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ratingbarView: HCSStarRatingView!
    @IBOutlet weak var commentTextView: GrowingTextView!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var userNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIImageView!

    @IBAction func cancelAction(_ sender: Any) {
        mealImageView.image = #imageLiteral(resourceName: "icons8-add-image-30")
        mealImageView.contentMode = .center
        cancelButton.isHidden = true
        cancelButton.isUserInteractionEnabled = false
        mealImageView.isUserInteractionEnabled = true

    }
    @IBAction func backgroundTouched(_ sender: Any) {
          view.endEditing(true)
    }
    @IBAction func imageviewTapped(_ sender: Any) {
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.openCamera()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
                
            case .denied: // The user has previously denied access.
                return
                
            case .restricted: // The user can't grant access due to restrictions.
                return
            
            default:
                return
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            switch PHPhotoLibrary.authorizationStatus(){
            case .authorized: // The user has previously granted access to the camera.
                self.openGallery()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized{
                        self.openGallery()
                    }
                })
                
            case .denied: // The user has previously denied access.
                let alert  = UIAlertController(title: "Warning", message: "You denied the permission to access gallery.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                
            case .restricted: // The user can't grant access due to restrictions.
                return
                    
            default:
                return
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func sendComment(_ sender: Any) {
        view.endEditing(true)
        if(self.commentTextView.text! == "" || self.mealImageView.image == nil){
            AlertService.showToast("Error: Empty comment!")
            return
        }
        self.sendButton.isEnabled = false
        let date = Date().string(format: "MMM. dd, yyyy HH:mm")
        let imgUrl = String(Date().toMillis())
        let comment = Comment(id: "", userName: "", text: commentTextView.text!, imgURL: imgUrl, date: date , rating: Float(ratingbarView!.value))
        let data = self.mealImageView.image?.jpegData(compressionQuality: 1)
        recipeService.uploadComment(comment: comment, recipeId: recipeid, data: data){ (commment, error) in
            if(error == nil){
                self.comments.append(comment)
                self.tableView.reloadData()
                self.mealImageView.image = nil
                self.commentTextView.text = ""
                self.ratingbarView.value = 3.0
            }
            else{
                
            }
            self.sendButton.isEnabled = true

        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        comments = (tabBarController as! DetailsTabViewController).recipe.comments
        recipeid = (tabBarController as! DetailsTabViewController).recipe.id
        tableView.delegate = self
        tableView.dataSource = self
        sendButton.layer.cornerRadius = 4
        commentTextView.layer.cornerRadius = 4
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor =  UIColor.lightGray.cgColor
        commentTextView.isEditable = true
        commentTextView.layer.masksToBounds = true
        commentTextView.placeholder = "Write down your experiences"
        commentTextView.maxHeight = 380
        mealImageView.layer.cornerRadius = 4
        mealImageView.layer.borderWidth = 1
        mealImageView.layer.borderColor =  UIColor.lightGray.cgColor
        mealImageView.layer.masksToBounds = false
        usernameLabel.text = FirebaseService.shared.getUserName() ?? ""
        cancelButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Keyboard
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if commentTextView.frame.maxY > (view.frame.height - keyboardSize.height) {
                userNameTopConstraint.constant = -1 * (commentTextView.frame.maxY - (view.frame.height - keyboardSize.height))
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        userNameTopConstraint.constant = 8
    }
    
    
    //MARK: Image picker functions
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //Mark: Growing text view
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            mealImageView.image = pickedImage
            mealImageView.contentMode = .scaleToFill
            mealImageView.clipsToBounds = true
        }
        cancelButton.isHidden = false
        cancelButton.isUserInteractionEnabled = true
        mealImageView.isUserInteractionEnabled = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        print(comment)
        cell.usernameLabel.text = comment.userName
        cell.dateLabel.text = comment.date
        cell.ratingbarView.value = CGFloat(comment.rating)
        if (cell.commentImageView.image == nil) {
            recipeService.getImage(imgURL: comment.imgURL) { (data, error) in
                if(error != nil || data == nil){
                    cell.commentImageView.image = nil
                    return
                }
                if let image = UIImage(data: data!){
                    cell.commentImageView.image = image
                }
            }
        }

        cell.commentTextView.text = comment.text
    
        return cell
    }

}
