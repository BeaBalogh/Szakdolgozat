//
//  models.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 10..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation

class Recipe: NSObject, Codable{
    var id: String = ""
    var name: String = ""
    var imgURL: String = ""
    var ingredients: [String:String] = [:]
    var category: String = ""
    var instruction: String = ""
    var comments: [Comment] = []
    var image: Data? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imgURL
        case ingredients
        case category
        case instruction
        case comments
        case image
        
    }
    init(_ name: String?){
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        imgURL = try values.decode(String.self, forKey: .imgURL)
        ingredients = try values.decode([String:String].self, forKey: .ingredients)
        category = try values.decode(String.self, forKey: .category)
        instruction = try values.decode(String.self, forKey: .instruction)
        comments = try values.decode([Comment].self, forKey: .comments)
        image = try values.decode(Data.self, forKey: .image)
    }
    init(dictionary: [String: Any]){
        self.id = dictionary["id"] as! String
        self.name = dictionary["name"] as! String
        self.imgURL = dictionary["imgURL"] as! String
        self.ingredients = dictionary["ingredients"] as! [String:String]
        self.category = dictionary["category"] as! String
        self.instruction = dictionary["instruction"] as! String
        let commentsArray = dictionary["comments"] as! [Any]
        for comment in commentsArray {
            let comm = Comment(dictionary: comment as? [String: Any] ?? [:])
            self.comments.append(comm)
        }
        
        self.image = Data(base64Encoded: dictionary["image"] as! String)
    }
    
    init(id: String?, name: String?, imgURL: String?, ingredients: [String:String]?, category: String?, instruction: String?, comments: [Comment]?, image: Data?){
        self.id = id ?? ""
        self.name = name ?? ""
        self.imgURL = imgURL ?? ""
        self.ingredients = ingredients ?? [:]
        self.category = category ?? ""
        self.instruction = instruction ?? ""
        self.comments = comments ?? []
        self.image = image
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imgURL, forKey: .imgURL)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(category, forKey: .category)
        try container.encode(instruction, forKey: .instruction)
        try container.encode(comments, forKey: .comments)
        try container.encode(image, forKey: .image)
    }
    func getDictionary() -> [String: Any]{
        var comments :[[String: Any]] = [[:]]
        for comment in self.comments {
            comments.append(comment.getDictionary())
        }
        let recipe :[String: Any] = [
            "id" : self.id,
            "name" : self.name,
            "imgURL" : self.imgURL,
            "ingredients" : self.ingredients,
            "category" : self.category,
            "instruction" : self.instruction,
            "comments" : comments,
            "image" : self.image?.base64EncodedString() ?? "" ]
        return recipe
    }
    
}

class Comment: NSObject, Codable{
    var id: String = ""
    var userName: String = ""
    var text: String = ""
    var imgURL: String = ""
    var date: String = ""
    var rating: Float = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName
        case text
        case imgURL
        case date
        case rating
    }
    init(_ id: String){}
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        userName = try values.decode(String.self, forKey: .userName)
        text = try values.decode(String.self, forKey: .text)
        imgURL = try values.decode(String.self, forKey: .imgURL)
        date = try values.decode(String.self, forKey: .date)
        rating = try values.decode(Float.self, forKey: .rating)
    }
    init(dictionary: [String: Any]){
        if(!dictionary.isEmpty){
            self.id = dictionary["id"] as? String ?? ""
            self.userName = dictionary["userName"] as! String
            self.text = dictionary["text"] as! String
            self.imgURL = dictionary["imgURL"] as! String
            self.date = dictionary["date"] as! String
            self.rating = dictionary["rating"] as? Float ?? 0
        }
    }
    init(id: String, userName: String, text: String, imgURL: String, date: String, rating: Float ){
        self.id = id
        self.userName = userName
        self.text = text
        self.imgURL = imgURL
        self.date = date
        self.rating = rating
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userName, forKey: .userName)
        try container.encode(imgURL, forKey: .imgURL)
        try container.encode(text, forKey: .text)
        try container.encode(date, forKey: .date)
        try container.encode(rating, forKey: .rating)
    }
    func getDictionary() -> [String: Any]{
        let comment :[String: Any] = [
            "userName" : self.userName,
            "text" : self.text,
            "imgURL" : self.imgURL,
            "date" : self.date,
            "rating" : self.rating]
        return comment
    }
}

class User: NSObject {
    var favorites: [String] = []
    var cooked: [String] = []
    var myRecipes: [String] = []
    init(empty: Bool){}
    init(dictionary: [String: Any]){
        self.favorites = dictionary["favorites"] as! [String]
        self.cooked = dictionary["cooked"] as! [String]
        self.myRecipes = dictionary["myRecipes"] as! [String]
    }
    func getDictionary() -> [String: Any]{
        let user : [String: Any] = [
            "favorites": self.favorites,
            "cooked" : self.cooked,
            "myRecipes" : self.myRecipes]
        return user
    }
}




