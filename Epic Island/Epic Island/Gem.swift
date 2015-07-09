//
//  Gem.swift
//  Epic Island
//
//  Created by Dave Sienk on 4/28/15.
//  Copyright (c) 2015 Quest Realm. All rights reserved.
//

import SpriteKit

class Gem: Printable, Hashable {
    var column: Int
    var row: Int
    let gemType: GemType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, gemType: GemType) {
        self.column = column
        self.row = row
        self.gemType = gemType
    }
    
    var description: String {
        return "type:\(gemType) square:(\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
}

enum GemType: Int, Printable {
    case Unknown = 0, Water, Earth, Fire, Leaf, Sun, Skull
    
    var spriteName: String {
        let spriteNames = [
            "Water",
            "Earth",
            "Fire",
            "Leaf",
            "Sun",
            "Skull"]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> GemType {
        return GemType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
}

func ==(lhs: Gem, rhs: Gem) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}