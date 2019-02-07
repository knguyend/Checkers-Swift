//
//  GameScene.swift
//  Checkers
//
//  Created by Khang Nguyen on 12/26/18.
//  Copyright © 2018 Khang Nguyen. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

//use chosen for gamescene not

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var game: Game = Game(depth: 5)
    var squares = [SKSpriteNode]()
    
    
    override func didMove(to view: SKView) {
        initBackground()
        //initBoard()
        //startGame()
        drawBoard()
        drawPieces()
        //displayPossibleMoves(name: "w52", game: game)
        
    }
    
    func drawPieces() {
        let squareSide = Int((view?.bounds.width)!/8)
        var toggle: Bool = true
        //let alphas:String = "abcdefgh"
        //White pieces
        for row in 0...2 {
            for col in 0...7 {
                if (toggle), let square = squareWithName(name: "\(7-row)\(col)"){
                    let gamePiece = SKSpriteNode(imageNamed: "WhitePiece.png")
                    gamePiece.size = CGSize(width: squareSide, height: squareSide)
                    gamePiece.name = "w\(7-row)\(col)"
                    square.addChild(gamePiece)
                }
                toggle = !toggle
            }
            toggle = !toggle
        }
        //Red pieces
        toggle = false
        for row in 5...7 {
            for col in 0...7 {
                if (toggle), let square = squareWithName(name: "\(7-row)\(col)"){
                    let gamePiece = SKSpriteNode(imageNamed: "RedPiece.png")
                    gamePiece.size = CGSize(width: squareSide, height: squareSide)
                    gamePiece.name = "r\(7-row)\(col)"
                    square.addChild(gamePiece)
                }
                toggle = !toggle
            }
            toggle = !toggle
        }
    }
    
    func drawBoard() {
        // Board parameters
        let squareSide = Int((view?.bounds.width)!/8)
        let numRows = 8
        let numCols = 8
        let squareSize = CGSize(width: squareSide, height: squareSide)
        let xOffset:CGFloat = 25
        let yOffset:CGFloat = 200
        // Column characters
        //let alphas:String = "abcdefgh"
        // Used to alternate between white and black squares
        var toggle:Bool = false
        for row in 0...numRows-1 {
            for col in 0...numCols-1 {
                // Letter for this column
                //let colChar = Array(alphas)[col]
                // Determine the color of square
                let color = toggle ? SKColor.white : SKColor.black
                let square = SKSpriteNode(color: color, size: squareSize)
                square.position = CGPoint(x: CGFloat(col) * squareSize.width + xOffset,
                                          y: CGFloat(row) * squareSize.height + yOffset)
                // Set sprite's name (e.g., a8, c5, d1)
                square.name = "\(7-row)\(col)"
                self.addChild(square)
                toggle = !toggle
            }
            toggle = !toggle
        }
    }
    
    func initBackground(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
    }
    
    
    func squareWithName(name:String) -> SKSpriteNode? {
        let square:SKSpriteNode? = self.childNode(withName: name) as! SKSpriteNode?
        return square
    }
    
    func drawSquare(rect: CGRect, white: Bool){
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: rect).cgPath
        if (white){
            layer.fillColor = UIColor.white.cgColor
        }
        else {
            layer.fillColor = UIColor.black.cgColor
        }
        view?.layer.addSublayer(layer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            print(name)
            if (game.isSelectingPiece){
                if (Array(name)[0] != "w"){
                    
                }
                let coord = Coordinate(x: rowFromName(name: name), y: colFromName(name: name))
                game.chosenOne = coord
                squares = displayPossibleMoves(name: name, game: game)
                game.isSelectingPiece = !game.isSelectingPiece
                return
            }
            else {
                if (moveSelected(squares: squares, name: name, game: game)){
                    let move = game.computerMove()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                        self.removePiece(row: move.start.row, col: move.start.col)
                        if (move.isJump){
                            self.removePiece(row: move.captured.row, col: move.captured.col)
                        }
                        self.drawPiece(row: move.end.row, col: move.end.col, player: "c", alpha: 1.0)
                    })
                    
                }
                game.isSelectingPiece = !game.isSelectingPiece
            }
        }
    }
    
    func displayPossibleMoves(name: String, game: Game) -> [SKSpriteNode] {
        var ret = [SKSpriteNode]()
        if (Array(name)[0] != "w"){ //not a white piece
            return ret
        }
        else {
            let row = rowFromName(name: name)
            let col = colFromName(name: name)
            let arr = possibleMoves(row: row, col: col, board: game.board)
            let squareSide = Int((view?.bounds.width)!/8)
            for coord in arr {
                let row = coord.row
                let col = coord.col
                print("\(row)\(col)")
                if let square = squareWithName(name: "\(row)\(col)"){
                    let gamePiece = SKSpriteNode(imageNamed: "WhitePiece.png")
                    gamePiece.size = CGSize(width: squareSide, height: squareSide)
                    gamePiece.name = "s\(row)\(col)"
                    gamePiece.alpha = 0.5
                    square.addChild(gamePiece)
                    ret.append(square)
                }
            }
            return ret
        }
    }
    
    func deleteMoveOptions(squares: [SKSpriteNode]){
        for square in squares {
            square.removeAllChildren()
        }
    }
    
    func moveSelected(squares: [SKSpriteNode], name: String, game: Game) -> Bool {
        if (Array(name)[0] != "s"){
            deleteMoveOptions(squares: squares)
            return false
        }
        else {
            let move = Move(startRow: game.chosenOne.row, startCol: game.chosenOne.col, endRow: rowFromName(name: name), endCol: colFromName(name: name))
            game.board.updateBoard(curr: move.start, next: move.end, player: "u")
            deleteMoveOptions(squares: squares)
            removePiece(row: move.start.row, col: move.start.col)
            drawPiece(row: move.end.row, col: move.end.col, player: "u", alpha: 1)
            if (move.isJump){
                removePiece(row: move.captured.row, col: move.captured.col)
            }
            
            return true
        }
            
    }
    
    func drawPiece(row: Int, col: Int, player: Character, alpha: CGFloat){
        let squareSide = Int((view?.bounds.width)!/8)
        if let square = squareWithName(name: "\(row)\(col)"){
            if (player == "u"){
                let gamePiece = SKSpriteNode(imageNamed: "WhitePiece.png")
                gamePiece.size = CGSize(width: squareSide, height: squareSide)
                if (alpha < 1) {
                    gamePiece.name = "s\(row)\(col)"
                    gamePiece.alpha = alpha
                }
                else {
                    gamePiece.name = "w\(row)\(col)"
                }
                square.addChild(gamePiece)
            }
            else {
                let gamePiece = SKSpriteNode(imageNamed: "RedPiece.png")
                gamePiece.name = "r\(row)\(col)"
                gamePiece.size = CGSize(width: squareSide, height: squareSide)
                square.addChild(gamePiece)
            }
        }
    }
        
    func removePiece(row: Int, col: Int){
        if let square = squareWithName(name: "\(row)\(col)"){
            square.removeAllChildren()
        }
    }
    
    func rowFromName(name: String) -> Int {
        return Int(String(Array(name)[1]))!
    }
    
    func colFromName(name: String) -> Int {
        return Int(String(Array(name)[2]))!
    }
    
 
    

    
}
