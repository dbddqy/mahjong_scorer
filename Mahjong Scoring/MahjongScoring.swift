//
//  MahjongScoring.swift
//  Mahjong Scoring
//
//  Created by 戚越 on 2018/12/4.
//  Copyright © 2018 Yue QI. All rights reserved.
//

import Foundation

class MahjongScoring{
    
    var prevailingWind: String = "none"
    var dealersWind: String = "none"
    var numberOfFlowers: Int = 0
    
    var IsSelfDrawn: Bool = false
    
    var IsLastTile: Bool = false
    
    var IsLastTileDraw: Bool = false
    var IsLastTileClaim: Bool = false
    var IsOutWithReplacementTile: Bool = false
    var IsRobbingTheKong: Bool = false
    
    var currentIndex: Int = 0
    
    var mahjongTiles = [MahjongTile]()
    var melds = [MahjongMeld?](){
        didSet{
            for meld in melds{
                meld?.updateType()
            }
        }
    }
    
    var pair: MahjongPair? = nil
    
    var winTile: MahjongTile? = nil
    var winTileIndex: Int = 15
    
    func updateType() {
        for meld in self.melds {
            meld?.updateType()
        }
    }
    
    func build(){
        if self.melds.count == 0 {
            self.melds.append(nil)
            self.melds.append(nil)
            self.melds.append(nil)
            self.melds.append(nil)
        }
        self.melds[0] = MahjongMeld(tile1: mahjongTiles[0], tile2: mahjongTiles[1], tile3: mahjongTiles[2])
        self.melds[1] = MahjongMeld(tile1: mahjongTiles[3], tile2: mahjongTiles[4], tile3: mahjongTiles[5])
        self.melds[2] = MahjongMeld(tile1: mahjongTiles[6], tile2: mahjongTiles[7], tile3: mahjongTiles[8])
        self.melds[3] = MahjongMeld(tile1: mahjongTiles[9], tile2: mahjongTiles[10], tile3: mahjongTiles[11])
        self.pair = MahjongPair(tile1: mahjongTiles[12], tile2: mahjongTiles[13])
    }
    
    func clearSpecialWin() {
        self.IsLastTileDraw = false
        self.IsLastTileClaim = false
        self.IsOutWithReplacementTile = false
        self.IsRobbingTheKong = false
    }
    
    var winType: [String] = []
    var winScore: [Int] = []
    
    //算分
    func getScore() -> Bool{
        winType.removeAll()
        winScore.removeAll()
        
        ISSPECIALWINART:
        if self.melds[0]?.type == "none" || self.melds[1]?.type == "none" || self.melds[2]?.type == "none" || self.melds[3]?.type == "none" || self.pair?.type == "none" {
            groupIrregularType()
            if !isKnittedStraight() { //计算组合龙
                if self.winType.isEmpty {return false}
                else {return true}
            }
        }
        
        isBigFourWinds()
        isBigThreeDragons()
        isAllGreen()
        isNineGates()
        isFourKongs()
        isAllTerminals()
        isLittleFourWinds()
        isLittleThreeDragons()
        isAllHonors()
        isFourConcealedPungs()
        isPureTerminalChows()
        isQuadrupleChow()
        isFourPureShiftedPungs()
        isFourPureShiftedChows()
        isThreeKongs()
        isAllTerminalsAndHonors()
        isAllEvenPungs()
        isFullFlush()
        isPureTripleChow()
        isPureShiftedPungs()
        isUpperTiles()
        isMiddleTiles()
        isLowerTiles()
        isPureStraight()
        isThreeSuitedTerminalChows()
        isPureShiftedChows()
        isAllFives()
        isThreeConcealedPungs()
        isUpperFour()
        isLowerFour()
        isBigThreeWinds()
        isMixedStraight()
        isReversibleTiles()
        isMixedTripleChow()
        isMixedShiftedPungs()
        isTwoConcealedKongs()
        isAllPungs()
        isHalfFlush()
        isMixedShiftedChows()
        isAllTypes()
        isMeldedHand()
        isTwoDragonPungs()
        isMeldedAndConcealedKong()
        isOutsideHand()
        isTwoMeldedKongs()
        isDragonPung()
        isAllChows()
        isTileHog()
        isTwoConcealedPungs()
        isCondealedKong()
        isAllSimples()
        isPureDoubleChow()
        isMixedDoubleChow()
        isShortStraight()
        isTwoTerminalChows()
        isPungOfTeminalsOrHonors()
        isMeldedKong()
        isOneVoidedSuit()
        isNoHonors()
        
        //特殊番种
        groupSpecialType()
        
        groupEqualPungs() //双同刻三同刻
        
        _ = isSeatWind()
        _ = isPrevalentWind()
        
        isSelfDrawn()
        isFullyConcealedHand() //不求人
        isConcealedHand() //门清
        isChickenHand() //无番和
        groupWaitPosition() //边张坎张单调将
        
        isFlower()
        
        removeDoubled() //去掉重复计算
        
        self.isFourSequences = false
        self.isThreeSequences = false
        self.numberOfChowPoints = 0
        
        for index in knittedStraightIndices {
            self.melds[index]?.type = "none"
        }
        self.knittedStraightIndices.removeAll()//解决组合龙问题
        
        return true
    }
    
