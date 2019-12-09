//
//  NetworkingService.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 12. 01..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation

class NetworkingService {
    private init(){}
    static let shared = NetworkingService()
    
    func request(_ urlPath: String, completion: @escaping (Result<Data,NSError>)->Void){
        let session = URLSession.shared
        let url = URL(string: "https://www.themealdb.com/api/json/v2/1/random.php")!
        
        let task = session.dataTask(with: url) { data, _, error in
            
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError)) 
            }
            else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        
        task.resume()
    }
}
