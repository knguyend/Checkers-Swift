//
//  Piece.swift
//  Checkers
//
//  Created by Khang Nguyen on 12/31/18.
//  Copyright © 2018 Khang Nguyen. All rights reserved.
//

class Piece {
    var isKing:Bool
    var x:Int
    var y:Int
    var isWhite:Bool
    
    init(x:Int,y:Int, isWhite: Bool ) {
        isKing = false
        self.isWhite = isWhite
        self.x = x
        self.y = y
    }
}