    private func removeDoubled() {
        if self.winType.contains("不求人(不计自摸)") {
            removeWinType(name: "自摸")
        }
        if self.winType.contains("平和") {
            removeWinType(name: "无字")
        }
        if self.winType.contains("圈风刻") {
            removeWinType(name: "幺九刻")
        }
        if self.winType.contains("门风刻") && self.prevailingWind != self.dealersWind {
            removeWinType(name: "幺九刻")
        }
        if self.winType.contains("四杠(不计碰碰和，单吊将)") {
            removeWinType(name: "碰碰和")
            removeWinType(name: "单吊将")
        }
        if self.winType.contains("四暗刻") {
            removeWinType(name: "碰碰和")
        }
        if self.winType.contains("清龙") {
            removeWinType(name: "连六")
            self.numberOfChowPoints -= 1
            removeWinType(name: "连六")
            self.numberOfChowPoints -= 1
            removeWinType(name: "老少副")
            self.numberOfChowPoints -= 1
        }
        if self.winType.contains("三色三同顺") {
            for _ in 0..<3 {
                removeWinType(name: "喜相逢")
                self.numberOfChowPoints -= 1
            }
        }
        if self.winType.contains("三色双龙会(不计平和，无字)") {
            removeWinType(name: "平和")
            removeWinType(name: "无字")
        }
        if self.winType.contains("一色三同顺") {
            for _ in 0..<3 {
                removeWinType(name: "一般高")
                self.numberOfChowPoints -= 1
            }
        }
        if self.winType.contains("一色四同顺") {
            removeWinType(name: "一色三同顺")
            for _ in 0..<3 {removeWinType(name: "四归一")}
        }
        if self.winType.contains("一色四步高") {
            removeWinType(name: "一色三步高")
        }
        if self.winType.contains("一色四节高") {
            removeWinType(name: "一色三节高")
            removeWinType(name: "碰碰和")
        }
        if self.winType.contains("清一色") {
            removeWinType(name: "混一色")
            removeWinType(name: "无字")
        }
        if self.winType.contains("一色双龙会(不计清一色，平和，无字)") {
            removeWinType(name: "清一色")
            removeWinType(name: "平和")
            removeWinType(name: "无字")
        }
        if self.winType.contains("推不倒") {
            removeWinType(name: "缺一门")
        }
        if self.winType.contains("大四喜") {
            removeWinType(name: "碰碰和")
            removeWinType(name: "圈风刻")
            removeWinType(name: "门风刻")
            for _ in 0..<4 {removeWinType(name: "幺九刻")}
        }
        if self.winType.contains("小四喜") {
            for _ in 0..<3 {removeWinType(name: "幺九刻")}
        }
        if self.winType.contains("三风刻") {
            if self.winType.contains("门风刻") || self.winType.contains("圈风刻") {
                for _ in 0..<2 {removeWinType(name: "幺九刻")}
            } else {
                for _ in 0..<3 {removeWinType(name: "幺九刻")}
            }
        }
        if self.winType.contains("大于五") || self.winType.contains("小于五"){
            removeWinType(name: "无字")
        }
        if self.winType.contains("全大"){
            removeWinType(name: "大于五")
        }
        if self.winType.contains("全小"){
            removeWinType(name: "小于五")
        }
        if self.winType.contains("全中(不计断幺)"){
            removeWinType(name: "无字")
            removeWinType(name: "断幺")
        }
        if self.winType.contains("全双刻(不计碰碰和，断幺)"){
            removeWinType(name: "碰碰和")
            removeWinType(name: "断幺")
        }
        if self.winType.contains("混幺九(不计碰碰和，全带幺，幺九刻)"){
            removeWinType(name: "碰碰和")
            removeWinType(name: "全带幺")
            for _ in 0..<4 {removeWinType(name: "幺九刻")}
        }
        if self.winType.contains("字一色(不计碰碰和，全带幺，幺九刻)"){
            removeWinType(name: "混幺九(不计碰碰和，全带幺，幺九刻)")
        }
        if self.winType.contains("清幺九(不计碰碰和，全带幺，幺九刻，无字)"){
            removeWinType(name: "混幺九(不计碰碰和，全带幺，幺九刻)")
            removeWinType(name: "无字")
        }
        if self.winType.contains("九莲宝灯(不计一副幺九刻，门前清)"){
            removeWinType(name: "清一色")
            removeWinType(name: "幺九刻")
            removeWinType(name: "门前清")
        }
        if self.winType.contains("组合龙"){
            removeWinType(name: "三色三同顺")
        }
        
        if self.isThreeSequences {
            while self.numberOfChowPoints > 1 {
                if self.winType.contains("老少副") {
                    removeWinType(name: "老少副")
                    numberOfChowPoints -= 1
                } else if self.winType.contains("连六") {
                    removeWinType(name: "连六")
                    numberOfChowPoints -= 1
                } else if self.winType.contains("喜相逢") {
                    removeWinType(name: "喜相逢")
                    numberOfChowPoints -= 1
                } else if self.winType.contains("一般高") {
                    removeWinType(name: "一般高")
                    numberOfChowPoints -= 1
                }
            }
        }
    }
    
    private func removeWinType(name: String) {
        let index = self.winType.index(of: name)
        if index != nil {
            self.winType.remove(at: index!)
            self.winScore.remove(at: index!)
        }
    }
    
    ///////////////////////////////////////
    private func groupWaitPosition() {  //边张坎张单调将
        if isSingleWait() {return}
        if isClosedWait() {return}
        if isEdgeWait() {return}
    }
    private func groupEqualPungs() {  //双同刻三同刻
        if isTriplePung() {return}
        if isDoublePung() {return}
    }
    private func groupIrregularType() {
        if isSevenShiftedPairs() {return}
        if isThirteenOrphans() {return}
        if isSevenPairs() {return}
        if isLesserHonorsAndKnittedTiles() {return}
    }
    private func groupSpecialType() {
        isLastTile()
        isLastTileDraw()
        isLastTileClaim()
        isOutWithReplacementTile()
        isRobbingTheKong()
    }
    
    /////////////////////////////////////
    
    private var isThreeSequences = false
    private var isFourSequences = false
    private var numberOfChowPoints = 0
    
    private func isFlower(){
        if self.numberOfFlowers > 0 {
            self.winType.append("花牌 * \(self.numberOfFlowers)")
            self.winScore.append(self.numberOfFlowers)
        }
        return
    }
    
    private func isSelfDrawn(){
        if self.IsSelfDrawn {
            self.winType.append("自摸")
            self.winScore.append(1)
        }
        return
    }
    
    private func isSingleWait() -> Bool {
        if self.winTileIndex == 12 || self.winTileIndex == 13 {
            self.winType.append("单吊将")
            self.winScore.append(1)
            return true
        }
        return false
    }
    
    private func isClosedWait() -> Bool {
        var winMeldIndex: Int = 0
        if winTileIndex == 0 || winTileIndex == 1 || winTileIndex == 2 {winMeldIndex = 0}
        if winTileIndex == 3 || winTileIndex == 4 || winTileIndex == 5 {winMeldIndex = 1}
        if winTileIndex == 6 || winTileIndex == 7 || winTileIndex == 8 {winMeldIndex = 2}
        if winTileIndex == 9 || winTileIndex == 10 || winTileIndex == 11 {winMeldIndex = 3}
        
        if self.melds[winMeldIndex]?.type != "sequence" {return false}
        
        let array = [melds[winMeldIndex]!.tile1.number, melds[winMeldIndex]!.tile2.number, melds[winMeldIndex]!.tile3.number]
        let arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        if array[1] - array[0] != 1 {return false} //排除组合龙的特殊情况
        if arraySorted[1] == self.winTile?.number {
            self.winType.append("坎张")
            self.winScore.append(1)
            return true
        }
        
        return false
    }
    
    private func isEdgeWait() -> Bool {
        var winMeldIndex: Int = 0
        if winTileIndex == 0 || winTileIndex == 1 || winTileIndex == 2 {winMeldIndex = 0}
        if winTileIndex == 3 || winTileIndex == 4 || winTileIndex == 5 {winMeldIndex = 1}
        if winTileIndex == 6 || winTileIndex == 7 || winTileIndex == 8 {winMeldIndex = 2}
        if winTileIndex == 9 || winTileIndex == 10 || winTileIndex == 11 {winMeldIndex = 3}
        
        if self.melds[winMeldIndex]?.type != "sequence" {return false}
        if melds[winMeldIndex]?.number != 1 && melds[winMeldIndex]?.number != 7 {return false}
        if self.winTile?.number == 3 || self.winTile?.number == 7 {
            self.winType.append("边张")
            self.winScore.append(1)
            return true
        }
        return false
    }
    
    private func isNoHonors() {
        var flag = true
        for meld in self.melds {
            if meld?.tile1.type == "wind" || meld?.tile1.type == "dragon" {flag = false}
        }
        if self.pair?.tile1.type == "wind" || self.pair?.tile1.type == "dragon" {flag = false}
        if flag {
            self.winType.append("无字")
            self.winScore.append(1)
        }
        return
    }
    
