//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Александр Поляков on 09.04.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        app = XCUIApplication()
        app.launch()
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testExample() throws {
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton(){
        let firstPoster = app.images["Poster"] // Находим первоначальный постер
        app.buttons["Yes"].tap() // Находим кнопку 'Да' и нажимаем её
        
        let secondPoster = app.images["Poster"] // снова находим постер
        XCTAssertFalse(firstPoster == secondPoster) // сравниваем постеры
    }


}
