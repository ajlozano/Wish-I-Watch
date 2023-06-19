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

    // GIVEN
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
        self.sut = DataPersistence(container: self.mockPersistentContainer)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadTitlesWhenIsEmptyData() {
        // WHEN
        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            // THEN
            XCTAssertEqual(wishlistTitles.count, 0)
            XCTAssertEqual(viewedTitles.count, 0)
        })
    }
    
    func testSaveAndLoadTitlesWhenResultWithData() {
        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            XCTAssertEqual(wishlistTitles.count, 0)
            XCTAssertEqual(viewedTitles.count, 0)
        })
        // WHEN
        for i in 1...11 {
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)))
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)),
                isWishlistItem: false)
        }
        
        sut?.saveTitles{ _, _ in }
        
        // WHEN
        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            // THEN
            XCTAssertEqual(wishlistTitles.count, 11)
            XCTAssertEqual(viewedTitles.count, 11)
        })
    }
    
    func testFindPersistentTitleWhenIdNotFoundAndReturnFailure() {
        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            XCTAssertEqual(wishlistTitles.count, 0)
            XCTAssertEqual(viewedTitles.count, 0)
        })
        
        // WHEN
        for i in 1...5 {
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)))
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)),
                isWishlistItem: false)
        }
        
        sut?.saveTitles{ _, _ in }
        
        // THEN
        XCTAssertNil(sut?.findPersistentTitle(id: 6))
        XCTAssertNil(sut?.findPersistentTitle(id: 6, isWishlistTitle: false))
    }
    
    func testFindPersistentTitleWhenIdFoundAndReturnSuccess() {
        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            XCTAssertEqual(wishlistTitles.count, 0)
            XCTAssertEqual(viewedTitles.count, 0)
        })
        
        // WHEN
        for i in 1...3 {
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)))
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)),
                isWishlistItem: false)
        }
        
        sut?.saveTitles{ _, _ in }
        
        // THEN
        XCTAssertNotNil(sut?.findPersistentTitle(id: 1))
        XCTAssertNotNil(sut?.findPersistentTitle(id: 2, isWishlistTitle: false))
    }
    
    func testDeleteTitles() {
        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            XCTAssertEqual(wishlistTitles.count, 0)
            XCTAssertEqual(viewedTitles.count, 0)
        })

        // WHEN
        for i in 1...3 {
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)))
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)),
                isWishlistItem: false)
        }

        //sut?.saveTitles{ _, _ in }

        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            XCTAssertEqual(wishlistTitles.count, 3)
            XCTAssertEqual(viewedTitles.count, 3)
            XCTAssertNotNil(sut?.findPersistentTitle(id: 2))
            XCTAssertNotNil(sut?.findPersistentTitle(id: 3, isWishlistTitle: false))
        })

        sut?.deleteTitles(indexTitle: sut?.findPersistentTitle(id: 2) ?? 0)
        sut?.deleteTitles(indexTitle: sut?.findPersistentTitle(id: 3, isWishlistTitle: false) ?? 0, isWishlistTitle: false)

        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            // THEN
            XCTAssertEqual(wishlistTitles.count, 2)
            XCTAssertEqual(viewedTitles.count, 2)
            XCTAssertNil(sut?.findPersistentTitle(id: 2))
            XCTAssertNil(sut?.findPersistentTitle(id: 3, isWishlistTitle: false))
        })
    }
    
    func testDeleteAllData() {
        sleep(10)
        
        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            XCTAssertEqual(wishlistTitles.count, 0)
            XCTAssertEqual(viewedTitles.count, 0)
        })

        // WHEN
        for i in 1...3 {
            sut?.setupItem(
                item: Title(id: i, name: "\(i)", overview: "\(i)", date: "\(i)", posterPath: "\(i)", voteAverage: Double(i)))
        }

        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            XCTAssertEqual(wishlistTitles.count, 3)
        })

        sut?.saveTitles{ _, _ in }

        sut?.deleteAllData()

        sut?.loadTitles(completion: { wishlistTitles, viewedTitles in
            // THEN
            XCTAssertEqual(wishlistTitles.count, 0)
        })
    }

}