    private func isOneVoidedSuit() {
        var types = [String]()
        for tile in self.mahjongTiles {
            types.append(tile.type)
        }
        
        var numberOfTypes = 0
        if types.contains("character") { numberOfTypes += 1}
        if types.contains("dot") { numberOfTypes += 1}
        if types.contains("bamboo") { numberOfTypes += 1}
        if numberOfTypes == 2 {
            self.winType.append("缺一门")
            self.winScore.append(1)
        }
        return
    }
    
    private func isMeldedKong() {
        var kongIndices = [Int]()
        for index in self.melds.indices {
            if self.melds[index]!.type == "kong" {kongIndices.append(index)}
        }
        if kongIndices.count == 1 {
            if self.melds[kongIndices[0]]?.isExposed == true {
                self.winType.append("明杠")
                self.winScore.append(1)
            }
        }
        return
    }
    
    private func isPungOfTeminalsOrHonors() {
        for meld in self.melds {
            if meld?.type == "triplet" || meld?.type == "kong" {
                if meld?.number == 1 || meld?.number == 9 || meld?.tile1.type == "wind" {
                    self.winType.append("幺九刻")
                    self.winScore.append(1)
                    self.numberOfChowPoints += 1
                }
            }
        }
        return
    }
    
    private func isTwoTerminalChows() {
        if self.isFourSequences {return}
        for index1 in 0..<4 {
            for index2 in (index1+1)..<4 {
                if self.melds[index1]?.tile1.type != self.melds[index2]?.tile1.type {continue}
                if self.melds[index1]?.type != "sequence" {continue}
                if self.melds[index2]?.type != "sequence" {continue}
                if self.melds[index1]?.number == 1 && self.melds[index2]?.number == 7 {
                    self.winType.append("老少副")
                    self.winScore.append(1)
                    self.numberOfChowPoints += 1
                }
                if self.melds[index1]?.number == 7 && self.melds[index2]?.number == 1 {
                    self.winType.append("老少副")
                    self.winScore.append(1)
                    self.numberOfChowPoints += 1
                }
            }
        }
        return
    }
    
    private func isShortStraight() {
        if self.isFourSequences {return}
        for index1 in 0..<4 {
            for index2 in (index1+1)..<4 {
                if index1 == index2 {continue}
                if self.melds[index1]?.tile1.type != self.melds[index2]?.tile1.type {continue}
                if self.melds[index1]?.type != "sequence" {continue}
                if self.melds[index2]?.type != "sequence" {continue}
                if self.melds[index1]!.number - self.melds[index2]!.number == 3 || self.melds[index1]!.number - self.melds[index2]!.number == -3{
                    self.winType.append("连六")
                    self.winScore.append(1)
                    self.numberOfChowPoints += 1
                }
            }
        }
        return
    }
    
    private func isMixedDoubleChow() {
        if self.isFourSequences {return}
        for index1 in 0..<4 {
            for index2 in (index1+1)..<4 {
                if index1 == index2 {continue}
                if self.melds[index1]?.tile1.type == self.melds[index2]?.tile1.type {continue}
                if self.melds[index1]?.type != "sequence" {continue}
                if self.melds[index2]?.type != "sequence" {continue}
                if self.melds[index1]!.number == self.melds[index2]!.number{
                    self.winType.append("喜相逢")
                    self.winScore.append(1)
                    self.numberOfChowPoints += 1
                }
            }
        }
        return
    }
    
    private func isPureDoubleChow() {
        if self.isFourSequences {return}
        for index1 in 0..<4 {
            for index2 in (index1+1)..<4 {
                if index1 == index2 {continue}
                if self.melds[index1]?.tile1.type != self.melds[index2]?.tile1.type {continue}
                if self.melds[index1]?.type != "sequence" {continue}
                if self.melds[index2]?.type != "sequence" {continue}
                if self.melds[index1]!.number == self.melds[index2]!.number{
                    self.winType.append("一般高")
                    self.winScore.append(1)
                    self.numberOfChowPoints += 1
                }
            }
        }
        return
    }
    
    private func isAllSimples() {
        for tile in self.mahjongTiles {
            if tile.number == 1 {return}
            if tile.number >= 9 {return}
        }
        self.winType.append("断幺")
        self.winScore.append(2)
        return
        /*
        var flag = true
        for meld in self.melds {
            if meld?.type == "sequence", (meld?.number == 1 || meld?.number == 7) {flag = false}
            if (meld?.type == "triplet" || meld?.type == "kong"), (meld?.number == 1 || meld?.number == 9) {flag = false}
            if meld?.tile1.type == "wind" || meld?.tile1.type == "dragon" {flag = false}
        }
        if self.pair?.number == 1 || (self.pair?.number)! >= 9 {flag = false}
        if flag {
            self.winType.append("断幺")
            self.winScore.append(2)
        }
        return*/
    }
    
    private func isCondealedKong() {
        var kongIndices = [Int]()
        for index in self.melds.indices {
            if self.melds[index]!.type == "kong" {kongIndices.append(index)}
        }
        if kongIndices.count == 1 {
            if self.melds[kongIndices[0]]?.isExposed == false {
                self.winType.append("暗杠")
                self.winScore.append(2)
            }
        }
        return
    }
    
    private func isTwoConcealedPungs() {
        var numberOfConcealedPungs = 0
        for meld in self.melds {
            if meld?.type == "triplet" || meld?.type == "kong" {
                if meld?.isExposed == false {numberOfConcealedPungs += 1}
            }
        }
        if numberOfConcealedPungs == 2 {
            self.winType.append("双暗刻")
            self.winScore.append(2)
        }
        return
    }
    
    private func isDoublePung() -> Bool {
        var numberOfDoublePung = 0
        for index1 in 0..<3 {
            for index2 in (index1+1)..<4 {
                if self.melds[index1]!.type == "triplet" || self.melds[index1]!.type == "kong" {
                    if self.melds[index2]!.type == "triplet" || self.melds[index2]!.type == "kong" {
                        if self.melds[index1]?.number == self.melds[index2]?.number {numberOfDoublePung += 1}
                    }
                }
            }
        }
        for _ in 0..<numberOfDoublePung{
            self.winType.append("双同刻")
            self.winScore.append(2)
        }
        if numberOfDoublePung > 0 {return true}
        else {return false}
    }
    
    private func isTileHog() {
        var dic:[String: Int] = [:]
        var tileName = ""
        for tile in self.mahjongTiles {
            tileName = tile.type + String(tile.number)
            if dic[tileName] == nil {dic[tileName] = 1}
            else {dic[tileName]! += 1}
            if dic[tileName] == 4 {
                self.winType.append("四归一")
                self.winScore.append(2)
            }
        }
        return
    }
    
    private func isAllChows() {
        var flag = true
        for meld in self.melds {
            if meld?.type != "sequence" {flag = false}
        }
        if (pair?.number)! > 9 {flag = false}
        if flag {
            self.winType.append("平和")
            self.winScore.append(2)
        }
        return
    }
    
