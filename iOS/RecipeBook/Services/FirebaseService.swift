//
//  Firestore.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 12. 04..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseService {
    static public let shared = FirebaseService()
    private let auth = Auth.auth()
    private let storage = Storage.storage().reference()
    private var db :Firestore
    
    init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        // Enable offline data persistence
        db = Firestore.firestore()
        db.settings = settings
    }
    func getUserName() -> String? {
        return auth.currentUser?.displayName
    }
    
    func getRecipes(completion: @escaping ([Recipe], Error?) -> Void) {
        var recipeArray: [Recipe] = []
        db.collection("recipes").getDocuments { snapshot, error in
            if let error = error {
                print(error)
                completion(recipeArray, error)
                return
            }
            for doc in snapshot!.documents {
                let recipe = Recipe(dictionary: doc.data())
                recipeArray.append(recipe)
            }
            completion(recipeArray, nil)
        }
    }
    
    func getUserData(completion: @escaping (User?, Error?) -> Void) {
        let ref = db.collection("users").document(auth.currentUser!.uid)
        ref.getDocument { document, error in
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            if(document?.data()==nil){
                let user = User(empty: true)
                ref.setData(user.getDictionary())
                completion(user,nil)
                return
            }
            let user = User(dictionary: (document?.data())!)
            completion(user, nil)
        }
    }

    func loadComments(id: String, completion: @escaping ([Comment], Error?) -> Void) {
        var commentArray: [Comment] = []
        db.collection("recipes").document(id).collection("comments").getDocuments {snapshot, error in
            if let error = error {
                print(error)
                completion(commentArray, error)
                return
            }
            for doc in snapshot!.documents {
                let comment = Comment(dictionary: doc.data())
                commentArray.append(comment)
            }
            completion(commentArray, nil)
        }
    }

    func loadComment(recipeId: String, id: String, completion: @escaping (Comment?, Error?) -> Void) {
        db.collection("recipes").document(recipeId).collection("comments").document(id).getDocument { document, error in
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            let comment = Comment(dictionary: document!.data()!)
            completion(comment, nil)
        }
    }


    func createUser() {
        let ref = db.collection("users").document(auth.currentUser!.uid)
        ref.getDocument { document, error in
            let user = User(empty: true)
            ref.setData(user.getDictionary(), merge: true)
        }
    }

    func updateUserList(list: [Any], listName: String) {
        let ref = db.collection("users").document(auth.currentUser!.uid)
        ref.updateData([listName: list]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

    func uploadRecipe(recipe: Recipe, data: Data) {
        uploadImage(data: data, fileName: recipe.imgURL){ (metadata, error) in
            if (error == nil){
                self.saveRecipe(recipe: recipe)
            }
        }
    }

    func uploadComment( comment: Comment, recipeId: String, data: Data?, completion: @escaping (Comment?, Error?) -> Void) {
        comment.userName = auth.currentUser!.displayName!
        if (data != nil) {
            uploadImage(data: data!, fileName: comment.imgURL){ (metadata, error) in
                guard metadata != nil else {
                    print(error!)
                    return
                }
            }
            db.collection("recipes").document(recipeId).collection("comments").addDocument(data: comment.getDictionary()){ error in
                completion(comment, error)
            }
            
        }
        else{
            db.collection("recipes").document(recipeId).collection("comments").addDocument(data: comment.getDictionary())
            { error in
                completion(comment, error)
            }
        }
    }

    func uploadImage(data: Data, fileName: String, completion: @escaping (StorageMetadata?, Error?) -> Void) {
        let ref = storage.child("images/\(fileName)")
        ref.putData(data, metadata: nil) { (metadata, error) in
            completion(metadata, error)
        }

    }

    func getImage(imgURL: String, completion: @escaping (Data?, Error?) -> Void){
        let pathReference = storage.child("images/\(imgURL)")
        pathReference.getData(maxSize: INT64_MAX) { (data, error) in
            completion(data,error)
        }
    }

    func saveRecipe(recipe: Recipe ) {
        
        var ref: DocumentReference? = nil

        if (recipe.id == "") {
          ref = db.collection("recipes").addDocument(data: recipe.getDictionary()){ error in
                if( error != nil)
                {
                    return
                }
            recipe.id = ref!.documentID
            self.db.collection("recipes").document(recipe.id).setData(recipe.getDictionary())
            }
        } else {
            db.collection("recipes").document(recipe.id).setData(recipe.getDictionary())
        }
    }
}
