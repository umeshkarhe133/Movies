//
//  Utility.swift
//  SwiftMvc
//
//  Created by Umesh Karhe on 21/01/18.
//  Copyright © 2018 Umesh Karhe. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    static let sharedInstance = Utility()
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private init() {
        
    }
    
    func getRequestUrlForRequestType(requestType: RequestType) -> String {
        let baseURl = Constants.baseUrl
        switch requestType {
        case .GetTopMovies:
            return  baseURl
        }
    }
    
    func createDirectoryWithName(directoryName: String) -> String {
        let directory = getDocumentDirectoryPath().appendingFormat("/%@", directoryName)
        if !FileManager.default.fileExists(atPath: directory) {
            try! FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        }
        return directory
    }
    
    func getDocumentDirectoryPath() -> String{
        let paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String = paths[0] as? String ?? ""
        return documentsDirectory
    }
}
