//
//  MahjongTile.swift
//  Mahjong Scoring
//
//  Created by 戚越 on 2018/12/4.
//  Copyright © 2018 Yue QI. All rights reserved.
//

import Foundation

class MahjongTile {
    var type: String
    var number: Int
    
    init(type: String, number: Int) {
        self.type = type
        self.number = number //东南西北为100，200。300，400。 中发白为1000，2000，3000
    }
    
    static func ==(lhs: MahjongTile, rhs: MahjongTile) -> Bool {
        return lhs.type == rhs.type && lhs.number == rhs.number
    }
    
    static func getTile(from index: Int) -> MahjongTile {
        let arrayTileNumber = [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,100,200,300,400,1000,2000,3000]
        let arrayTileType = [String](repeating: "character", count: 9) + [String](repeating: "bamboo", count: 9) + [String](repeating: "dot", count: 9) + [String](repeating: "wind", count: 4) + [String](repeating: "dragon", count: 3)
        let numberOfTile = arrayTileNumber[index]
        let typeOfTile = arrayTileType[index]
        
        return MahjongTile(type: typeOfTile, number: numberOfTile)
    }
    
    /*
    static func getTile(from title: String) -> MahjongTile {
        var index = title.index(of: " ")
        
        let typeOfTile = String(title[..<index!])
        index = title.index(index!, offsetBy: 1)
        let numberOfTile = Int(title[index!... ])!
        
        return MahjongTile(type: typeOfTile, number: numberOfTile)
    } */
}

class MahjongMeld{
    var type: String = "none"
    var tile1: MahjongTile
    var tile2: MahjongTile
    var tile3: MahjongTile
    var isKong: Bool
    var isExposed: Bool
    var number: Int = 0
    
    init(tile1: MahjongTile, tile2: MahjongTile, tile3: MahjongTile) {
        self.tile1 = tile1
        self.tile2 = tile2
        self.tile3 = tile3
        self.isKong = false
        self.isExposed = false
        updateType()
    }
    
    func updateType(){
        if self.tile1 == self.tile2, self.tile2 == self.tile3 {
            self.number = self.tile1.number
            if self.isKong{
                self.type = "kong"
            } else {
                self.type = "triplet"
            }
        } else if self.tile1.type == self.tile2.type && self.tile2.type == self.tile3.type{
            let array = [self.tile1.number, self.tile2.number, self.tile3.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] - arraySorted[0] == 1 && arraySorted[2] - arraySorted[1] == 1 {
                self.number = arraySorted[0]
                self.type = "sequence"
            }
        } else {
            self.type = "none"
        }
    }
}

class MahjongPair{
    var type: String = "none"
    var tile1: MahjongTile
    var tile2: MahjongTile
    var number: Int
    
    init(tile1: MahjongTile, tile2: MahjongTile) {
        self.tile1 = tile1
        self.tile2 = tile2
        self.number = self.tile1.number
        if tile1 == tile2 {
            self.type = "pair"
        } else {
            self.type = "none"
        }
    }
}
