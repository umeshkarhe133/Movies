//
//  Constants.swift
//  SwiftMvc
//
//  Created by Umesh Karhe on 04/02/17.
//  Copyright © 2017 Umesh Karhe. All rights reserved.
//

import Foundation

enum ModelType {
    case MoviesModel
}
enum RequestType {
    case GetTopMovies
}

struct Constants {
    static let baseUrl = "https://api.androidhive.info/json/movies.json"
}

enum MethodType {
    case GET
    case PUT
    case POST
}



