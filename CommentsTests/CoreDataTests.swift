//
//  CoreDataTests.swift
//  CommentsTests
//
//  Created by Yogesh Padekar on 06/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import XCTest
import CoreData

@testable import Comments

class CoreDataTests: XCTestCase {
    
    //Making these mockPersistantContainer static so that it can be reused in CommentViewModelTests as persistent container should be same
        
    // The customStorageManager specifies in-memory by providing a custom NSPersistentContainer
    static var mockPersistantContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "Comments")
           let description = NSPersistentStoreDescription()
           description.type = NSInMemoryStoreType
           description.shouldAddStoreAsynchronously = false
                
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
            }
            return container
        }()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let testBundle = Bundle(for: type(of: self))
        if let testJSONURL = testBundle.url(forResource: "TestComments", withExtension: "json") {
            do {
                let data = try Data(contentsOf: testJSONURL)
                let responseDecoder = JSONDecoder()
                responseDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataTests.mockPersistantContainer.viewContext
                let _ = try responseDecoder.decode([Comment].self, from: data)
                try CoreDataTests.mockPersistantContainer.viewContext.save()
            } catch {
                debugLog("Error in fetching data from json file or saving the context = \(error)")
            }
        }
    }
    
    override func tearDownWithError() throws {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: CommentsConstants.Comment)
        do {
            let comments = try CoreDataTests.mockPersistantContainer.viewContext.fetch(fetchRequest)
            for case let comment as NSManagedObject in comments {
                CoreDataTests.mockPersistantContainer.viewContext.delete(comment)
            }
            try CoreDataTests.mockPersistantContainer.viewContext.save()
        } catch {
            print("Error while fetching the records or saving the context = \(error)")
        }
    }
    
    func testFetchComments() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CommentsConstants.Comment)
        do {
            let rows = try CoreDataTests.mockPersistantContainer.viewContext.fetch(fetchRequest)
            XCTAssertEqual(rows.count, 10)
        } catch {
            debugLog("Error while fetching comments = \(error.localizedDescription)")
        }
    }
}
