//
//  WebservicesTests.swift
//  CommentsTests
//
//  Created by Yogesh Padekar on 04/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//
import XCTest

@testable import Comments

class WebserviceTests: XCTestCase {
   private let url = URL(string: CommentsConstants.APILink)
   private var data: Data? = nil
    // Before each unit test, setUp is called
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
               let testBundle = Bundle(for: type(of: self))
               if let testJSONURL = testBundle.url(forResource: "TestComments", withExtension: "json") {
                   do {
                    self.data = try Data(contentsOf: testJSONURL)
                   } catch {
                       debugLog("Error in fetching data from json file = \(error)")
                   }
               }
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.data = nil
    }
    
    func testCorrectAPICall() {
        let response = HTTPURLResponse(url: URL(string: CommentsConstants.APILink)!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, self.data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let task = mockSession.dataTask(with: url!, completionHandler: { (data, response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            guard let httpResponse = response as? HTTPURLResponse else {
                XCTFail("unexpected response")
                return
            }
            XCTAssertEqual(200, httpResponse.statusCode)
        })
        task.resume()
    }
    
    func testErrorResponse() {
        let response = HTTPURLResponse(url: URL(string: CommentsConstants.APILink)!,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)
        URLProtocolMock.mockURLs = [url: (NSError(domain: "", code: 1, userInfo: nil), self.data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let task = mockSession.dataTask(with: url!, completionHandler: { (data, response, error) in
            XCTAssertNotNil(error)
            XCTAssertNotNil(data)
            guard let httpResponse = response as? HTTPURLResponse else {
                XCTFail("unexpected response")
                return
            }
            XCTAssertNotEqual(200, httpResponse.statusCode, "Web service call not failing with \(httpResponse.statusCode)")
        })
        task.resume()
    }
}
