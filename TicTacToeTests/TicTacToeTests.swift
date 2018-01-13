//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Jared Franzone on 12/18/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import XCTest
@testable import TicTacToe

class TicTacToeTests: XCTestCase {
    
    var game: TicTacToeGame?
    
    override func setUp() {
        super.setUp()
        game = TicTacToeGame(players: ["J", "B"], boardSize: 3)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Test Helper functions
    
    /**
     tests the AllEqual() function in the following scenarios:
     1) normal success case
     2) missing piece case
     3) another pice is in the list
     */
    func testAllEqual() {
        
        let first = Piece(owner: Player(name: "X"))
        var piecesArr = [Piece?]()
    
        // 1
        piecesArr.append(first)
        piecesArr.append( Piece(owner: Player(name: "X")) )
        piecesArr.append( Piece(owner: Player(name: "X")) )
        
        XCTAssertTrue(game!.allEqual(type: first, inArray: piecesArr))
        
        // 2
        piecesArr.removeAll()
        piecesArr.append(first)
        piecesArr.append( nil )
        piecesArr.append( Piece(owner: Player(name: "X")) )
        
        XCTAssertTrue(game!.allEqual(type: first, inArray: piecesArr) == false)
        
        // 3
        piecesArr.removeAll()
        piecesArr.append(first)
        piecesArr.append( Piece(owner: Player(name: "Y")) )
        piecesArr.append( Piece( owner: Player(name: "X")) )
        
        XCTAssertTrue(game!.allEqual(type: first, inArray: piecesArr) == false)
    }
    
    
    /**
     tests the GetColumn() function in the following scenarios:
     1) normal success case
     2) when there is a nil element in the set
     */
    func testGetColumn() {
        
        // 1
        var board = [[Piece?]]()
        
        board.append([Piece?]())
        board.append([Piece?]())
        board.append([Piece?]())
        
        board[0].append(Piece(owner: Player(name: "X")))
        board[1].append(Piece(owner: Player(name: "X")))
        board[2].append(Piece(owner: Player(name: "X")))

        let colVector = game!.getColumn(colIdx: 0, fromArray: board)
        
        for element in colVector {
            XCTAssertTrue(element != nil)
            XCTAssertTrue(element?.owner.name == "X")
        }
        
        // 2
        board[0].append(Piece(owner: Player(name: "X")))
        board[1].append(nil)
        board[2].append(Piece( owner: Player(name: "X")))
        
        let colVector2 = game!.getColumn(colIdx: 1, fromArray: board)
    
        XCTAssertTrue(colVector2[0] != nil)
        XCTAssertTrue(colVector2[1] == nil)
        XCTAssertTrue(colVector2[2] != nil)

        XCTAssertTrue(colVector2[0]?.owner.name == "X")
        XCTAssertTrue(colVector2[2]?.owner.name == "X")

    }
    
    
    /**
     tests the PlacePice() function in the following scenarios:
     1) normal success case
     */
    func testNormalPlacePice() {
        
        // 1
        do {
            try game?.placePieceAt(location: (0,0))
        } catch MoveError.outOfBounds {
            print("MoveError.outOfBounds")
        } catch MoveError.placeTaken {
            print("MoveError.placeTaken")
        } catch {
            print("Some Error")
        }
        
        print("Normal Move")
        XCTAssertTrue( game?.board.board[0][0] != nil )
        XCTAssertTrue( game?.board.board[0][0]?.owner.name == "J" )
    }
    
    /**
     tests the PlacePice() function in the following scenarios:
     1) out of bounds case
     */
    func testOutOfBoundsPlacePiece() {
        
        // 1
        do {
            try game?.placePieceAt(location: (-1,0))
        } catch MoveError.outOfBounds {
            
            print("Out of Bounds")
            XCTAssertTrue(true)
            
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
    }
    
    /**
     tests the PlacePice() function in the following scenarios:
     1) spot already taken case
     */
    func testSpotTakenPlacePiece() {
  
        // 1
        do {
            try game?.placePieceAt(location: (0,0))
            try game?.placePieceAt(location: (0,0))
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            print("Place Taken")
            XCTAssertTrue(true)
            XCTAssertTrue(game?.currPlayerIdx == 1)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    
    /**
     tests the checkRowWin() function in the following scenarios:
     1) normal row win case
     2) when there is a piece in the way
     */
    func testCheckRowWin() {
        
        // 1
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,2))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        
        XCTAssertTrue((game?.checkRowWin(board: (game?.board.board)!)) != nil)
        XCTAssertTrue((game?.checkRowWin(board: (game?.board.board)!))! == "J")
        

        // 2
        game?.reset()
        
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (1,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,0) )
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,2))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue((game?.checkColWin(board: (game?.board.board)!)) == nil)
        
    }
    
    
    /**
     tests the checkColWin() function in the following scenarios:
     1) normal col win case
     2) when there is a piece in the way
     */
    func testCheckColWin() {
        // 1
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (2,2))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,1))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue((game?.checkColWin(board: (game?.board.board)!)) != nil)
        XCTAssertTrue((game?.checkColWin(board: (game?.board.board)!))! == "J")
        
        game?.reset()
        
        // 2
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (2,2))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,0))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue((game?.checkColWin(board: (game?.board.board)!)) == nil)
        
    }
    
    
    /**
     tests the checkDiagWin() function in the following scenarios:
     1) downward diagonal win case
     2) downward diagonal when another piece is in the way
     3) downward diagonal when missing a piece in the middle
     4) upward (opposite) diagonal win case
     5) upward (opposite) when another piece is in the way
     */
    func testDiagonalsWin() {
        
        // 1
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,2))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,2))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
      
        XCTAssertTrue((game?.checkDiagonalsWin(board: (game?.board.board)!)) != nil)
        XCTAssertTrue((game?.checkDiagonalsWin(board: (game?.board.board)!))! == "J")
        
        game?.reset()
        
        // 2
        
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (1,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,2))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,2))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue((game?.checkDiagonalsWin(board: (game?.board.board)!)) == nil)
        
        game?.reset()
        
        // 3
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,2))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue((game?.checkDiagonalsWin(board: (game?.board.board)!)) == nil)
        game?.reset()
        
        // 4
        
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (2,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (2,2))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,2))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue((game?.checkDiagonalsWin(board: (game?.board.board)!)) != nil)
        XCTAssertTrue((game?.checkDiagonalsWin(board: (game?.board.board)!))! == "J")
        
        
        game?.reset()
        
        // 5
        
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (1,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,2))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,2))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue((game?.checkDiagonalsWin(board: (game?.board.board)!)) == nil)
    }
    
    
    /**
     tests the allSpotsFilled() function in the following scenarios:
     1) all spots not filled
     2) all spots filled
     */
    func testAllSpotsFilled() {
        
        // 1
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,0))
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue(game!.allSpotsFilled(board: game!.board.board) == false)
        
        // 2
        game?.reset()
        
        do {
            
            for row in 0..<game!.boardSize {
                for col in 0..<game!.boardSize {
                    try game?.placePieceAt(location: (row,col))
                }
            }
            
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue(game!.allSpotsFilled(board: game!.board.board) == true)
        
    }
    
    
    /**
     tests the checkGameStatus() function in the following scenarios:
     1) normal '.noChange'
     2) .win
     3) .draw
     */
    func testCheckGameStatus() {
        
        // 1
        do {
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (1,1))
        
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        let stat = game!.checkStatus()
        
        XCTAssertTrue(stat == .noChange)
        
        // 2
        do {
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (0,0))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (0,1))
            
            XCTAssertTrue(game?.currPlayerIdx == 1)
            try game?.placePieceAt(location: (2,2))
            
            XCTAssertTrue(game?.currPlayerIdx == 0)
            try game?.placePieceAt(location: (2,1))
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        let stat2 = game!.checkStatus()
        
        XCTAssertTrue(stat2 == .win)
        
        
        game?.reset()
        
        // 3
        
        do {
            
            try game?.placePieceAt(location: (0,0))
            try game?.placePieceAt(location: (0,1))
            try game?.placePieceAt(location: (0,2))
            try game?.placePieceAt(location: (1,0))
            try game?.placePieceAt(location: (1,1))
            try game?.placePieceAt(location: (2,0))
            try game?.placePieceAt(location: (1,2))
            try game?.placePieceAt(location: (2,2))
            try game?.placePieceAt(location: (2,1))
            
        } catch MoveError.outOfBounds {
            XCTAssertTrue(false)
        } catch MoveError.placeTaken {
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(false)
        }
        
        let stat3 = game!.checkStatus()
        XCTAssertTrue(stat3 == .draw)
        
    }
    
    
    
}
