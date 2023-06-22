//
//  Wish_I_WatchUITests.swift
//  Wish-I-WatchUITests
//
//  Created by Toni Lozano Fernández on 7/6/23.
//

import XCTest

final class Wish_I_WatchUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testSearchAndSaveTitle_whenSearchingTitlesByExistingTextAndResultSuccess() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let wishIWatchNavigationBarAndButton = app.navigationBars["Wish I Watch"].buttons["Search"]
        XCTAssertTrue(wishIWatchNavigationBarAndButton.exists)
        wishIWatchNavigationBarAndButton.tap()
        
        let searchField = app.tables["Empty list"].searchFields["Write a title..."]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("Avatar")
        
        let searchButton = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"buscar\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(searchField.exists)
        searchButton.tap()
        
        let cellsQuery = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"2009/12/15")/*[[".cells.containing(.staticText, identifier:\"In the 22nd century, a paraplegic Marine is dispatched to the moon Pandora on a unique mission, but becomes torn between following orders and protecting an alien civilization.\")",".cells.containing(.staticText, identifier:\"2009\/12\/15\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let saveTitleButton = cellsQuery.buttons["favorite"]
        XCTAssertTrue(saveTitleButton.exists)
        saveTitleButton.tap()
        
        let detailsButton = cellsQuery/*@START_MENU_TOKEN@*/.staticTexts["Details"]/*[[".buttons[\"Details\"].staticTexts[\"Details\"]",".staticTexts[\"Details\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(detailsButton.exists)
        detailsButton.tap()
        
        
        let navigationBarSaveTitleButton = app.navigationBars["Wish I Watch"].buttons["favorite"]
        XCTAssertTrue(navigationBarSaveTitleButton.exists)
        navigationBarSaveTitleButton.tap()
        
        let homeButton = app.tabBars["Tab Bar"].buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        homeButton.tap()
        
        let wishlistButton = app.tabBars["Tab Bar"].buttons["Wishlist"]
        XCTAssertTrue(wishlistButton.exists)
        wishlistButton.tap()
        
        
        let settingsButton = app.tabBars["Tab Bar"].buttons["Settings"]
        XCTAssertTrue(settingsButton.exists)
        settingsButton.tap()
        
        let trashButton = app.tables/*@START_MENU_TOKEN@*/.buttons["trash"]/*[[".cells.buttons[\"trash\"]",".buttons[\"trash\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(trashButton.exists)
        trashButton.tap()
        
        let okAlertButton = app.alerts["Confirm"].scrollViews.otherElements.buttons["OK"]
        XCTAssertTrue(okAlertButton.exists)
        okAlertButton.tap()
        
        trashButton.tap()
        
        let cancelAlertButton = app.alerts["Confirm"].scrollViews.otherElements.buttons["CANCEL"]
        XCTAssertTrue(cancelAlertButton.exists)
        cancelAlertButton.tap()
                        
    }

}
