//
//  CheckMove.swift
//  Checkers
//
//  Created by Khang Nguyen on 1/10/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//
class Move {
    var isJump: Bool
    var start: Coordinate
    var end: Coordinate
    var captured: Coordinate
    var isValid: Bool
    
    init(){
        self.start = Coordinate(x: 0, y: 0)
        self.end = Coordinate(x: 0, y: 0)
        self.isJump = false
        self.captured = Coordinate(x: 0, y: 0)
        self.isValid = false
    }
    
    init(startRow:Int, startCol: Int, endRow: Int, endCol:Int){
        self.start = Coordinate(x:startRow, y:startCol)
        self.end = Coordinate(x:endRow,y: endCol)
        if (abs(startCol - endCol) == 2){
            isJump = true
            captured = Coordinate(x: (startRow+endRow)/2, y: (startCol + endCol)/2)
        }
        else {
            self.captured = Coordinate(x: -1, y: -1)
            self.isJump = false
        }
        self.isValid = true
    }
    
    func toString() -> String {
        if (!self.isValid){
            return "Move invalid"
        }
        else if (self.isJump){
            let str = "jump" + "\(self.start.toString())" + "->" + "\(self.end.toString())"
            return str
            }
        else {
            let str = "move" + "\(self.start.toString())" + "->" + "\(self.end.toString())"
            return str
        }
    }
    
}

/** Check if player can move from (r1,c1) to (r2,c2)*/
func canMove(board: Board, player: Character, move: Move) -> Bool {
    if (move.end.row < 0 || move.end.row >= 8 || move.end.col < 0 || move.end.col >= 8) {
        return false;
    }
    if (board.board[move.end.row][move.end.col] != "-") {
        return false; // there is already a pawn at (x2, y2)
    }
    if (player == "c") {
        if (board.board[move.start.row][move.start.col] == "c" && move.end.row < move.start.row) {
            return false; // can only move down
        }
        return true;
    }
    else {
        if (board.board[move.start.row][move.start.col] == "u" && move.end.row > move.start.row){
            return false;
        }
    }
    return true
}

/** Check if player can jump from (r1,c1) to (r2,c2)*/
func canJump(board:Board, player: Character, move:Move) -> Bool {
    //Out of bound
    if (move.end.col < 0 || move.end.col > 7 || move.end.row < 0 || move.end.row > 7) {
        return false
    }
    //Pawn at destination
    if (board.board[move.end.row][move.end.col] != "-") {
        return false
    }
    if (player == "c") {
        if (board.board[move.start.row][move.start.col] == "c" && move.end.row < move.start.row) {
            return false // can only move down
        }
        if (board.board[move.captured.row][move.captured.col] != "u" && board.board[move.captured.row][move.captured.col] != "U"){ // if the square in between not u or U then can't jump
            return false
        }
    }
    else {
        if (board.board[move.start.row][move.start.col] == "u" && move.end.row > move.start.row) {
            return false // can only move up
        }
        if (board.board[move.captured.row][move.captured.col] != "c" && board.board[move.captured.row][move.captured.col] != "C") {// if the square in between not c or C then can't jump
            return false
        }
    }
    return true
}

/**
 Get move of a pawn at a given coordinate
 - Parameter board: current state of the board
 - Parameter coordiante: coordinate of the pawn which we're finding moves for
 - Parameter player: "c" or "p" to determine whose turn
 - Returns: An array of possive moves.
 */
func getMovesForOne(board: Board, coordinate: Coordinate, player: Character) -> [Move] {
    var list: [Move] = []
    let i = coordinate.row
    let j = coordinate.col
    let lowercased = Character(String(board.board[i][j]).lowercased())
    if (lowercased == player) {
        //Move down right
        let downright = Move(startRow: i, startCol: j, endRow: i+1, endCol: j+1)
        if (canMove(board: board, player: player, move: downright)) {
            list.append(downright)
        }
        //Move down left
        let downleft = Move(startRow: i, startCol: j, endRow: i+1, endCol: j-1)
        if (canMove(board: board, player: player, move: downleft)) {
            list.append(downleft)
        }
        //Move up right
        let upright = Move(startRow: i, startCol: j, endRow: i-1, endCol: j+1)
        if (canMove(board: board, player: player, move: upright)) {
            list.append(upright)
        }
        //Move up left
        let upleft = Move(startRow: i, startCol: j, endRow: i-1, endCol: j-1)
        if (canMove(board: board, player: player, move: upleft)) {
            list.append(upleft)
        }
    }
    return list
}

/** Returns all possible moves for a player in an array */
func getMoves(board: Board, player: Character) -> [Move] {
    // create list of possible moves; there are at most 2 moves for 12 pieces
    var list:[Move] = []
    var coord: Coordinate
    // loop through the whole board
    for i in 0...7 {
        for j in 0...7  {
            coord = Coordinate(x: i, y: j)
            list.append(contentsOf: getMovesForOne(board: board, coordinate: coord, player: player))
            }
        }
    return list
}

/**
 Get move of a pawn at a given coordinate
 - Parameter board: current state of the board
 - Parameter coordiante: coordinate of the pawn which we're finding moves for
 - Parameter player: "c" or "p" to determine whose turn
 - Returns: An array of possive jumps.
 */
func getJumpsForOne(board: Board, coordinate: Coordinate, player: Character) -> [Move] {
    var list: [Move] = []
    let i = coordinate.row
    let j = coordinate.col
    let lowercased = Character(String(board.board[i][j]).lowercased())
    if (lowercased == player) {
        //Move down right
        let downright = Move(startRow: i, startCol: j, endRow: i+2, endCol: j+2)
        if (canJump(board: board, player: player, move: downright)) {
            list.append(downright)
        }
        //Move down left
        let downleft = Move(startRow: i, startCol: j, endRow: i+2, endCol: j-2)
        if (canJump(board: board, player: player, move: downleft)) {
            list.append(downleft)
        }
        //Move up right
        let upright = Move(startRow: i, startCol: j, endRow: i-2, endCol: j+2)
        if (canJump(board: board, player: player, move: upright)) {
            list.append(upright)
        }
        //Move up left
        let upleft = Move(startRow: i, startCol: j, endRow: i-2, endCol: j-2)
        if (canJump(board: board, player: player, move: upleft)) {
            list.append(upleft)
        }
    }
    return list
        
}

/**
 Returns possible jumps of all the pawns of a player (comp or human).
 - Returns: Array of Move
 */
func getJumps(board:Board, player:Character) -> [Move] {
    // create list of possible moves; there are at most 2 jumps for 12 pieces
    // each piece only allowed to make one jump!
    // create list of possible moves; there are at most 2 moves for 12 pieces
    var list:[Move] = []
    for i in 0...7 {
        for j in 0...7  {
            let coord = Coordinate(x: i, y: j)
            list.append(contentsOf: getJumpsForOne(board: board, coordinate: coord, player: player))

        }
    }
    return list
}
