//
//  TicTacToeNxNDimensional.swift
//  TicTacToeTests
//
//  Created by Jared Franzone on 12/19/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import XCTest
@testable import TicTacToe


class TicTacToeNxNDimensional: XCTestCase {
    
    
    var game: TicTacToeGame?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     tests the the TicTacToe and Board structs when the dimension is not 3x3
     1) checks if Row win can be determined
     2) checks if Col win can be determined
     3) checks of Diagonal win can be determined
     */
    func testSomeDifferentDimensions() {
        
        for i in 2...5 {
            
            game = TicTacToeGame(players: ["J", "B"], boardSize: i)
            
            // win
            setupRowWinScenario(n: i)
            XCTAssertTrue(game?.checkStatus() == .win)
            
            game?.reset()
            
            setupColWinScenario(n: i)
            XCTAssertTrue(game?.checkStatus() == .win)
            
            game?.reset()
            
            setupDiagWinScenario(n: i)
            XCTAssertTrue(game?.checkStatus() == .win)
            
        }
        
    }
    
    
    /**
     Helper functions to setup different scenarios
    */
    func setupRowWinScenario(n: Int) {
        for i in 0..<n {
            game!.board.board[0][i] = Piece(owner: Player(name: "J"))
        }
    }
    
    func setupColWinScenario(n: Int) {
        for i in 0..<n {
            game!.board.board[i][0] = Piece(owner: Player(name: "J"))
        }
    }
    
    func setupDiagWinScenario(n: Int) {
        for i in 0..<n {
            game!.board.board[i][i] = Piece(owner: Player(name: "J"))
        }
    }

    
}
