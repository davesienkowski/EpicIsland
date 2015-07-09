//
//  Swap.swift
//  Epic Island
//
//  Created by Dave Sienk on 4/29/15.
//  Copyright (c) 2015 Quest Realm. All rights reserved.
//

struct Swap: Printable, Hashable {
    let gemA: Gem
    let gemB: Gem
    
    init(gemA: Gem, gemB: Gem) {
        self.gemA = gemA
        self.gemB = gemB
    }
    
    var description: String {
        return "swap \(gemA) with \(gemB)"
    }
    
    var hashValue: Int {
        return gemA.hashValue ^ gemB.hashValue
    }
}

func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.gemA == rhs.gemA && lhs.gemB == rhs.gemB) ||
        (lhs.gemB == rhs.gemA && lhs.gemA == rhs.gemB)
}
