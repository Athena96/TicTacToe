//
//  Board.swift
//  TicTacToe
//
//  Created by Jared Franzone on 12/18/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation

/// This struct represents a TicTacToe Board, it can be a square of any NxN size
struct Board {
    
    /// 2D array of Pieces
    var board: [[Piece?]]
    
    /// the size of the board
    var size: Int
    
    /**
     creates a new instance of a Board
     
     - Parameters:
     - size: the size of square board to make
     */
    init(size: Int) {
        
        self.size = size
    
        // create empty board
        self.board = [[Piece?]]()
        
        for row in 0..<size {
            self.board.append( [Piece?]() )
            for _ in 0..<size {
                self.board[row].append(nil)
            }
        }
        
    }
    
    /**
     resets the board to be empty
     */
    mutating func reset() {
        // reset the board
        self.board = [[Piece?]]()
        for row in 0..<size {
            self.board.append( [Piece?]() )
            for _ in 0..<size {
                self.board[row].append(nil)
            }
        }
    }
    
}
