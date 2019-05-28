//
//  board.swift
//  Checkers
//
//  Created by Khang Nguyen on 1/9/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//

import Foundation 

class Board {
    var COMPUTER: Int
    var USER:Int
    var board:[[Character]]
    // construct new board, computer starts first
    
    init(COMPUTER:Int = 36, USER:Int = 36) {
        // store values of pieces for each player
        // normal pieces worth 3 units, kings worth 5
        self.COMPUTER = COMPUTER;
        self.USER = USER;
        self.board = []
        // initialize all as '-'
        for _ in 0...7 {
            var row: [Character] = []
            for _ in 0...7 {
                row.append("-")
            }
            self.board.append(row)
        }
        var skip = true
        // initialize computer pieces
        for i in 0...2 {
            for j in 0...7 {
                if (!skip){
                    self.board[i][j] = "c"
                }
                skip = !skip;
            }
            skip = !skip;
        }
        // initialize user pieces
        skip = false;
        for i in 5...7 {
            for j in 0...7 {
                if (!skip){
                    self.board[i][j] = "u";
                }
                skip = !skip;
            }
            skip = !skip;
        }
    }
    
    
    // duplicate board, for children
    func newBoard()->Board {
        let new = Board(COMPUTER: self.COMPUTER, USER: self.USER)
        
        // copy board array
        for i in 0...7 {
            for j in 0...7{
                new.board[i][j] = self.board[i][j];
            }
        }
        return new;
    }
    
    // make a legit move
    func updateBoard(curr: Coordinate, next: Coordinate, player:Character, captured: [Coordinate]) {
        for coord in captured {
            let enemyR = coord.row
            let enemyC = coord.col
        
            var enemyPieceValue = 3 // assume normal piece was destroyed
            if ((self.board[enemyR][enemyC]) < "a"){
                enemyPieceValue = 5; // king was destroyed
            }
            self.board[enemyR][enemyC] = "-" // die
            if (player == "u"){ // enemy loses one piece
                self.COMPUTER -= enemyPieceValue
            }
            else{
                self.USER -= enemyPieceValue
            }
        }
        
        // make king if they reached the end
        if (next.row == 0 || next.row == 7) {
            let uppercase = Character(String(self.board[curr.row][curr.col]).uppercased())
            self.board[curr.row][curr.col] = uppercase
            if (self.board[curr.row][curr.col] > "a") {
                if (player == "u"){
                    self.USER += 2
                }
                else {
                    self.COMPUTER += 2;
                }
            }
        }
        // shift position of piece
        self.board[next.row][next.col] = self.board[curr.row][curr.col]
        self.board[curr.row][curr.col] = "-"
        
    }
    
    
    // print to stdout
    func toString() {
        var board = ""
        for i in 0...7 {
            var row = ""
            for j in 0...7 {
                    row += "\(self.board[i][j])"
            }
            board += row + "\n"
        }
        print(board)
    }
}
