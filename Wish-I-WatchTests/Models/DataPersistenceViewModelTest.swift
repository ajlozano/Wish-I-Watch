//
//  DataPersistenceViewModelTest.swift
//  Wish-I-WatchTests
//
//  Created by Toni Lozano Fernández on 31/5/23.
//

import XCTest

@testable import Wish_I_Watch

final class DataPersistenceViewModelTest: XCTestCase {

    // Given
    var sut: DataPersistenceViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = DataPersistenceViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetTitles_whenDataIsEmpty() {
        // When
        sut?.getTitles()
        
        // Then
        XCTAssertTrue(sut!.viewedTitles.value!.isEmpty, "viewedTitles expected to be empty.")
        XCTAssertTrue(sut!.wishlistTitles.value!.isEmpty, "wishlistTitles expected to be empty.")
    }
    
    func testGetTitles_whenDataIsNotEmpty() {
        
        // When
        sut?.getTitles()
        
        // Then
        XCTAssertFalse(sut!.viewedTitles.value!.isEmpty, "viewedTitles expected to be not empty.")
        XCTAssertFalse(sut!.wishlistTitles.value!.isEmpty, "wishlistTitles expected to be not empty.")
    }
    
    
}
