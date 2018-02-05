//
//  NetworkManager.swift
//  SwiftMvc
//
//  Created by Umesh Karhe on 21/01/18.
//  Copyright © 2018 Umesh Karhe. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    
    static let sharedInstance  = NetworkManager()
    private override init() {
    }
    
    func getRequestWith(serviceUrl: String, methodType: MethodType,  completionHandler: @escaping (_ response: Any?, _ error: Error?)-> Void) {
        let url = URL(string: serviceUrl)
        do {
            let jsonData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            do{
                let responseData = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                var moviesArray  = [Movies]()
                for dictionary in responseData {
                    let title = dictionary["title"] as! String
                    let movie = Movies.getMovieWithTitle(title: title)
                    movie.setAttributesForMovies(parameters: dictionary)
                    moviesArray.append(movie)
                }
                try Utility.appDelegate?.persistentContainer.viewContext.save()
                completionHandler(moviesArray, nil)
                
            }catch let error {
                completionHandler(nil, error)
            }
        }catch let error {
            completionHandler(nil, error)
        }
    }
}
