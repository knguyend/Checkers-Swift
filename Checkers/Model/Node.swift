//
//  Node.swift
//  Checkers
//
//  Created by Khang Nguyen on 1/11/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//

// initialize tree node with children
class Node {
    
    var board:Board
    var children: [Node] // array of either pieces that can jump (preferred), or just move
    var list: [Move]
    var bestMove: Move
    var numChildren:Int
    var alpha:Int
    var beta:Int
    var value:Int;
    
    
    init(board: Board) {
        self.board = board;
        self.bestMove = Move();
        self.children = []
        self.list = []
        self.numChildren = 0
        self.alpha = Int.min
        self.beta = Int.max
        self.value = (board.COMPUTER)-(board.USER)
    }
    
    func isNull() -> Bool {
        return (numChildren == 0 && list.isEmpty)
    }
}