    private func isConcealedHand() {
        var flag: Bool = true
        for meld in self.melds {
            if meld?.isExposed == true {flag = false}
        }
        if flag && (!self.IsSelfDrawn) {
            self.winType.append("门前清")
            self.winScore.append(2)
        }
        return
    }
    
    private func isSeatWind() -> Bool {
        var flag = false
        for meld in self.melds {
            if meld?.type == "triplet" || meld?.type == "kong"{
                if meld?.number == 100 && self.dealersWind == "east" {flag = true}
                if meld?.number == 200 && self.dealersWind == "south" {flag = true}
                if meld?.number == 300 && self.dealersWind == "west" {flag = true}
                if meld?.number == 400 && self.dealersWind == "north" {flag = true}
            }
        }
        if flag{
            self.winType.append("门风刻")
            self.winScore.append(2)
            return true
        }
        return false
    }
    
    private func isPrevalentWind() -> Bool {
        var flag = false
        for meld in self.melds {
            if meld?.type == "triplet" || meld?.type == "kong"{
                if meld?.number == 100 && self.prevailingWind == "east" {flag = true}
                if meld?.number == 200 && self.prevailingWind == "south" {flag = true}
                if meld?.number == 300 && self.prevailingWind == "west" {flag = true}
                if meld?.number == 400 && self.prevailingWind == "north" {flag = true}
            }
        }
        if flag{
            self.winType.append("圈风刻")
            self.winScore.append(2)
            return true
        }
        return false
    }
    
    private func isDragonPung() {
        var numberOfDragonPung = 0
        for meld in melds {
            if meld?.type != "triplet" && meld?.type != "kong" {continue}
            if meld?.tile1.type == "dragon" {numberOfDragonPung += 1}
        }
        if numberOfDragonPung == 1 {
            self.winType.append("箭刻")
            self.winScore.append(2)
        }
        return
    }
    
    private func isLastTile() {
        if IsLastTile {
            self.winType.append("胡绝张")
            self.winScore.append(4)
        }
        return
    }
    
    private func isTwoMeldedKongs() {
        var kongIndices = [Int]()
        for index in self.melds.indices {
            if self.melds[index]!.type == "kong" {kongIndices.append(index)}
        }
        if kongIndices.count == 2 {
            if self.melds[kongIndices[0]]?.isExposed == true, self.melds[kongIndices[1]]?.isExposed == true{
                self.winType.append("双明杠")
                self.winScore.append(4)
            }
        }
        return
    }
    
    private func isFullyConcealedHand() {
        var flag: Bool = true
        for meld in self.melds {
            if meld?.isExposed == true {flag = false}
        }
        if flag && self.IsSelfDrawn {
            self.winType.append("不求人(不计自摸)")
            self.winScore.append(4)
        }
        return
    }
    
    private func isOutsideHand() {
        var flag = true
        for meld in melds {
            if meld?.tile1.type == "wind" || meld?.tile1.type == "dragon" {continue}
            if meld?.type == "sequence" {
                if meld?.number != 1 && meld?.number != 7 {flag = false}
            } else {
                if meld?.number != 1 && meld?.number != 9 {flag = false}
            }
        }
        if self.pair?.tile1.type != "wind" || self.pair?.tile1.type != "dragon" {
            if self.pair?.number != 1 && self.pair?.number != 9 {flag = false}
        }
        if flag {
            self.winType.append("全带幺")
            self.winScore.append(4)
        }
        return
    }
    
    private func isMeldedAndConcealedKong() {
        var kongIndices = [Int]()
        for index in self.melds.indices {
            if self.melds[index]!.type == "kong" {kongIndices.append(index)}
        }
        if kongIndices.count == 2 {
            if self.melds[kongIndices[0]]?.isExposed != self.melds[kongIndices[1]]?.isExposed {
                self.winType.append("明暗杠")
                self.winScore.append(5)
            }
        }
        return
    }
    
    private func isTwoDragonPungs() {
        var numberOfDragonPung = 0
        for meld in melds {
            if meld?.type != "triplet" && meld?.type != "kong" {continue}
            if meld?.tile1.type == "dragon" {numberOfDragonPung += 1}
        }
        if numberOfDragonPung == 2, self.pair?.tile1.type != "dragon" {
            self.winType.append("双箭刻")
            self.winScore.append(6)
        }
        return
    }
    
    private func isMeldedHand() {
        var flag = true
        for meld in self.melds {
            if meld?.isExposed == false {flag = false}
        }
        if flag && !self.IsSelfDrawn {
            self.winType.append("全求人")
            self.winScore.append(6)
        }
        return
    }
    
    private func isAllTypes() {
        var types = [String]()
        for tile in self.mahjongTiles {
            if types.contains(tile.type) {continue}
            types.append(tile.type)
        }
        if types.count != 5 {return}
        self.winType.append("五门齐")
        self.winScore.append(6)
        return
    }
    
    private func isMixedShiftedChows() {
        for index1 in 0..<4 {
            let index2 = (index1 + 1) % 4
            let index3 = (index1 + 2) % 4
            if self.melds[index1]?.type != "sequence" {continue}
            if self.melds[index2]?.type != "sequence" {continue}
            if self.melds[index3]?.type != "sequence" {continue}
            if self.melds[index1]?.tile1.type == self.melds[index2]?.tile1.type {continue}
            if self.melds[index2]?.tile1.type == self.melds[index3]?.tile1.type {continue}
            if self.melds[index3]?.tile1.type == self.melds[index1]?.tile1.type {continue}
            let array = [self.melds[index1]!.number, self.melds[index2]!.number, self.melds[index3]!.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] - arraySorted[0] == 1 && arraySorted[2] - arraySorted[1] == 1 {
                self.winType.append("三色三步高")
                self.winScore.append(6)
                self.isThreeSequences = true
                break
            }
        }

        return
    }
    
    private func isHalfFlush() {
        var types = [String]()
        for meld in self.melds {
            if meld?.tile1.type == "wind" || meld?.tile1.type == "dragon" {continue}
            if types.contains((meld?.tile1.type)!) {continue}
            types.append((meld?.tile1.type)!)
        }
        if self.pair?.tile1.type != "wind" && self.pair?.tile1.type != "dragon" {
            if !types.contains((self.pair?.tile1.type)!) {
                types.append((self.pair?.tile1.type)!)
            }
        }
        if types.count == 1 {
            self.winType.append("混一色")
            self.winScore.append(6)
        }
        return
    }
    
    private func isAllPungs() {
        for meld in self.melds {
            if meld?.type != "triplet" && meld?.type != "kong" {return}
        }
        self.winType.append("碰碰和")
        self.winScore.append(6)
        return
    }
    
    private func isTwoConcealedKongs() {
        var kongIndices = [Int]()
        for index in self.melds.indices {
            if self.melds[index]!.type == "kong" {kongIndices.append(index)}
        }
        if kongIndices.count == 2 {
            if self.melds[kongIndices[0]]?.isExposed == false, self.melds[kongIndices[1]]?.isExposed == false{
                self.winType.append("双暗杠")
                self.winScore.append(6)
            }
        }
        return
    }
    
