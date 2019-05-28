//
//  ViewController.swift
//  Checkers
//
//  Created by Khang Nguyen on 1/17/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//

import Foundation

func possibleMoves(row: Int, col: Int, board: Board) -> ([Coordinate],[Move]) {
    var coords: [Coordinate] = []
    var retMoves: [Move] = []
    let coord = Coordinate(x: row, y: col)
    let moves = getMovesForOne(board: board, coordinate: coord, player: "u")
    let jumps = getJumpsForOne(board: board, coordinate: coord, player: "u")
    for move in moves {
        coords.append(move.end)
        retMoves.append(move)
    }
    for jump in jumps {
        coords.append(jump.end)
        retMoves.append(jump)
    }
    return (coords,retMoves)
}



