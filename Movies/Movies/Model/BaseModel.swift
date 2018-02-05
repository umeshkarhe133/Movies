//
//  BaseModel.swift
//  SwiftMvc
//
//  Created by Umesh Karhe on 04/02/17.
//  Copyright © 2017 Umesh Karhe. All rights reserved.
//

import Foundation

class BaseModel: NSObject {
    lazy var networkManager = NetworkManager.sharedInstance
    class func getModelOfType(modelType: ModelType) -> BaseModel {
        var model = BaseModel()
        
        switch modelType {
        case .MoviesModel:
            model = MoviesModel ()
        default:
            break
        }
        return model
    }
    
    func processRequestWith(requestType: RequestType, parameters: [String: AnyObject]?) {
        
    }
}
