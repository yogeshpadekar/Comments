//
//  CommentViewModelTests.swift
//  CommentsTests
//
//  Created by Yogesh Padekar on 02/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//
import XCTest
import CoreData

@testable import Comments

class CommentViewModelTests: XCTestCase {
    private lazy var comments: [Comment] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
         let testBundle = Bundle(for: type(of: self))
            if let testJSONURL = testBundle.url(forResource: "TestComments", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: testJSONURL)
                    let responseDecoder = JSONDecoder()
                    responseDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataTests.mockPersistantContainer.viewContext
                    self.comments = try responseDecoder.decode([Comment].self, from: data)
                    try CoreDataTests.mockPersistantContainer.viewContext.save()
                } catch {
                    debugLog("Error in fetching data from json file or saving the context = \(error)")
                }
            }
    }
    
    override func tearDownWithError() throws {
        self.comments.removeAll()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: CommentsConstants.Comment)
        do {
            let allComments = try CoreDataTests.mockPersistantContainer.viewContext.fetch(fetchRequest)
            for case let comment as NSManagedObject in allComments {
                CoreDataTests.mockPersistantContainer.viewContext.delete(comment)
            }
            try CoreDataTests.mockPersistantContainer.viewContext.save()
        } catch {
            print("Error while fetching the records or saving the context = \(error)")
        }
    }
    
    // MARK: - View Model Tests
    func testCommentsCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(self.comments.count, 10)
    }
    
    
    func testViewModelIds() {
        let commentViewModel1 = CommentViewModel(comment: self.comments[1])
        let commentViewModel2 = CommentViewModel(comment: self.comments[5])
        let commentViewModel3 = CommentViewModel(comment: self.comments[8])
        XCTAssertEqual(commentViewModel1.id, "2")
        XCTAssertEqual(commentViewModel2.id, "6")
        XCTAssertEqual(commentViewModel3.id, "9")
    }
    
    func testViewModelPostIds() {
        let commentViewModel1 = CommentViewModel(comment: self.comments[0])
        let commentViewModel2 = CommentViewModel(comment: self.comments[4])
        let commentViewModel3 = CommentViewModel(comment: self.comments[7])
        XCTAssertEqual(commentViewModel1.postId, "1")
        XCTAssertEqual(commentViewModel2.postId, "1")
        XCTAssertEqual(commentViewModel3.postId, "2")
    }
    
    func testViewModelEmails() {
        let commentViewModel1 = CommentViewModel(comment: self.comments[2])
        let commentViewModel2 = CommentViewModel(comment: self.comments[6])
        let commentViewModel3 = CommentViewModel(comment: self.comments[8])
        XCTAssertEqual(commentViewModel1.email, "Nikita@garfield.biz")
        XCTAssertEqual(commentViewModel2.email, "Dallas@ole.me")
        XCTAssertEqual(commentViewModel3.email, "Meghan_Littel@rene.us")
    }
    
    func testViewModelTitles() {
        let commentViewModel1 = CommentViewModel(comment: self.comments[3])
        let commentViewModel2 = CommentViewModel(comment: self.comments[5])
        let commentViewModel3 = CommentViewModel(comment: self.comments[9])
        XCTAssertEqual(commentViewModel1.title, "alias odio sit")
        XCTAssertEqual(commentViewModel2.title, "et fugit eligendi deleniti quidem qui sint nihil autem")
        XCTAssertEqual(commentViewModel3.title, "eaque et deleniti atque tenetur ut quo ut")
    }
    
    func testViewModelBodies() {
        let commentViewModel1 = CommentViewModel(comment: self.comments[0])
        let commentViewModel2 = CommentViewModel(comment: self.comments[1])
        let commentViewModel3 = CommentViewModel(comment: self.comments[2])
        XCTAssertEqual(commentViewModel1.body, "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")
        XCTAssertEqual(commentViewModel2.body, "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et")
        XCTAssertEqual(commentViewModel3.body, "quia molestiae reprehenderit quasi aspernatur\naut expedita occaecati aliquam eveniet laudantium\nomnis quibusdam delectus saepe quia accusamus maiores nam est\ncum et ducimus et vero voluptates excepturi deleniti ratione")
    }
    
}
