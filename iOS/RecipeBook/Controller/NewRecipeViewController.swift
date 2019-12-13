//
//  NewRecipeViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 21..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class NewRecipeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

  
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIImageView!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBAction func showMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        cancelButton.isHidden = true
        saveButton.layer.cornerRadius = 8
        mealImageView.layer.cornerRadius = 4
        mealImageView.layer.borderWidth = 1
        mealImageView.layer.borderColor =  UIColor.lightGray.cgColor
        mealImageView.layer.masksToBounds = false
        // Do any additional setup after loading the view.
    }
    
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
    //MARK: TableView
    var ingredients:[String:String]=[:]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientsTableViewCell
        
        
        return cell
    }
    //PickerView
    let categories = ["Beef", "Breakfast", "Chicken", "Dessert", "Goat", "Lamb", "Miscellaneous", "Pasta", "Pork", "Seafood", "Starter", "Vegan", "Vegetarian"]
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
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

}
