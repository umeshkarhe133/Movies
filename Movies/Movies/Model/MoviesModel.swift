//
//  AppleApps.swift
//  SwiftMvc
//
//  Created by Umesh Karhe on 04/02/17.
//  Copyright © 2017 Umesh Karhe. All rights reserved.
//

import UIKit
import CoreData

class MoviesModel: BaseModel {
    
    override func processRequestWith(requestType: RequestType, parameters: [String : AnyObject]?) {
        self.fetchMoviesFromDataBase()
        let url = Utility.sharedInstance.getRequestUrlForRequestType(requestType: requestType)
        self.networkManager.getRequestWith(serviceUrl: url, methodType: .GET) { (respose, error) in
            if respose != nil {
                let notificationQueue = NotificationQueue()
                let notification = Notification(name: Notification.Name(rawValue: "NotificationMoviesData"), object: nil, userInfo: ["MoviesData" : respose ?? ""])
                notificationQueue.enqueue(notification, postingStyle: NotificationQueue.PostingStyle.whenIdle)
            }
        }
    }
    
    func fetchMoviesFromDataBase() -> Void {
        let context = Utility.appDelegate?.persistentContainer.viewContext
        let request = Movies.moviesFetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            let notificationQueue = NotificationQueue()
            let notification = Notification(name: Notification.Name(rawValue: "NotificationMoviesData"), object: nil, userInfo: ["MoviesData" : result ?? ""])
            notificationQueue.enqueue(notification, postingStyle: NotificationQueue.PostingStyle.whenIdle)
        } catch {
            
            print("Failed")
        }
        
    }
}