    private func isRobbingTheKong(){
        if IsRobbingTheKong {
            self.winType.append("抢杠胡(不记和绝张)")
            self.winScore.append(8)
        }
        return
    }
    
    private func isOutWithReplacementTile(){
        if IsOutWithReplacementTile {
            self.winType.append("杠上开花")
            self.winScore.append(8)
        }
        return
    }
    
    private func isLastTileClaim(){
        if IsLastTileClaim {
            self.winType.append("海底捞月")
            self.winScore.append(8)
        }
        return
    }
    
    private func isLastTileDraw() {
        if IsLastTileDraw {
            self.winType.append("妙手回春(不计自摸)")
            self.winScore.append(8)
            self.IsSelfDrawn = true
        }
        return
    }
    
    private func isChickenHand() {
        if self.winScore.isEmpty {
            self.winType.append("无番胡")
            self.winScore.append(8)
        }
        return
    }
    
    private func isMixedShiftedPungs() {
        for index1 in 0..<4 {
            let index2 = (index1 + 1) % 4
            let index3 = (index1 + 2) % 4
            if self.melds[index1]?.type != "triplet" && self.melds[index1]?.type != "kong" {continue}
            if self.melds[index2]?.type != "triplet" && self.melds[index2]?.type != "kong" {continue}
            if self.melds[index3]?.type != "triplet" && self.melds[index3]?.type != "kong" {continue}
            if self.melds[index1]?.tile1.type == self.melds[index2]?.tile1.type {continue}
            if self.melds[index2]?.tile1.type == self.melds[index3]?.tile1.type {continue}
            if self.melds[index3]?.tile1.type == self.melds[index1]?.tile1.type {continue}
            let array = [self.melds[index1]!.number, self.melds[index2]!.number, self.melds[index3]!.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] - arraySorted[0] == 1 && arraySorted[2] - arraySorted[1] == 1 {
                self.winType.append("三色三节高")
                self.winScore.append(8)
                break
            }
        }
        return
    }
    
    private func isMixedTripleChow() {
        for index1 in 0..<4 {
            let index2 = (index1 + 1) % 4
            let index3 = (index1 + 2) % 4
            if self.melds[index1]?.type != "sequence" {continue}
            if self.melds[index2]?.type != "sequence" {continue}
            if self.melds[index3]?.type != "sequence" {continue}
            if self.melds[index1]?.tile1.type == self.melds[index2]?.tile1.type {continue}
            if self.melds[index2]?.tile1.type == self.melds[index3]?.tile1.type {continue}
            if self.melds[index3]?.tile1.type == self.melds[index1]?.tile1.type {continue}
            let array = [self.melds[index1]!.number, self.melds[index2]!.number, self.melds[index3]!.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] == arraySorted[0] && arraySorted[2] == arraySorted[1]{
                self.winType.append("三色三同顺")
                self.winScore.append(8)
                self.isThreeSequences = true
                break
            }
        }
        return
    }
    
    private func isReversibleTiles() {
        for tile in self.mahjongTiles {
            if tile.type == "character" || tile.type == "wind" {return}
            if tile.type == "dot" , (tile.number == 6 || tile.number == 7) {return}
            if tile.type == "bamboo" , (tile.number == 1 || tile.number == 3 || tile.number == 7) {return}
            if tile.type == "dragon" , (tile.number == 100 || tile.number == 200) {return}
        }
        self.winType.append("推不倒")
        self.winScore.append(8)
        return
    }
    
    private func isMixedStraight() {
        for index1 in 0..<4 {
            let index2 = (index1 + 1) % 4
            let index3 = (index1 + 2) % 4
            if self.melds[index1]?.type != "sequence" {continue}
            if self.melds[index2]?.type != "sequence" {continue}
            if self.melds[index3]?.type != "sequence" {continue}
            if self.melds[index1]?.tile1.type == self.melds[index2]?.tile1.type {continue}
            if self.melds[index2]?.tile1.type == self.melds[index3]?.tile1.type {continue}
            if self.melds[index3]?.tile1.type == self.melds[index1]?.tile1.type {continue}
            let array = [self.melds[index1]!.number, self.melds[index2]!.number, self.melds[index3]!.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] - arraySorted[0] == 3 && arraySorted[2] - arraySorted[1] == 3 {
                self.winType.append("花龙")
                self.winScore.append(8)
                self.isThreeSequences = true
                break
            }
        }
        return
    }
    
    private func isBigThreeWinds() {
        var numberOfWindPung = 0
        for meld in melds {
            if meld?.type != "triplet" && meld?.type != "kong" {continue}
            if meld?.tile1.type == "wind" {numberOfWindPung += 1}
        }
        if numberOfWindPung == 3, self.pair?.tile1.type != "wind" {
            self.winType.append("三风刻")
            self.winScore.append(12)
        }
        return
    }
    
    private func isLowerFour() {
        for tile in self.mahjongTiles {
            if tile.number >= 5 {return}
        }
        self.winType.append("小于五")
        self.winScore.append(12)
        return
    }
    
    private func isUpperFour() {
        for tile in self.mahjongTiles {
            if tile.number <= 5 {return}
            if tile.number > 9 {return}
        }
        self.winType.append("大于五")
        self.winScore.append(12)
        return
    }
    
    private var knittedStraightIndices: [Int] = []
    private func isKnittedStraight() -> Bool {
        if self.pair?.type == "none" {return false}
        var melds: [MahjongMeld] = []
        for index in self.melds.indices{
            if self.melds[index]?.type == "none" {
                melds.append(self.melds[index]!)
                self.knittedStraightIndices.append(index)
            }
        }
        if melds.count != 3 {return false}
        
        for meld in melds {
            if meld.tile1.type == meld.tile2.type, meld.tile2.type == meld.tile3.type {continue}
            return false
        }
        
        let array1 = [melds[0].tile1.number, melds[0].tile2.number, melds[0].tile3.number]
        let array1Sorted = array1.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        let array2 = [melds[1].tile1.number, melds[1].tile2.number, melds[1].tile3.number]
        let array2Sorted = array2.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        let array3 = [melds[2].tile1.number, melds[2].tile2.number, melds[2].tile3.number]
        let array3Sorted = array3.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        let array = [array1Sorted, array2Sorted, array3Sorted]
        let arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1[0] < s2[0]
        }
        
        if arraySorted != [[1,4,7],[2,5,8],[3,6,9]] {return false}
        
