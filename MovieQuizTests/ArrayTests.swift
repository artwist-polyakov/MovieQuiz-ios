//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Александр Поляков on 07.04.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests :XCTestCase {
    
    // тест на успешное взятие элемента по индексу
    func testGetValueInRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
    }
    
    // тест на взятие элемента по неправильному индексу
    func testGetValueOutRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
}

