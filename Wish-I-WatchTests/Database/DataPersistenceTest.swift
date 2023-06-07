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
    
    override func setUp() {
        super.setUp()
        sut = DataPersistence()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadTitles_whenNoDataIsReceived_ReturnFailure() {
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
