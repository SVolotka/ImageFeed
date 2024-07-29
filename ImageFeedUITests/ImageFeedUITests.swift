//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Sergei Volotka on 23.07.2024.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    private let email = ""
    private let password = ""
    private let nameLastName = ""
    private let username = ""
    
    override func setUpWithError() throws {
        continueAfterFailure = false //
        app.launchArguments = ["testMode"]
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    private func dismissKeyboard() {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText(email)
        dismissKeyboard()
        // webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        dismissKeyboard()
        //webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.buttons["likeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
        cell.swipeUp()
        
    }
    
    func testProfile() throws {
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[nameLastName].exists)
        XCTAssertTrue(app.staticTexts[username].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["logoutAlert"].scrollViews.otherElements.buttons["Да"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
}
