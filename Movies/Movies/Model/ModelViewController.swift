//
//  ModelViewController.swift
//  SwiftMvc
//
//  Created by Umesh Karhe on 04/02/17.
//  Copyright © 2017 Umesh Karhe. All rights reserved.
//

import Foundation

class ModelViewController {
    static let sharedInstance = ModelViewController()
    var modelCollection = [ModelType: BaseModel]()
    
    private init() {
    }
    
    func processRequestWith(requestType: RequestType, modelType: ModelType, parameters: [String: AnyObject]?) -> Void {
        var model = modelCollection[modelType]
        if model == nil {
            model = BaseModel.getModelOfType(modelType: modelType)
            modelCollection[modelType] = model
        }
        model?.processRequestWith(requestType: requestType, parameters: nil)
    }
}
