//
//  RecipesCollectionViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 09..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import SideMenuSwift

private let reuseIdentifier = "RecipeCell"
let recipe = Recipe(id: "asd", name: "Palacsinta", imgURL: "String", ingredients: ["alma" : "3 db"], category: "Dessert", instruction: "Susd meg!", comments: [], image: "asd")
let recipe2 = Recipe(id: "asd", name: "Sajt", imgURL: "String", ingredients: ["alma" : "3 db"], category: "Dessert", instruction: "Susd meg!", comments: [], image: "asd")
let recipe3 = Recipe(id: "asd", name: "Tea", imgURL: "String", ingredients: ["alma" : "3 db","alma1" : "3 db","alma2" : "3 db"], category: "Dessert", instruction: "Susd meg!", comments: [], image: "asd")
private var dataSource: [Recipe] = [recipe, recipe2, recipe2, recipe3, recipe,recipe, recipe2, recipe2, recipe3, recipe]



class RecipesViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func logoutAction(_ sender: Any) {logout()}
    
    @IBAction func showMenu(_ sender: Any) {
            sideMenuController?.revealMenu()
    }
    var dataSourceForSearchResult:[Recipe]?
    var searchBarActive:Bool = false
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.backgroundColor = UIColor.clear
        
    }
//    deinit{
//        self.removeObservers()
//    }
//     MARK: actions
    func refreashControlAction(){
        self.cancelSearching()
        self.collectionView?.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func logout(){
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
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

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
            let vc = segue.destination as! DetailsTabViewController
            if let paths = collectionView?.indexPathsForSelectedItems {
                let row = paths[0].row
                if (self.searchBar.text!.isEmpty == false) {
                    vc.recipe = self.dataSourceForSearchResult![row];
                }
                else{
                    vc.recipe = dataSource[row]
                }
        }
    }
   
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchBarActive {
            return self.dataSourceForSearchResult!.count;
        }
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCollectionViewCell
        
        var recipe = dataSource[indexPath.row]
        if (self.searchBar.text!.isEmpty == false) {
            recipe = self.dataSourceForSearchResult![indexPath.row];
        }
        cell.nameLabel.text = recipe.name
        cell.categoryLabel.text = recipe.category
    
        return cell
    }

    // MARK: Search
    func filterContentForSearchText(searchText:String){
        self.dataSourceForSearchResult = dataSource.filter({ (recipe:Recipe) -> Bool in
            return recipe.name.contains(searchText)
        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            self.searchBarActive    = true
            self.filterContentForSearchText(searchText: searchText)
            self.collectionView?.reloadData()
        }else{
            self.searchBarActive = false
            self.collectionView?.reloadData()
        }

    }

    private func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        
    }
    func cancelSearching(){
        self.searchBarActive = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
        view.endEditing(true)
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

