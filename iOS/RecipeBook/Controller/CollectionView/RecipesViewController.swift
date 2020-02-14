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
import Reachability

private let reuseIdentifier = "RecipeCell"

class RecipesViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func logoutAction(_ sender: Any) {logout()}
    
    @IBAction func showMenu(_ sender: Any) {
            sideMenuController?.revealMenu()
    }
    
    let model = RecipeListLogic.shared
    var observers = [NSKeyValueObservation]()
    
    var dataSource: [Recipe] = []
    var dataSourceForSearchResult:[Recipe] = []
    var searchBarActive:Bool = false
    var refreshControl:UIRefreshControl?
    let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)

        observeModel()
        model.getRandom()
        prepareUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.backgroundColor = UIColor.clear
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: view.bounds.width/2 - 20,height: view.bounds.width/2 - 20)
        }
        
    }
    
    func observeModel() {
        self.observers = [
            model.observe(\RecipeListLogic.randomRecipes, options: [.initial]) { (model, change) in
                self.dataSource = model.randomRecipes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            },
            model.observe(\RecipeListLogic.searchRecipes, options: [.initial]) { (model, change) in
                self.dataSourceForSearchResult = model.searchRecipes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        ]
    }
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            model.getRandom()
        case .cellular:
            print("Reachable via Cellular")
            model.getRandom()
        case .unavailable:
            print("Network not reachable")
        case .none:
            print("Network not reachable")
        }
    }
    
//     MARK: Actions
    @objc func refreshControlAction(sender:AnyObject){
        self.startRefreshControl()
        self.cancelSearching()
        model.getRandom()
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
                    vc.recipe = self.dataSourceForSearchResult[row];
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
            return self.dataSourceForSearchResult.count;
        }
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCollectionViewCell
        var recipe = Recipe("")
        if (self.searchBar.text!.isEmpty == false) {
            if(indexPath.row < self.dataSourceForSearchResult.count){
                recipe = self.dataSourceForSearchResult[indexPath.row];
            }
            else{ return cell }
        }else{
            recipe = dataSource[indexPath.row]
        }
        cell.nameLabel.text = recipe.name
        cell.categoryLabel.text = recipe.category
        cell.nameLabel.numberOfLines = 3
        if let imageData = try? Data(contentsOf: URL(string: recipe.imgURL)!){
            if let image = UIImage(data: imageData){
                    cell.mealImage.image = image.resize(image: image, targetSize: CGRect(x: 0, y: 0, width: 180, height: 180).size)
            }
        }
        return cell
    }

    // MARK: Search
    func filterContentForSearchText(searchText:String){
//        self.dataSourceForSearchResult = dataSource.filter({ (recipe:Recipe) -> Bool in
//            return recipe.name.contains(searchText)
//        })
        model.search(name: searchText)
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
            self.refreshControl?.addTarget(self, action: #selector(refreshControlAction(sender:)), for: UIControl.Event.valueChanged)
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
