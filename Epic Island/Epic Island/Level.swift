//
//  Level.swift
//  Epic Island
//
//  Created by Dave Sienk on 4/28/15.
//  Copyright (c) 2015 Quest Realm. All rights reserved.
//
//

import Foundation
import SpriteKit

let NumColumns = 8
let NumRows = 8

class Level {
    var targetScore = 0
    var maximumMoves = 0
    private var comboMultiplier = 0
    
    private var gems = Array2D<Gem>(columns: NumColumns, rows: NumRows)
    
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    private var possibleSwaps = Set<Swap>()
    
    init(filename: String) {
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) {
            if let tilesArray: AnyObject = dictionary["tiles"] {
                for (row, rowArray) in enumerate(tilesArray as! [[Int]]) {
                    let tileRow = NumRows - row - 1
                    for (column, value) in enumerate(rowArray) {
                        if value == 1 {
                            tiles[column, tileRow] = Tile()
                        }
                    }
                }
                targetScore = dictionary["targetScore"] as! Int
                maximumMoves = dictionary["moves"] as! Int
            }
        }
    }
    
    
    func shuffle() -> Set<Gem> {
        var set: Set<Gem>
        
        do {
            // Removes the old cookies and fills up the level with all new ones.
            set = createInitialGems()
            
            // At the start of each turn we need to detect which cookies the player can
            // actually swap. If the player tries to swap two cookies that are not in
            // this set, then the game does not accept this as a valid move.
            // This also tells you whether no more swaps are possible and the game needs
            // to automatically reshuffle.
            detectPossibleSwaps()
            
            //println("possible swaps: \(possibleSwaps)")
            
            // If there are no possible moves, then keep trying again until there are.
        }
            while possibleSwaps.count == 0
        
        return set
    }
    
    private func createInitialGems() -> Set<Gem> {
        var set = Set<Gem>()
        
        // Loop through the rows and columns of the 2D array. Note that column 0,
        // row 0 is in the bottom-left corner of the array.
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // Only make a new cookie if there is a tile at this spot.
                if tiles[column, row] != nil {
                    
                    // Pick the cookie type at random, and make sure that this never
                    // creates a chain of 3 or more. We want there to be 0 matches in
                    // the initial state.
                    var gemType: GemType
                    do {
                        gemType = GemType.random()
                    }
                        while (column >= 2 &&
                            gems[column - 1, row]?.gemType == gemType &&
                            gems[column - 2, row]?.gemType == gemType)
                            || (row >= 2 &&
                                gems[column, row - 1]?.gemType == gemType &&
                                gems[column, row - 2]?.gemType == gemType)
                    
                    // Create a new cookie and add it to the 2D array.
                    let gem = Gem(column: column, row: row, gemType: gemType)
                    gems[column, row] = gem
                    
                    // Also add the cookie to the set so we can tell our caller about it.
                    set.insert(gem)
                }
            }
        }
        return set
    }
    
    // MARK: Querying the Level
    
    // Returns the cookie at the specified column and row, or nil when there is none.
    func gemAtColumn(column: Int, row: Int) -> Gem? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return gems[column, row]
    }
    
    // Determines whether there's a tile at the specified column and row.
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    // Determines whether the suggested swap is a valid one, i.e. it results in at
    // least one new chain of 3 or more cookies of the same type.
    func isPossibleSwap(swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    // MARK: Swapping
    
    // Swaps the positions of the two cookies from the Swap object.
    func performSwap(swap: Swap) {
        // Need to make temporary copies of these because they get overwritten.
        let columnA = swap.gemA.column
        let rowA = swap.gemA.row
        let columnB = swap.gemB.column
        let rowB = swap.gemB.row
        
        // Swap the cookies. We need to update the array as well as the column
        // and row properties of the Cookie objects, or they go out of sync!
        gems[columnA, rowA] = swap.gemB
        swap.gemB.column = columnA
        swap.gemB.row = rowA
        
        gems[columnB, rowB] = swap.gemA
        swap.gemA.column = columnB
        swap.gemA.row = rowB
    }
    
    // MARK: Detecting Swaps
    
    // Recalculates which moves are valid.
    func detectPossibleSwaps() {
        var set = Set<Swap>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let gem = gems[column, row] {
                    
                    // Is it possible to swap this cookie with the one on the right?
                    // Note: don't need to check the last column.
                    if column < NumColumns - 1 {
                        
                        // Have a cookie in this spot? If there is no tile, there is no cookie.
                        if let other = gems[column + 1, row] {
                            // Swap them
                            gems[column, row] = other
                            gems[column + 1, row] = gem
                            
                            // Is either cookie now part of a chain?
                            if hasChainAtColumn(column + 1, row: row) ||
                                hasChainAtColumn(column, row: row) {
                                    set.insert(Swap(gemA: gem, gemB: other))
                            }
                            
                            // Swap them back
                            gems[column, row] = gem
                            gems[column + 1, row] = other
                        }
                    }
                    
                    // Is it possible to swap this cookie with the one above?
                    // Note: don't need to check the last row.
                    if row < NumRows - 1 {
                        
                        // Have a cookie in this spot? If there is no tile, there is no cookie.
                        if let other = gems[column, row + 1] {
                            // Swap them
                            gems[column, row] = other
                            gems[column, row + 1] = gem
                            
                            // Is either cookie now part of a chain?
                            if hasChainAtColumn(column, row: row + 1) ||
                                hasChainAtColumn(column, row: row) {
                                    set.insert(Swap(gemA: gem, gemB: other))
                            }
                            
                            // Swap them back
                            gems[column, row] = gem
                            gems[column, row + 1] = other
                        }
                    }
                }
            }
        }
        
        possibleSwaps = set
    }
    
    private func hasChainAtColumn(column: Int, row: Int) -> Bool {
        // Here we do ! because we know there is a cookie here
        let gemType = gems[column, row]!.gemType
        
        // Here we do ? because there may be no cookie there; if there isn't then
        // the loop will terminate because it is != cookieType. (So there is no
        // need to check whether cookies[i, row] != nil.)
        var horzLength = 1
        for var i = column - 1; i >= 0 && gems[i, row]?.gemType == gemType; --i, ++horzLength { }
        for var i = column + 1; i < NumColumns && gems[i, row]?.gemType == gemType; ++i, ++horzLength { }
        if horzLength >= 3 { return true }
        
        var vertLength = 1
        for var i = row - 1; i >= 0 && gems[column, i]?.gemType == gemType; --i, ++vertLength { }
        for var i = row + 1; i < NumRows && gems[column, i]?.gemType == gemType; ++i, ++vertLength { }
        return vertLength >= 3
    }
    
    private func detectHorizontalMatches() -> Set<Chain> {
        // 1
        var set = Set<Chain>()
        // 2
        for row in 0..<NumRows {
            for var column = 0; column < NumColumns - 2 ; {
                // 3
                if let gem = gems[column, row] {
                    let matchType = gem.gemType
                    // 4
                    if gems[column + 1, row]?.gemType == matchType &&
                        gems[column + 2, row]?.gemType == matchType {
                            // 5
                            let chain = Chain(chainType: .Horizontal)
                            do {
                                chain.addGem(gems[column, row]!)
                                ++column
                            }
                                while column < NumColumns && gems[column, row]?.gemType == matchType
                            
                            set.insert(chain)
                            continue
                    }
                }
                // 6
                ++column
            }
        }
        return set
    }
    
    private func detectVerticalMatches() -> Set<Chain> {
        var set = Set<Chain>()
        
        for column in 0..<NumColumns {
            for var row = 0; row < NumRows - 2; {
                if let gem = gems[column, row] {
                    let matchType = gem.gemType
                    
                    if gems[column, row + 1]?.gemType == matchType &&
                        gems[column, row + 2]?.gemType == matchType {
                            
                            let chain = Chain(chainType: .Vertical)
                            do {

                                chain.addGem(gems[column, row]!)
                                ++row
                            }
                                while row < NumRows && gems[column, row]?.gemType == matchType
                            
                            set.insert(chain);
                            continue
                    }
                }
                ++row
            }
        }
        return set
    }
    
    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()
        
        removeGems(horizontalChains)
        removeGems(verticalChains)
        
        calculateScores(horizontalChains)
        calculateScores(verticalChains)
        
        return horizontalChains.union(verticalChains)
    }
    
    private func removeGems(chains: Set<Chain>) {
        for chain in chains {
            for gem in chain.gems {
                gems[gem.column, gem.row] = nil
            }
        }
    }
    
    func fillHoles() -> [[Gem]] {
        var columns = [[Gem]]()
        // 1
        for column in 0..<NumColumns {
            var array = [Gem]()
            for row in 0..<NumRows {
                // 2
                if tiles[column, row] != nil && gems[column, row] == nil {
                    // 3
                    for lookup in (row + 1)..<NumRows {
                        if let gem = gems[column, lookup] {
                            // 4
                            gems[column, lookup] = nil
                            gems[column, row] = gem
                            gem.row = row
                            // 5
                            array.append(gem)
                            // 6
                            break
                        }
                    }
                }
            }
            // 7
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func topUpGems() -> [[Gem]] {
        var columns = [[Gem]]()
        var gemType: GemType = .Unknown
        
        for column in 0..<NumColumns {
            var array = [Gem]()
            // 1
            for var row = NumRows - 1; row >= 0 && gems[column, row] == nil; --row {
                // 2
                if tiles[column, row] != nil {
                    // 3
                    var newGemType: GemType
                    do {
                        newGemType = GemType.random()
                    } while newGemType == gemType
                    gemType = newGemType
                    // 4
                    let gem = Gem(column: column, row: row, gemType: gemType)
                    gems[column, row] = gem
                    array.append(gem)
                }
            }
            // 5
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    private func calculateScores(chains: Set<Chain>) {
        // 3-chain is 60 pts, 4-chain is 120, 5-chain is 180, and so on
        for chain in chains {
            chain.score = 60 * (chain.length - 2) * comboMultiplier
            ++comboMultiplier
        }
    }
    
    func resetComboMultiplier() {
        comboMultiplier = 1
    }
    
}
