//
//  Movies+CoreDataProperties.swift
//  Movies
//
//  Created by Umesh Karhe on 04/02/18.
//  Copyright © 2018 Umesh Karhe. All rights reserved.
//
//

import Foundation
import CoreData


extension Movies {

    @nonobjc public class func moviesFetchRequest() -> NSFetchRequest<Movies> {
        return NSFetchRequest<Movies>(entityName: "Movies")
    }

    @NSManaged public var genre: [String]?
    @NSManaged public var image: String?
    @NSManaged public var rating: Float
    @NSManaged public var releaseYear: Int64
    @NSManaged public var title: String?

}
