//
//  Movies+CoreDataClass.swift
//  SwiftMvc
//
//  Created by Umesh Karhe on 02/02/18.
//  Copyright © 2018 Umesh Karhe. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Movies)
public class Movies: NSManagedObject {
    
    class func getMovieWithTitle(title: String) -> Movies {
        guard let context = Utility.appDelegate?.persistentContainer.viewContext else { fatalError() }
        let formatRequest = Movies.moviesFetchRequest()
        formatRequest.predicate = NSPredicate(format: "title == %@", title)
        var movie = Movies()
        do{
            let count = try context.count(for: formatRequest)
            if count == 0 {
                let entity = NSEntityDescription.entity(forEntityName: "Movies", in: context)
                let movieEntity = NSManagedObject(entity: entity!, insertInto: context) as! Movies
                movieEntity.title = title
                movie = movieEntity
            }else {
                let result = try context.fetch(formatRequest)
                if result.count > 0 {
                    movie = result[0]
                }
            }
        }catch {
            
        }
        return movie
    }
    
    func setAttributesForMovies(parameters: [String: Any]) -> Void {
        self.genre = parameters["genre"] as? [String]
        self.rating = (parameters["rating"] as? Float)!
        self.releaseYear = (parameters["releaseYear"] as? Int64)!
        self.image = parameters["image"] as? String
    }
}

