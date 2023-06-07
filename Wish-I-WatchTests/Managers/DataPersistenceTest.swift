//
//  DataPersistenceTest.swift
//  Wish-I-WatchTests
//
//  Created by Toni Lozano Fernández on 31/5/23.
//

import XCTest
@testable import Wish_I_Watch

final class DataPersistenceTest: XCTestCase {

    // Given
    var sut: DataPersistence?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = DataPersistence()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testLoadTitles_whenNoDataIsReceived_ReturnFailure() {
//        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
//            XCTAssertNil(wishlistTitles)
//        })
    }
    
    func testLoadTitles_whenDataIsReceived_ReturnSuccess() {
        
    }
    
    func testLoadTitles_whenFetchingContext_ReturnNilValues() {
        
    }
    
    func testFindPersistentTitle_whenIdNotFound_ReturnFailure() {
        
    }
    
    func testFindPersistentTitle_whenIdFound_ReturnSuccess() {
        
    }
}
