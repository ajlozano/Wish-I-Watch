//
//  FetchPostsRepositoryTests.swift
//  Wish-I-WatchTests
//
//  Created by Toni Lozano Fernández on 7/6/23.
//

import XCTest
@testable import Wish_I_Watch

final class FetchPostsRepositoryTests: XCTestCase {

    // GIVEN
    var sut: FetchPostsRepository?
    var sutMockFailure: FetchPostsRepository?
    var sutMockSuccess: FetchPostsRepository?
    var sutMockEmptySearch: FetchPostsRepository?
    
    override func setUp() {
        super.setUp()
        sut = DefaultFetchPostsRepository()
        sutMockFailure = DefaultFetchPostsRepository(apiService: MockFailureApiService())
        sutMockSuccess = DefaultFetchPostsRepository(apiService: MockSuccessApiService())
        sutMockEmptySearch = DefaultFetchPostsRepository(apiService: MockEmptySearchApiService())
    }
    
    override func tearDown() {
        sut = nil
        sutMockFailure = nil
        sutMockSuccess = nil
        super.tearDown()
    }
    
    func testFetchPosts_whenIsPostTitlesAndResultSuccess() {
        let expt = self.expectation(description: "I expect a success result and inflate decodable data")

        // WHEN
        Task {
            do {
                let urlString = "\(Endpoints.urlSearchHeader)Harakiri\(Endpoints.urlSearchFooter)"
                
                guard let decodable = try await sutMockSuccess?.fetchPosts(url: urlString) else {
                    return
                }
                // THEN
                XCTAssertNotNil(decodable)
                expt.fulfill()
            } catch {
                // THEN
                XCTAssertNil(error)
                expt.fulfill()
            }
        }
        
        wait(for: [expt], timeout: 10.0)
    }

    func testFetchPosts_whenIsPostTitlesAndResultFailure() {
        let expt = self.expectation(description: "I expect a failure error")
        
        // WHEN
        Task {
            do {
                let urlString = "\(Endpoints.urlSearchHeader)Harakiri\(Endpoints.urlSearchFooter)"
                
                guard let decodable = try await sutMockFailure?.fetchPosts(url: urlString) else {
                    return
                }
                // THEN
                XCTAssertNil(decodable)
                expt.fulfill()
            } catch {
                // THEN
                XCTAssertNotNil(error)
                expt.fulfill()
            }
        }
        
        wait(for: [expt], timeout: 10.0)
    }
    
    func testFetchPosts_whenIsPostEmptyAndResultFailure() {
        let expt = self.expectation(description: "I expect a failure error for empty search")
        
        // WHEN
        Task {
            do {
                let urlString = "\(Endpoints.urlSearchHeader)\(Endpoints.urlSearchFooter)"
                
                guard let decodable = try await sutMockEmptySearch?.fetchPosts(url: urlString) else {
                    return
                }
                // THEN
                XCTAssertTrue(decodable.listOfTitles.isEmpty)
                expt.fulfill()
            } catch {
                // THEN
                XCTAssertNotNil(error)
                expt.fulfill()
            }
        }
        
        wait(for: [expt], timeout: 10.0)
    }
    
    func testFetchPosts_whenIsPostCharactersAndResultFailureForInvalidUrl() {
        let expt = self.expectation(description: "I expect a failure error for invalid url")
        
        // WHEN
        Task {
            do {
                guard let decodable = try await sut?.fetchPosts(url: "incorrect url") else {
                    return
                }
                // THEN
                XCTAssertNil(decodable)
                expt.fulfill()
            } catch {
                // THEN
                XCTAssertNotNil(error)
                expt.fulfill()
            }
        }
        
        wait(for: [expt], timeout: 10.0)
    }
    
}
