//
//  DataPersistenceTest.swift
//  Wish-I-WatchTests
//
//  Created by Toni Lozano Fernández on 31/5/23.
//

import XCTest
import CoreData
@testable import Wish_I_Watch

final class DataPersistenceTest: XCTestCase {

    // Given
    var sut: DataPersistence?
    
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TitleDataModel", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        super.setUp()
        sut = DataPersistence(container: mockPersistentContainer)
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
