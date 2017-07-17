//
//  FlickrKitTests.swift
//  FlickrKitTests
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import XCTest
@testable import FlickrKit

class FlickrKitTests: XCTestCase {
    
    class MockFlickrClient: Flickring {
        open func getPhotoFeed(callback: @escaping (Result) -> ()) {
            callback(Result.Error(nil, NSError(domain: "com.flickr.client", code: 909, userInfo: nil)))
        }
    }
    
    var client: FlickrClient!

    override func setUp() {
        super.setUp()
        client = FlickrClient(apiKey: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertEqual(client.apiKey, "40025c16ac0058ec6e69dbca0dd9fc03")
    }
    
    func testGetFeed() {
        let exp = expectation(description: "getFeed")
        client.getPhotoFeed { (result) in
            let url = result.response()?.url?.absoluteString
            let data = result.data()
            XCTAssertNotNil(url)
            XCTAssertEqual("https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1", url!)
            XCTAssertNotNil(data)
            exp.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testURL() {
        let exp = expectation(description: "testURL")
        client.getPhotoFeed { (result) in
            let url = result.response()?.url?.absoluteString
            XCTAssertNotNil(url)
            XCTAssertEqual("https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1", url!)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testParsingObjects() {
        let exp = expectation(description: "parsingObjectsCount")
        client.getPhotoFeed { (result) in
            let data = result.data()
            XCTAssertNotNil(data)
            XCTAssertEqual(result.data().count, 20)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInpterpreterParsing() {
        let exp = expectation(description: "inpterpreterParsing")
        let dict = ["items": [
                ["title": "Demo Demo",
                 "media": ["m": "https://demo.com"],
                 "published": "2017-07-17T21:04:27Z"
                ]
            ]] as NSDictionary
        let intrMock = MockFlickrFeedInterpreter().interpret(json: nil, urlResponse: nil)
        let intr = FlickrFeedInterpreter().interpret(json: dict, urlResponse: nil)
        
        XCTAssertEqual(intrMock.data().first?.title, intr.data().first?.title)
        XCTAssertEqual(intrMock.data().first?.media, intr.data().first?.media)
        XCTAssertEqual(intrMock.data().first?.published, intr.data().first?.published)
        exp.fulfill()

        waitForExpectations(timeout: 10, handler: nil)
    }
}
