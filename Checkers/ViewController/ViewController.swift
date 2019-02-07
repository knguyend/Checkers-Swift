//
//  ViewController.swift
//  Checkers
//
//  Created by Khang Nguyen on 1/17/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//

import Foundation

func possibleMoves(row: Int, col: Int, board: Board) -> [Coordinate] {
    var arr: [Coordinate] = []
    var moveArr: [Move] = []
    let coord = Coordinate(x: row, y: col)
    let moves = getMovesForOne(board: board, coordinate: coord, player: "u")
    let jumps = getJumpsForOne(board: board, coordinate: coord, player: "u")
    moveArr.append(contentsOf: jumps)
    moveArr.append(contentsOf: moves)
    for move in moveArr {
        arr.append(move.end)
    }
    return arr
}



