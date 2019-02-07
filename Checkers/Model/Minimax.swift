//
//  Minimax.swift
//  Checkers
//
//  Created by Khang Nguyen on 1/11/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//
import Foundation

func makeRandomMove(board: Board, player: Character) -> Move {
    // jumps preferred
    var list = getJumps(board: board, player: player)
    if (list.isEmpty){
        list = getMoves(board: board, player: player)
    }
    if (list.isEmpty){ // list of possible moves  still empty
        return Move()
    }
    let r = Int(arc4random_uniform(UInt32(list.count)))
    return list[r]
}

func buildTree(board: Board, depth: Int, player: Character) -> Node {
    let t = Node(board: board)
    if (depth == 0) { // leaf, so update value and return node
        //t.value = (board.COMPUTER) - (board.USER)
        return t
    }
    else {
        // find list of possible moves; prefer jumps if available
        t.list = getJumps(board: board, player: player);
        if (t.list.isEmpty) { // no possible jumps
            t.list = getMoves(board: board, player: player);
        }
        if (t.list.isEmpty){ // if there are still no possible  moves,
            return t // skip turn
        }
        // find how many possible moves there are and create a child node for each
        let num = t.list.count
        t.numChildren = num;
        
        // recur on each possible move - make children nodes
        for i in 0..<num {
            let newboard:Board = board.newBoard()
            newboard.updateBoard(curr: t.list[i].start, next: t.list[i].end, player: player)
            var newplayer: Character
            if (player == "c"){
                newplayer = "u"
            }
            else {
                newplayer = "c"
            }
            
            // create child node and add to t->children
            t.children.append(buildTree(board: newboard, depth: depth-1, player: newplayer))
        }
    }
    return t
}

// return best move
func minimax(t: Node, depth: Int, isMaximizingPlayer: Bool, alpha: Int, beta: Int) -> Int {
    if (depth == 0) {// return difference in # of pieces
        return t.value
    }
    var val = 0
    var best: Int
    if (isMaximizingPlayer) {
        best = Int.min
        t.alpha = alpha
        t.beta = beta
        
        // recur for all children
        for i in 0..<t.numChildren {
            if (!t.children[i].list.isEmpty){
                val = minimax(t: t.children[i], depth: depth-1, isMaximizingPlayer: false, alpha: t.alpha, beta: t.beta)
            }
            best = max(best, val)
            t.alpha = max(alpha,best)
            if (best >= t.alpha) {
                t.alpha = best
                t.bestMove = t.list[i]; // child that promises highest return value
            }
            
            // Alpha Beta Pruning
            if (t.alpha >= t.beta){
                break
            }
        }
        return best;
    }
        // similar for minimizing player, but no need to set bestMove
    else {
        best = Int.max
        
        // recur for all children
        for i in 0..<t.numChildren {
            if (!t.children[i].list.isEmpty){
                val = minimax(t: t.children[i], depth: depth-1, isMaximizingPlayer: true, alpha: t.alpha, beta: t.beta);
            }
            best = min(best, val)
            t.beta = min(t.beta, best)
            
            // Alpha Beta Pruning
            if (t.alpha >= t.beta){
                break
            }
        }
        return best;
    }
}
