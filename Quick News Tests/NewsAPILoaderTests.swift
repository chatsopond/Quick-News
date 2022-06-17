//
//  NewsAPILoaderTests.swift
//  Quick News Tests
//
//  Created by Chatsopon Deepateep on 17/6/2565 BE.
//

import XCTest
@testable import Quick_News

class NewsAPILoaderTests: XCTestCase {
    
    /// System Under Testing `NewsAPIRequestLoader`
    var sut: NewsAPIRequestLoader!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NewsAPIRequestLoader()
        
        // Mock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sut.urlSession = URLSession(configuration: configuration)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetArticlesSuccess() async {
        // Given
        let params = (query: "apple", size: 9, page: 1)
        let mockJsonData = JsonLoader
            .stringFrom(for: type(of: self),
                        forResource: "everything-apple-ps9-p1")
            .data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockJsonData)
        }
        
        // When
        let articles = try? await sut.loadArticlesRequest(q: params.query,
                                                          pageSize: params.size,
                                                          page: params.page)
        
        // Then
        XCTAssertNotNil(articles)
        XCTAssertEqual(articles!.count, 9)
    }
    
    func testGetDifferentPage() async {
        // Given
        let query = "apple"
        let size = 9
        let mockData1 = JsonLoader
            .stringFrom(for: type(of: self),
                        forResource: "everything-apple-ps9-p1")
            .data(using: .utf8)!
        let mockData2 = JsonLoader
            .stringFrom(for: type(of: self),
                        forResource: "everything-apple-ps9-p2")
            .data(using: .utf8)!
        
        // When
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData1)
        }
        let articles1 = try? await sut.loadArticlesRequest(q: query,
                                                           pageSize: size,
                                                           page: 1)
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData2)
        }
        let articles2 = try? await sut.loadArticlesRequest(q: query,
                                                           pageSize: size,
                                                           page: 2)
        
        // Then
        XCTAssertNotNil(articles1)
        XCTAssertNotNil(articles2)
        XCTAssertEqual(articles1!.count, 9)
        XCTAssertEqual(articles2!.count, 9)
        XCTAssertNotEqual(articles1!.first!, articles2!.first!)
    }
}
