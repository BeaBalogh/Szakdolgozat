//
//  RecipesWithoutSearchViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 22..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import SideMenuSwift

private let reuseIdentifier = "RecipeCell"



class RecipesWithoutSearchViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIGestureRecognizerDelegate{
    
    let model = RecipeListLogic.shared
    var observers = [NSKeyValueObservation]()
    var dataSource: [Recipe] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func logoutAction(_ sender: Any) {logout()}
    
    @IBAction func showMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        observeModel()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    func observeModel() {
      
    }
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            showAlert(recipe: dataSource[(indexPath?.item)!])
        }
    }
    
    //     MARK: actions
    func refreashControlAction(){
        self.collectionView?.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func logout(){
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                if Auth.auth().currentUser == nil {
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! MainLoginViewController
                    self.present(vc, animated: true, completion: nil)
                }
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                print("def")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(recipe: Recipe){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Remove \(recipe.name)", style: .default, handler: { _ in
            self.dataSource.removeAll(where: { (item) -> Bool in
                return recipe.id == item.id
            })
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! DetailsTabViewController
        if let paths = collectionView?.indexPathsForSelectedItems {
            let row = paths[0].row
            vc.recipe = dataSource[row]
        }
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCollectionViewCell
        
        let recipe = dataSource[indexPath.row]
    
        cell.nameLabel.text = recipe.name
        cell.categoryLabel.text = recipe.category
        if(recipe.image == nil)
        {
            cell.mealImage.image = #imageLiteral(resourceName: "placeholder")
        }else{
            cell.mealImage.image = UIImage(data: recipe.image!)
        }
        
        return cell
    }
    
    // MARK: prepareVC
    func prepareUI(){
        self.addRefreshControl()
    }
    
    func addRefreshControl(){
        if (self.refreshControl == nil) {
            self.refreshControl            = UIRefreshControl()
            self.refreshControl?.tintColor = UIColor.white
            self.refreshControl?.addTarget(self, action: Selector(("refreashControlAction")), for: UIControl.Event.valueChanged)
        }
        if !self.refreshControl!.isDescendant(of: self.collectionView!) {
            self.collectionView!.addSubview(self.refreshControl!)
        }
    }
    
    func startRefreshControl(){
        if !self.refreshControl!.isRefreshing {
            self.refreshControl!.beginRefreshing()
        }
    }
    
}