        for index in knittedStraightIndices{self.melds[index]?.type = "sequence"}
        self.winType.append("组合龙")
        self.winScore.append(12)
        return true
    }
    
    private func isLesserHonorsAndKnittedTiles() -> Bool {
        for index1 in 0..<14 {
            for index2 in (index1+1)..<14 {
                if self.mahjongTiles[index1].number == self.mahjongTiles[index2].number {return false}
            }
        }
        var numberOfCharacter: [Int] = []
        var numberOfBamboo: [Int] = []
        var numberOfDot: [Int] = []
        var numberOfWindAndDragon: [Int] = []
        for tile in self.mahjongTiles {
            if tile.number > 9 {numberOfWindAndDragon.append(tile.number)}
            if tile.type == "character" {numberOfCharacter.append(tile.number)}
            if tile.type == "bamboo" {numberOfBamboo.append(tile.number)}
            if tile.type == "dot" {numberOfDot.append(tile.number)}
        }
        
        var arraySorted = numberOfCharacter.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        for index in arraySorted.indices {
            if index == 0 {continue}
            if arraySorted[index] - arraySorted[index-1] != 3 && arraySorted[index] - arraySorted[index-1] != 6 {return false}
        }
        
        arraySorted = numberOfBamboo.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        for index in arraySorted.indices {
            if index == 0 {continue}
            if arraySorted[index] - arraySorted[index-1] != 3 && arraySorted[index] - arraySorted[index-1] != 6 {return false}
        }
        arraySorted = numberOfDot.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        
        for index in arraySorted.indices {
            if index == 0 {continue}
            if arraySorted[index] - arraySorted[index-1] != 3 && arraySorted[index] - arraySorted[index-1] != 6 {return false}
        }
        
        if numberOfWindAndDragon.count == 7 {
            self.winType.append("七星不靠")
            self.winScore.append(24)
        } else {
            self.winType.append("全不靠")
            self.winScore.append(12)
        }
        if numberOfDot.count == 3 && numberOfBamboo.count == 3 && numberOfCharacter.count == 3 {
            self.winType.append("组合龙")
            self.winScore.append(12)
        }
        groupSpecialType()
        isFullyConcealedHand()
        isFlower()
        return true
    }
    
    private func isThreeConcealedPungs() {
        var numberOfConcealedPungs = 0
        for meld in self.melds {
            if meld?.type == "triplet" || meld?.type == "kong" {
                if meld?.isExposed == false {numberOfConcealedPungs += 1}
            }
        }
        if numberOfConcealedPungs == 3 {
            self.winType.append("三暗刻")
            self.winScore.append(16)
        }
        return
    }
    
    private func isTriplePung() -> Bool{
        var flag = false
        for index1 in 0..<2 {
            for index2 in (index1+1)..<3 {
                for index3 in (index2+1)..<4 {
                    if self.melds[index1]!.type != "triplet" && self.melds[index1]!.type != "kong" {continue}
                    if self.melds[index2]!.type != "triplet" && self.melds[index2]!.type != "kong" {continue}
                    if self.melds[index3]!.type != "triplet" && self.melds[index3]!.type != "kong" {continue}
                    if self.melds[index1]?.number != self.melds[index2]?.number {continue}
                    if self.melds[index2]?.number != self.melds[index3]?.number {continue}
                    flag = true
                }
            }
        }
        if flag {
            self.winType.append("三同刻")
            self.winScore.append(16)
            return true
        }
        return false
    }
    
    private func isAllFives() {
        for meld in melds {
            if meld?.type == "sequence", ((meld?.number)! <= 2 || (meld?.number)! >= 6) {return}
            if meld?.type == "triplet" || meld?.type == "kong" , meld?.number != 5 {return}
        }
        if self.pair?.number != 5 {return}
        self.winType.append("全带五")
        self.winScore.append(16)
        return
    }
    
    private func isPureShiftedChows() {
        for index1 in 0..<4 {
            let index2 = (index1 + 1) % 4
            let index3 = (index1 + 2) % 4
            if self.melds[index1]?.type != "sequence" {continue}
            if self.melds[index2]?.type != "sequence" {continue}
            if self.melds[index3]?.type != "sequence" {continue}
            if self.melds[index1]?.tile1.type != self.melds[index2]?.tile1.type {continue}
            if self.melds[index2]?.tile1.type != self.melds[index3]?.tile1.type {continue}
            let array = [self.melds[index1]!.number, self.melds[index2]!.number, self.melds[index3]!.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] - arraySorted[0] == 1 && arraySorted[2] - arraySorted[1] == 1 {
                self.winType.append("一色三步高")
                self.winScore.append(16)
                self.isThreeSequences = true
                break
            }
            if arraySorted[1] - arraySorted[0] == 2 && arraySorted[2] - arraySorted[1] == 2 {
                self.winType.append("一色三步高")
                self.winScore.append(16)
                self.isThreeSequences = true
                break
            }
        }
        return
    }
    
    private func isThreeSuitedTerminalChows() {
        for meld in self.melds {
            if meld?.type != "sequence" {return}
        }
        if self.pair?.number != 5 {return}
        let array = [self.melds[0], self.melds[1], self.melds[2], self.melds[3]]
        var arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1!.number < s2!.number
        }
        if arraySorted[0]?.number != 1 {return}
        if arraySorted[1]?.number != 1 {return}
        if arraySorted[2]?.number != 7 {return}
        if arraySorted[3]?.number != 7 {return}
        
        arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1!.tile1.type < s2!.tile1.type
        }
        if arraySorted[0]?.tile1.type != arraySorted[1]?.tile1.type {return}
        if arraySorted[2]?.tile1.type != arraySorted[3]?.tile1.type {return}
        
        if arraySorted[0]?.tile1.type == arraySorted[2]?.tile1.type {return}
        if arraySorted[2]?.tile1.type == self.pair?.tile1.type {return}
        if self.pair?.tile1.type == arraySorted[0]?.tile1.type {return}
        
        self.winType.append("三色双龙会(不计平和，无字)")
        self.winScore.append(16)
        self.isFourSequences = true
        return
    }
    
    private func isPureStraight() {
        for index1 in 0..<4 {
            let index2 = (index1 + 1) % 4
            let index3 = (index1 + 2) % 4
            if self.melds[index1]?.type != "sequence" {continue}
            if self.melds[index2]?.type != "sequence" {continue}
            if self.melds[index3]?.type != "sequence" {continue}
            if self.melds[index1]?.tile1.type != self.melds[index2]?.tile1.type {continue}
            if self.melds[index2]?.tile1.type != self.melds[index3]?.tile1.type {continue}
            let array = [self.melds[index1]!.number, self.melds[index2]!.number, self.melds[index3]!.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] - arraySorted[0] == 3 && arraySorted[2] - arraySorted[1] == 3 {
                self.winType.append("清龙")
                self.winScore.append(16)
                self.isThreeSequences = true
                break
            }
        }
        return
    }
    
    private func isLowerTiles() {
        for tile in self.mahjongTiles {
            if tile.number >= 4 {return}
        }
        self.winType.append("全小")
        self.winScore.append(24)
        return
    }
    
    private func isMiddleTiles() {
        for tile in self.mahjongTiles {
            if tile.number <= 3 {return}
            if tile.number >= 7 {return}
        }
        self.winType.append("全中(不计断幺)")
        self.winScore.append(24)
        return
    }
    
    private func isUpperTiles() {
        for tile in self.mahjongTiles {
            if tile.number <= 6 {return}
            if tile.number >= 10 {return}
        }
        self.winType.append("全大")
        self.winScore.append(24)
        return
    }
    
    private func isPureShiftedPungs() {
        for index1 in 0..<4 {
            let index2 = (index1 + 1) % 4
            let index3 = (index1 + 2) % 4
            if self.melds[index1]?.type != "triplet" && self.melds[index1]?.type != "kong" {continue}
            if self.melds[index2]?.type != "triplet" && self.melds[index2]?.type != "kong" {continue}
            if self.melds[index3]?.type != "triplet" && self.melds[index3]?.type != "kong" {continue}
            if self.melds[index1]?.tile1.type != self.melds[index2]?.tile1.type {continue}
            if self.melds[index2]?.tile1.type != self.melds[index3]?.tile1.type {continue}
            let array = [self.melds[index1]!.number, self.melds[index2]!.number, self.melds[index3]!.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] - arraySorted[0] == 1 && arraySorted[2] - arraySorted[1] == 1 {
                self.winType.append("一色三节高")
                self.winScore.append(24)
                break
            }
        }
        return
    }
    
    private func isPureTripleChow() {
        for index1 in 0..<4 {
            let index2 = (index1 + 1) % 4
            let index3 = (index1 + 2) % 4
            if self.melds[index1]?.type != "sequence" {continue}
            if self.melds[index2]?.type != "sequence" {continue}
            if self.melds[index3]?.type != "sequence" {continue}
            if self.melds[index1]?.tile1.type != self.melds[index2]?.tile1.type {continue}
            if self.melds[index2]?.tile1.type != self.melds[index3]?.tile1.type {continue}
            let array = [self.melds[index1]!.number, self.melds[index2]!.number, self.melds[index3]!.number]
            let arraySorted = array.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            if arraySorted[1] == arraySorted[0] && arraySorted[2] == arraySorted[1]{
                self.winType.append("一色三同顺")
                self.winScore.append(24)
                self.isThreeSequences = true
                break
            }
        }
        return
    }
    
    private func isFullFlush() {
        for meld in self.melds {
            if meld?.tile1.type != self.pair?.tile1.type {return}
        }
        self.winType.append("清一色")
        self.winScore.append(24)

        return
    }
    
    private func isAllEvenPungs() {
        for meld in self.melds {
            if meld?.type != "triplet" && meld?.type != "kong" {return}
            if (meld?.number)! > 9 {return}
            if (meld?.number)! % 2 == 1 {return}
        }
        if (self.pair?.number)! > 9 {return}
        if (self.pair?.number)! % 2 == 1 {return}
        self.winType.append("全双刻(不计碰碰和，断幺)")
        self.winScore.append(24)
        return
    }
    
    private func isGreaterHonorsAndKnittedTiles() -> (bool: Bool, text: String, score: Int) {
        var bool = false
        
        if true {
            bool = true
        }
        return(bool, "七星不靠", 24)
    }
    
    private func isSevenPairs() -> Bool{
        var array = [MahjongTile]()
        for tile in self.mahjongTiles {array.append(tile)}
        for _ in 0..<7 {
            let tileToRemove = array[0]
            array.removeFirst()
            var flag = false
            for index in array.indices {
                if array[index] == tileToRemove {
                    array.remove(at: index)
                    flag = true
                    break
                }
            }
            if !flag {return false}
        }
        self.winType.append("七对")
        self.winScore.append(24)
        
        groupSpecialType()
        isFlower()
        isTileHog()
        isFullyConcealedHand()
        isAllTypes()
        isNoHonors()
        isOneVoidedSuit()
        isHalfFlush()
        isFullFlush()
        isAllGreen()
        isAllSimples()
        isAllTerminalsAndHonors()
        isAllTerminals()
        isAllHonors()
        isUpperFour()
        isLowerFour()
        isUpperTiles()
        isMiddleTiles()
        isLowerTiles()
        
        removeDoubled()
        return true
    }
    
    private func isAllTerminalsAndHonors() {
        for tile in self.mahjongTiles {
            if tile.number > 1 && tile.number < 9 {return}
        }
        self.winType.append("混幺九(不计碰碰和，全带幺，幺九刻)")
        self.winScore.append(32)
        return
    }
    
    private func isThreeKongs() {
        var kongIndices = [Int]()
        for index in self.melds.indices {
            if self.melds[index]!.type == "kong" {kongIndices.append(index)}
        }
        if kongIndices.count == 3 {
            self.winType.append("三杠")
            self.winScore.append(32)
        }
        return
    }
    
    private func isFourPureShiftedChows() {
        if self.melds[0]?.type != "sequence" {return}
        if self.melds[1]?.type != "sequence" {return}
        if self.melds[2]?.type != "sequence" {return}
        if self.melds[3]?.type != "sequence" {return}
        if self.melds[0]?.tile1.type != self.melds[1]?.tile1.type {return}
        if self.melds[1]?.tile1.type != self.melds[2]?.tile1.type {return}
        if self.melds[2]?.tile1.type != self.melds[3]?.tile1.type {return}
        let array = [self.melds[0]!.number, self.melds[1]!.number, self.melds[2]!.number, self.melds[3]!.number]
        let arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        if arraySorted[1] - arraySorted[0] == 1 && arraySorted[2] - arraySorted[1] == 1 && arraySorted[3] - arraySorted[2] == 1 {
            self.winType.append("一色四步高")
            self.winScore.append(32)
            self.isFourSequences = true
        }
        if arraySorted[1] - arraySorted[0] == 2 && arraySorted[2] - arraySorted[1] == 2 && arraySorted[3] - arraySorted[2] == 2 {
            self.winType.append("一色四步高")
            self.winScore.append(32)
            self.isFourSequences = true
        }
        return
    }
    
    private func isFourPureShiftedPungs() {
        if self.melds[0]?.type != "triplet" && self.melds[0]?.type != "kong" {return}
        if self.melds[1]?.type != "triplet" && self.melds[1]?.type != "kong" {return}
        if self.melds[2]?.type != "triplet" && self.melds[2]?.type != "kong" {return}
        if self.melds[3]?.type != "triplet" && self.melds[3]?.type != "kong" {return}
        if self.melds[0]?.tile1.type != self.melds[1]?.tile1.type {return}
        if self.melds[1]?.tile1.type != self.melds[2]?.tile1.type {return}
        if self.melds[2]?.tile1.type != self.melds[3]?.tile1.type {return}
        let array = [self.melds[0]!.number, self.melds[1]!.number, self.melds[2]!.number, self.melds[3]!.number]
        let arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        if arraySorted[1] - arraySorted[0] == 1 && arraySorted[2] - arraySorted[1] == 1 && arraySorted[3] - arraySorted[2] == 1 {
            self.winType.append("一色四节高")
            self.winScore.append(48)
        }
        return
    }
    
    private func isQuadrupleChow() {
        if self.melds[0]?.type != "sequence" {return}
        if self.melds[1]?.type != "sequence" {return}
        if self.melds[2]?.type != "sequence" {return}
        if self.melds[3]?.type != "sequence" {return}
        if self.melds[0]?.tile1.type != self.melds[1]?.tile1.type {return}
        if self.melds[1]?.tile1.type != self.melds[2]?.tile1.type {return}
        if self.melds[2]?.tile1.type != self.melds[3]?.tile1.type {return}
        let array = [self.melds[0]!.number, self.melds[1]!.number, self.melds[2]!.number, self.melds[3]!.number]
        let arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        if arraySorted[1] == arraySorted[0] && arraySorted[2] == arraySorted[1] && arraySorted[3] == arraySorted[2] {
            self.winType.append("一色四同顺")
            self.winScore.append(48)
            self.isFourSequences = true
        }
        return
    }
    
    private func isPureTerminalChows() {
        for meld in self.melds {
            if meld?.type != "sequence" {return}
        }
        if self.pair?.number != 5 {return}
        let array = [self.melds[0], self.melds[1], self.melds[2], self.melds[3]]
        var arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1!.number < s2!.number
        }
        if arraySorted[0]?.number != 1 {return}
        if arraySorted[1]?.number != 1 {return}
        if arraySorted[2]?.number != 7 {return}
        if arraySorted[3]?.number != 7 {return}
        
        arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1!.tile1.type < s2!.tile1.type
        }
        if arraySorted[0]?.tile1.type != arraySorted[1]?.tile1.type {return}
        if arraySorted[2]?.tile1.type != arraySorted[3]?.tile1.type {return}
        
        if arraySorted[0]?.tile1.type != arraySorted[2]?.tile1.type {return}
        if arraySorted[2]?.tile1.type != self.pair?.tile1.type {return}
        
        self.winType.append("一色双龙会(不计清一色，平和，无字)")
        self.winScore.append(64)
        self.isFourSequences = true
        return
    }
    
    private func isFourConcealedPungs() {
        var numberOfConcealedPungs = 0
        for meld in self.melds {
            if meld?.type == "triplet" || meld?.type == "kong" {
                if meld?.isExposed == false {numberOfConcealedPungs += 1}
            }
        }
        if numberOfConcealedPungs == 4 {
            self.winType.append("四暗刻")
            self.winScore.append(64)
        }
        return
    }
    
    private func isAllHonors() {
        for tile in self.mahjongTiles {
            if tile.number < 10 {return}
        }
        self.winType.append("字一色(不计碰碰和，全带幺，幺九刻)")
        self.winScore.append(64)
        return
    }
    
    private func isLittleThreeDragons() {
        var numberOfDragonPung = 0
        for meld in melds {
            if meld?.type != "triplet" && meld?.type != "kong" {continue}
            if meld?.tile1.type == "dragon" {numberOfDragonPung += 1}
        }
        if numberOfDragonPung == 2, self.pair?.tile1.type == "dragon" {
            self.winType.append("小三元")
            self.winScore.append(64)
        }
        return
    }
    
    private func isLittleFourWinds() {
        var numberOfWindPung = 0
        for meld in melds {
            if meld?.type != "triplet" && meld?.type != "kong" {continue}
            if meld?.tile1.type == "wind" {numberOfWindPung += 1}
        }
        if numberOfWindPung == 3, self.pair?.tile1.type == "wind" {
            self.winType.append("小四喜")
            self.winScore.append(64)
        }
        return
    }
    
    private func isAllTerminals() {
        for tile in self.mahjongTiles {
            if tile.number != 1 && tile.number != 9 {return}
        }
        self.winType.append("清幺九(不计碰碰和，全带幺，幺九刻，无字)")
        self.winScore.append(64)
        return
    }
    
    private func isThirteenOrphans() -> Bool {
        for tile in self.mahjongTiles {
            if tile.number > 1 && tile.number < 9 {return false}
        }
        var numberOfSameTile = 0
        for index1 in 0..<14 {
            for index2 in (index1+1)..<14 {
                if self.mahjongTiles[index1] == self.mahjongTiles[index2] {numberOfSameTile += 1}
                if numberOfSameTile == 2 {return false}
            }
        }
        self.winType.append("十三幺")
        self.winScore.append(88)
        groupSpecialType()
        isFlower()
        isFullyConcealedHand()
        return true
    }
    
    private func isSevenShiftedPairs() -> Bool {
        for tile in self.mahjongTiles {
            if tile.type != mahjongTiles[0].type {return false}
        }
        var array = [Int]()
        for tile in self.mahjongTiles {array.append(tile.number)}
        let arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        let set1 = [1,1,2,2,3,3,4,4,5,5,6,6,7,7]
        let set2 = [2,2,3,3,4,4,5,5,6,6,7,7,8,8]
        let set3 = [3,3,4,4,5,5,6,6,7,7,8,8,9,9]
        if arraySorted != set1 && arraySorted != set2 && arraySorted != set3 {return false}
        self.winType.append("连七对")
        self.winScore.append(88)
        groupSpecialType()
        isFlower()
        isFullyConcealedHand()
        isAllSimples()
        removeWinType(name: "七对")
        return true
    }
    
    private func isFourKongs() {
        var kongIndices = [Int]()
        for index in self.melds.indices {
            if self.melds[index]!.type == "kong" {kongIndices.append(index)}
        }
        if kongIndices.count == 4 {
            self.winType.append("四杠(不计碰碰和，单吊将)")
            self.winScore.append(88)
        }
        return
    }
    
    private func isNineGates() {
        for meld in self.melds {
            if (meld?.isExposed)! {return}
        }
        for tile in self.mahjongTiles {
            if tile.type != self.mahjongTiles[0].type {return}
        }
        var array = [Int]()
        for tile in self.mahjongTiles {array.append(tile.number)}
        var arraySorted = array.sorted { (s1, s2) -> Bool in
            return s1 < s2
        }
        if arraySorted[3] == 1 { arraySorted.remove(at: 3)}
        else if arraySorted[10] == 9 { arraySorted.remove(at: 10)}
        var dic: [Int:Int] = [:]
        for index in arraySorted.indices {
            if arraySorted[index] == 1 || arraySorted[index] == 9 {continue}
            dic[arraySorted[index]] = (dic[arraySorted[index]] ?? 0) + 1
            if dic[arraySorted[index]] == 2 {
                arraySorted.remove(at: index)
                break
            }
        }
        if arraySorted == [1,1,1,2,3,4,5,6,7,8,9,9,9] {
            self.winType.append("九莲宝灯(不计一副幺九刻，门前清)")
            self.winScore.append(88)
        }
        return
    }
    
    private func isAllGreen() {
        for tile in self.mahjongTiles {
            if tile.number == 2000 {continue}
            if tile.type != "bamboo" {return}
            if tile.number == 1 || tile.number == 5 || tile.number == 7 || tile.number == 9 {return}
        }
        
        self.winType.append("绿一色")
        self.winScore.append(88)
        return
    }
    
    private func isBigThreeDragons() {
        var numberOfDragonPung = 0
        for meld in melds {
            if meld?.type != "triplet" && meld?.type != "kong" {continue}
            if meld?.tile1.type == "dragon" {numberOfDragonPung += 1}
        }
        if numberOfDragonPung == 3 {
            self.winType.append("大三元")
            self.winScore.append(88)
        }
        return
    }
    
    private func isBigFourWinds() {
        var numberOfWindPung = 0
        for meld in melds {
            if meld?.type != "triplet" && meld?.type != "kong" {continue}
            if meld?.tile1.type == "wind" {numberOfWindPung += 1}
        }
        if numberOfWindPung == 4 {
            self.winType.append("大四喜")
            self.winScore.append(88)
        }
        return
    }
}
