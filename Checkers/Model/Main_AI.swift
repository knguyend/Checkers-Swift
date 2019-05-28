//
//  Main_AI.swift
//  Checkers
//
//  Created by Khang Nguyen on 1/16/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//
import Foundation

//Instance of a game
class Game {
    var board : Board
    var isSelectingPiece: Bool
    var depth: Int
    var chosenOne: Coordinate
    
    init(depth:Int) {
        board = Board(COMPUTER: 36, USER: 36)
        self.isSelectingPiece = true
        self.depth = depth
        self.chosenOne = Coordinate(x: -1, y: -1)
    }
    
    /**
    Make a comp move
     - Returns: the best move returned from minimax algorithm
     */
    func computerMove() -> Move {
        let newboard = board.newBoard()
        let tree = buildTree(board: newboard, depth: self.depth, player: "c")
        var compMove = Move()
        if (!tree.isNull()) {       // if there is no available move, skip turn
            _ = minimax(t: tree, depth: self.depth, isMaximizingPlayer: true, alpha: Int.min, beta: Int.max) //find best move
            compMove = tree.bestMove
            board.updateBoard(curr: compMove.start, next: compMove.end, player: "c", captured: compMove.captured) //make best move
            // print updates
            print("====== Computer Move =====")
            print(compMove.toString())
            print("========= Board ========= \n")
            board.toString()
        }
        else {
            print("Comp didn't move")
        }
        return compMove
    }
    
    
    
}


func startGame() {
    // create board
    if let readsomething = readLine(){
        print(readsomething)
    }
    
    let board = Board(COMPUTER: 36, USER: 36    )
    var player:Character = "u"  // user starts first
    var userMove: Move
    var compMove: Move
    var tree: Node
    let DEPTH = 5
    board.toString()
    // Gameplay
    while (board.COMPUTER > 0 && board.USER > 0) {
        // print current score tally
        /*
        cout << endl << "========================" << endl;
        cout << "COMPUTER: " << board->COMPUTER << " vs USER: " << board->USER << endl;
        cout <<  "========================" << endl;
 */
        
        // player makes move
        if (player == "u") {
            if let input = readLine(){
                let inputArr = input.split(separator: " ")
                userMove = Move(startRow: Int(inputArr[0])!, startCol: Int(inputArr[1])!, endRow: Int(inputArr[2])!, endCol: Int(inputArr[3])!)
            }
            else {
                userMove = makeRandomMove(board: board,player: player); // user finds a random move to make
            }
            // if there is no available move, skip turn
            if (userMove.isValid) {
                board.updateBoard(curr: userMove.start, next: userMove.end, player: player, captured: userMove.captured) // make move
                
                // print updates
                print(userMove.toString())
                print("========= Board ========= \n")
                board.toString()
            }
            else {
                print("User didn't move")
            }
            
            player = "c";
        }
        else {
            // computer follows using minimax algorithm
            let newboard = board.newBoard()
            tree = buildTree(board: newboard, depth: DEPTH, player: player)
            if (!tree.isNull()) {       // if there is no available move, skip turn
                _ = minimax(t: tree, depth: DEPTH, isMaximizingPlayer: true, alpha: Int.min, beta: Int.max) //find best move
                compMove = tree.bestMove
                board.updateBoard(curr: compMove.start, next: compMove.end, player: player, captured: compMove.captured) //make best move
                // print updates
                print("====== Computer Move =====")
                print(compMove.toString())
                print("========= Board ========= \n")
                board.toString()
            }
            else {
                print("Comp didn't move")
            }
            player = "u"
        }
        
        // find if anyone won, return score and exit game
        if (board.USER == 0) {
            player = "-"
            NSLog("You lose!");
            exit(0);
        }
        if (board.COMPUTER == 0) {
            player = "-";
            NSLog("You win!\n")
        }
    }
}
