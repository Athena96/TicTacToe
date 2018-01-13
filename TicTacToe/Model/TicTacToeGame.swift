//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by Jared Franzone on 12/18/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation

enum MoveError: Error {
    case outOfBounds
    case placeTaken
}

/// This struct represents a tic tac toe game
struct TicTacToeGame {
    
    /// the players of the game
    var players: [Player]
    
    /// the game board
    var board: Board
    
    /// an index pointing to the current players turn (in the 'players' array)
    var currPlayerIdx: Int
    
    /// the size of the
    let boardSize: Int
    
    
    /// the winner of the game; is nil till somone wins
    var winner: String?
    
    /// an enum for the different status' of the game
    enum GameStatus: String {
        case draw
        case win
        case noChange
    }
    

    /**
     creates a new instance of a TicTacToeGame, of size 'boardSize' with
     'players' different players.
     
     - Parameters:
     - players: an array containing a list of the players names
     - boardSize: an integer describing the size of the board
     */
    init(players: [String], boardSize: Int) {
        
        self.players = [Player]()
        
        for player in players {
            self.players.append( Player(name: player) )
        }
        
        self.boardSize = boardSize
        
        self.board = Board(size: boardSize)
        
        self.currPlayerIdx = 0
        
    }

    
    
    /// MARK: Outside Interfacing Methods
    
    /**
     Tries to place a piece at a certain place on the game board. Throws errors
     if the location is out of bounds of if the spot is taken.
     
     - Parameters:
     - location: a tupe (row,col) for where the user wants to place the piece.
     */
    public mutating func placePieceAt( location: (row:Int,col:Int) ) throws {
        
        // check out of bounds
        if location.row >= self.boardSize || location.row < 0 || location.col >= self.boardSize || location.col < 0 {
            //return false // out of bounds
            throw MoveError.outOfBounds
        }
        
        // place taken
        if self.board.board[location.row][location.col] != nil {
            throw MoveError.placeTaken
        }
        
        let newPiece = Piece(owner: self.players[currPlayerIdx])
        
        // add to board
        self.board.board[location.row][location.col] = newPiece
        
        // change players turn
        self.currPlayerIdx += 1
        if self.currPlayerIdx == (self.players.count) {
            self.currPlayerIdx = 0
        }
        
    }
    
    /**
     Check what the status of the game is, use this after a move is made.
     
     - Returns: a GameStatus instance that is either (win,draw, noChange) if .win
        is returned, you can check 'game.winner' to get the winner of the game
     */
    public mutating func checkStatus() -> GameStatus {
        
        // check row
        if let winner = checkRowWin(board: self.board.board) {
            self.winner = winner
            return .win
        }
        
        // check col
        if let winner = checkColWin(board: self.board.board) {
            self.winner = winner
            return .win
        }
        
        // check diagonals
        if let winner = checkDiagonalsWin(board: self.board.board) {
            self.winner = winner
            return .win
        }
        
        // no win, check draw
        if allSpotsFilled(board: self.board.board) {
            return .draw
        }
        
        return .noChange
    }
    
    /**
     resets the game, but keeps the same players and board size
     */
    public mutating func reset() {
        self.currPlayerIdx = 0
        self.winner = nil
        self.board.reset()
    }
    
    /**
     prints the game in the terminal
     */
    public func printGame() {
        for row in 0..<boardSize {
            
            var rowStr = ""
            for col in 0..<boardSize {
                if let piece = self.board.board[row][col] {
                    if col == (boardSize-1) {
                        rowStr += (piece.owner.name)
                    } else {
                        rowStr += (piece.owner.name + "|\t")
                    }
                } else {
                    if col == (boardSize-1) {
                        rowStr += (" ")
                    } else {
                        rowStr += (" " + "|\t")
                    }
                }
            }
            print(rowStr)
        }
    }

    
    
    /// MARK: Private Helper functions (left as 'internal' so they could be
    ///         accessed in my unit tests.
    
    
    /**
     Check to see if any player has one via rows
     
     - Parameters:
     - board: the board we need to check
     
     - Returns: the name of the player who won, or nil otherwise
     */
    internal func checkRowWin(board: [[Piece?]] ) -> String? {
        for row in 0..<board.count {
            let rowArray = self.board.board[row]
            if rowArray[0] != nil {
                if allEqual(type:  rowArray[0]!, inArray: rowArray) {
                    return rowArray[0]!.owner.name
                }
            }
        }
        return nil
    }
    
    /**
     Check to see if any player has one via columns
     
     - Parameters:
     - board: the board we need to check

     - Returns: the name of the player who won, or nil otherwise
     */
    internal func checkColWin(board: [[Piece?]] ) -> String? {
        for col in 0..<board.count {
            let colArray = getColumn(colIdx: col, fromArray: board)
            if colArray[0] != nil {
                if allEqual(type: colArray[0]!, inArray: colArray) {
                    return colArray[0]!.owner.name
                }
            }
        }
        return nil
        
    }
    
    /**
     Check to see if any player has one via cross diagonals
     
     - Parameters:
     - board: the board we need to check
     
     - Returns: the name of the player who won, or nil otherwise
     */
    internal func checkDiagonalsWin(board: [[Piece?]] ) -> String? {
        
        // check diag
        var diag = [Piece?]()
        for row in 0..<board.count {
            for col in 0..<board.count {
                if row == col {
                    diag.append(self.board.board[row][col])
                }
            }
        }
        
        if let first = diag.first! {
            if allEqual(type: first, inArray: diag) {
                return first.owner.name
            }
        }
        
        // check other diag
        diag.removeAll()
        var colIdx = self.boardSize-1
        for row in 0..<self.boardSize {
            diag.append(self.board.board[row][colIdx])
            colIdx -= 1
        }
        
        if let first = diag.first! {
            if allEqual(type: first, inArray: diag) {
                return first.owner.name
            }
        }
        
        return nil
        
    }
    
    /**
     Check to see if the game is over (i.e. if a draw occoured; no spots left)
     
     - Parameters:
     - board: the board we need to check
     
     - Returns: true if all spots are filled, false if not
     */
    internal func allSpotsFilled(board: [[Piece?]]) -> Bool {
        var allFilled = true
        for row in 0..<self.boardSize {
            for col in 0..<self.boardSize {
                if self.board.board[row][col] == nil {
                    allFilled = false
                    break
                }
            }
        }
        
        return allFilled ? true : false
    }
    
    /**
     Check to see if all the elements in arr exist and have the same owner
     
     - Parameters:
     - type: the piece whoes owner we want to match
     - arr: the array we need to check
     
     - Returns: true if all the elements in arr exist and have the same owner as 'type'
     */
    internal func allEqual(type: Piece, inArray arr: [Piece?]) -> Bool {
        for element in arr {
            if let e = element {
                if e.owner.name != type.owner.name {
                    return false
                }
            } else {
                return false
            }
            
        }
        
        return true
    }
    
    /**
     Gets a column vector from a 2D Array
     
     - Parameters:
     - colIdx: the index of the column we want to get
     - arr: the 2D array we need to get the column vector from
     
     - Returns: the column vector
     */
    internal func getColumn(colIdx: Int, fromArray arr: [[Piece?]]) -> [Piece?] {
        var colVector = [Piece?]()
        for row in 0..<arr.count {
            colVector.append(arr[row][colIdx])
        }
        return colVector
    }
    
}
