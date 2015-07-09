//
//  Chain.swift
//  Epic Island
//
//  Created by Dave Sienk on 5/6/15.
//  Copyright (c) 2015 Quest Realm. All rights reserved.
//

import Foundation

class Chain: Hashable, Printable {
    
    var score = 0
    
    var gems = [Gem]()
    
    enum ChainType: Printable {
        case Horizontal
        case Vertical
        
        var description: String {
            switch self {
            case .Horizontal: return "Horizontal"
            case .Vertical: return "Vertical"
            }
        }
    }
    
    var chainType: ChainType
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func addGem(gem: Gem) {
        gems.append(gem)
    }
    
    func firstGem() -> Gem {
        return gems[0]
    }
    
    func lastGem() -> Gem {
        return gems[gems.count - 1]
    }
    
    var length: Int {
        return gems.count
    }
    
    var description: String {
        return "type:\(chainType) gems:\(gems)"
    }
    
    var hashValue: Int {
        return reduce(gems, 0) { $0.hashValue ^ $1.hashValue }
    }
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.gems == rhs.gems
}