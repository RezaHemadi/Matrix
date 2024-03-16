//
//  MatrixTests.swift
//  MatrixTests
//
//  Created by Reza on 3/3/24.
//

import XCTest
@testable import Matrix

final class MatrixTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testSubscript_get() {
        let m = Mat<Int>((0...98).map{$0}, [33, 3])
        
        for i in 0..<33 {
            for j in 0..<3 {
                let value = m[i, j]
                let expectedValue = 3 * i + j
                XCTAssertEqual(value, expectedValue)
            }
        }
    }
    
    func testSubscript_set() {
        // Arrange
        var m = Mat<Int>((0...98).map{$0}, [33, 3])
        let row = Int.random(in: 0..<33)
        let col = Int.random(in: 0..<3)
        
        // Act
        m[row, col] = -1
        let value = m[row, col]
        
        // Assert
        XCTAssertEqual(value, -1, "subscript setter not correct!!")
    }
    
    func test_rowsCount() {
        // Arrange
        let rows = Int.random(in: 0...10)
        let cols = Int.random(in: 0...10)
        let values: [Int] = (0..<(rows * cols)).map{$0}
        
        // Act
        let m = Mat<Int>(values, [rows, cols])
        
        // Assert
        XCTAssertEqual(m.rows, rows, "matrix rows count is not corrent!")
    }
    
    func test_colsCount() {
        // Arrange
        let rows = Int.random(in: 0...10)
        let cols = Int.random(in: 0...10)
        let values: [Int] = (0..<(rows * cols)).map{$0}
        
        // Act
        let m = Mat<Int>(values, [rows, cols])
        
        // Assert
        XCTAssertEqual(m.cols, cols, "matrix column count is not correct!")
    }
    
    func test_valuesArray() {
        // Arrange
        let values: [Int] = (0..<99).map({_ in Int.random(in: 0...100)})
        let m = Mat<Int>(values, [33, 3])
        
        // Act
        let matrixValues = m.values
        
        // Assert
        XCTAssertEqual(values, matrixValues, "returned values from matrix are incorrect!")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
