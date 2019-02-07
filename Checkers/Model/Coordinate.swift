//
//  Coordinate.swift
//  Checkers
//
//  Created by Khang Nguyen on 1/9/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//

import Foundation

class Coordinate {
    var row: Int
    var col: Int
    
    init(x:Int, y:Int){
        self.row = x
        self.col = y
    }
    
    func toString() -> String {
        let str = "(" + "\(self.row)" + "," + "\(self.col)" + ")"
        return str
    }
}
