//
//  DataManager.swift
//  Comments
//
//  Created by Yogesh Padekar on 03/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.

///This class is responsible to fetch the data from web service and save it in core data

import UIKit
import CoreData

class DataManager {
    
    /// Function to get all comments from web service
    /// - Parameter completion: Returns a completion handler for view model to handle
    static func fetchCommentsFromAPIAndSaveInDatabase(completion: @escaping () -> Void) {
        let session = URLSession.shared
        if let urlComments = URL(string: CommentsConstants.APILink) {
            let task = session.dataTask(with: urlComments, completionHandler: { data, response, error in
                if error != nil || data == nil || (response as? HTTPURLResponse)?.statusCode != 200 {
                    //if there is any error or data is nil then call completion
                    completion()
                } else {
                    // Create an array of comments
                    let responseDecoder = JSONDecoder()
                    DispatchQueue.main.async {
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            
                            //Clear existing comments before saving newly fetched comments
                            DataManager.clearComments()
                            
                            responseDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = appDelegate.persistentContainer.viewContext
                            do {
                                let _ = try responseDecoder.decode([Comment]?.self, from: data ?? Data())
                                try appDelegate.persistentContainer.viewContext.save()
                            } catch {
                                debugLog("Error while decoding or saving the data fetched from server = \(error.localizedDescription)")
                            }
                            completion()
                        }
                    }
                }
            })
            task.resume()
        } else {
            debugLog("There was an error in creating the web service URL")
        }
    }
    
    /// Function to delete existing comments from the database
    static private func clearComments() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CommentsConstants.Comment)
            do {
                let comments = try managedObjectContext.fetch(fetchRequest)
                for case let comment as NSManagedObject in comments {
                    managedObjectContext.delete(comment)
                }
                try managedObjectContext.save()
            } catch {
                debugLog("Error while fetching the records or saving the context = \(error)")
            }
        }
    }
}
