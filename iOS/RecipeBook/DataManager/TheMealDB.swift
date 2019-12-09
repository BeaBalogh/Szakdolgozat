//
//  RestManager.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 12. 02..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation


struct TheMealDB {
    let baseUrl = "https://www.themealdb.com/api/json/v2/1/"
    let networking = NetworkingService.shared
    
    func searchByName(name: String) -> Void{
        networking.request(baseUrl + "search.php?s=" + name){ (result) in
            switch result{
            case .success(let data):
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {return}
                    print(json)
                }
                catch{
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func random()-> Void{
        networking.request(baseUrl + "ramdom.php"){ (result) in
//            switch result{
//            case .success(let data):
////                do{
////                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? Meals else {return}
////                    print(json)
////                }
////                catch{
////                    print(error)
////                }
//            case .failure(let error):
//                print(error)
//            }
        }
    }
}
