//
//  Webservices.swift
//  Comments
//
//  Created by Yogesh Padekar on 03/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//
import UIKit
import CoreData

class WebServices {
    
    /// Function to get all comments from web service
    /// - Parameter completion: Returns a completion handler for view model to handle
    static func fetchCommentsFromAPIAndSaveInDatabase(completion: @escaping () -> Void) {
        let session = URLSession.shared
        if let urlComments = URL(string: CommentsConstants.APILink) {
            let task = session.dataTask(with: urlComments, completionHandler: { data, response, error in
                if error != nil || data == nil {
                    //if there is any error or data is nil then call completion
                    completion()
                } else {
                    // Create an array of comments
                    let responseDecoder = JSONDecoder()
                    DispatchQueue.main.async {
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            
                            //Clear existing comments before saving newly fetched comments
                            WebServices.clearComments()
                            
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
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(batchDeleteRequest)
            } catch let error as NSError {
                debugLog("Error while deleting comments from the database = \(error)")
            }
        }
    }
}
