//
//  ViewController.swift
//  Mahjong Scoring
//
//  Created by 戚越 on 2018/12/3.
//  Copyright © 2018 Yue QI. All rights reserved.
//

import UIKit
//import AVFoundation

class ViewController: UIViewController {
    @IBAction func touchTakePhoto(_ sender: Any) {
        self.performSegue(withIdentifier: "UseCamera", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UseCamera" {
//            let previewViewController = segue.destination as! TakePhotoViewController
//            previewViewController.isTakePhoto = self.isTakePhoto
//        }
//    }
    
    
    lazy var mahjongScoring: MahjongScoring = MahjongScoring()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //圈风 门风 花牌 按钮设置
    @IBOutlet weak var prevailingWind: UIButton!
    @IBOutlet weak var dealersWind: UIButton!
    @IBOutlet weak var numberOfFlowers: UIButton!
    
    @IBAction func choosePrevailingWind(_ sender: Any) {
        let windSheet = UIAlertController(title: "圈风", message: "请选择圈风", preferredStyle: UIAlertController.Style.actionSheet)
        
        let chooseWindEastAction = UIAlertAction(title: "东", style: UIAlertAction.Style.default){
            (ACTION) in
            self.prevailingWind.setTitle("圈风：东", for: UIControl.State.normal)
            self.mahjongScoring.prevailingWind = "east"
        }
        let chooseWindSouthAction = UIAlertAction(title: "南", style: UIAlertAction.Style.default){
            (ACTION) in
            self.prevailingWind.setTitle("圈风：南", for: UIControl.State.normal)
            self.mahjongScoring.prevailingWind = "south"
        }
        let chooseWindWestAction = UIAlertAction(title: "西", style: UIAlertAction.Style.default){
            (ACTION) in
            self.prevailingWind.setTitle("圈风：西", for: UIControl.State.normal)
            self.mahjongScoring.prevailingWind = "west"
        }
        let chooseWindNorthAction = UIAlertAction(title: "北", style: UIAlertAction.Style.default){
            (ACTION) in
            self.prevailingWind.setTitle("圈风：北", for: UIControl.State.normal)
            self.mahjongScoring.prevailingWind = "north"
        }
        let chooseNoneAction = UIAlertAction(title: "无", style: UIAlertAction.Style.default){
            (ACTION) in
            self.prevailingWind.setTitle("圈风：无", for: UIControl.State.normal)
            self.mahjongScoring.prevailingWind = "none"
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel){
            (ACTION) in
            
        }
        
        windSheet.addAction(chooseWindEastAction)
        windSheet.addAction(chooseWindSouthAction)
        windSheet.addAction(chooseWindWestAction)
        windSheet.addAction(chooseWindNorthAction)
        windSheet.addAction(chooseNoneAction)
        windSheet.addAction(cancelAction)
        
        self.present(windSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func chooseDealersWind(_ sender: Any) {
        let windSheet = UIAlertController(title: "门风", message: "请选择门风", preferredStyle: UIAlertController.Style.actionSheet)
        
        let chooseWindEastAction = UIAlertAction(title: "东", style: UIAlertAction.Style.default){
            (ACTION) in
            self.dealersWind.setTitle("门风：东", for: UIControl.State.normal)
            self.mahjongScoring.dealersWind = "east"
        }
        let chooseWindSouthAction = UIAlertAction(title: "南", style: UIAlertAction.Style.default){
            (ACTION) in
            self.dealersWind.setTitle("门风：南", for: UIControl.State.normal)
            self.mahjongScoring.dealersWind = "south"
        }
        let chooseWindWestAction = UIAlertAction(title: "西", style: UIAlertAction.Style.default){
            (ACTION) in
            self.dealersWind.setTitle("门风：西", for: UIControl.State.normal)
            self.mahjongScoring.dealersWind = "west"
        }
        let chooseWindNorthAction = UIAlertAction(title: "北", style: UIAlertAction.Style.default){
            (ACTION) in
            self.dealersWind.setTitle("门风：北", for: UIControl.State.normal)
            self.mahjongScoring.dealersWind = "north"
        }
        let chooseNoneAction = UIAlertAction(title: "无", style: UIAlertAction.Style.default){
            (ACTION) in
            self.dealersWind.setTitle("门风：无", for: UIControl.State.normal)
            self.mahjongScoring.dealersWind = "none"
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel){
            (ACTION) in
            
        }
        
        windSheet.addAction(chooseWindEastAction)
        windSheet.addAction(chooseWindSouthAction)
        windSheet.addAction(chooseWindWestAction)
        windSheet.addAction(chooseWindNorthAction)
        windSheet.addAction(cancelAction)
        windSheet.addAction(chooseNoneAction)
        
        self.present(windSheet, animated: true, completion: nil)
    }
    
    @IBAction func chooseNumberOfFlower(_ sender: Any) {
        let numberOfFlowerSheet = UIAlertController(title: "花牌", message: "请选择花牌", preferredStyle: UIAlertController.Style.actionSheet)
        
        let chooseZeroAction = UIAlertAction(title: "0", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：0", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 0
        }
        let chooseOneAction = UIAlertAction(title: "1", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：1", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 1
        }
        let chooseTwoAction = UIAlertAction(title: "2", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：2", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 2
        }
        let chooseThreeAction = UIAlertAction(title: "3", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：3", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 3
        }
        let chooseFourAction = UIAlertAction(title: "4", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：4", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 4
        }
        let chooseFiveAction = UIAlertAction(title: "5", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：5", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 5
        }
        let chooseSixAction = UIAlertAction(title: "6", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：6", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 6
        }
        let chooseSevenAction = UIAlertAction(title: "7", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：7", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 7
        }
        let chooseEightAction = UIAlertAction(title: "8", style: UIAlertAction.Style.default){
            (ACTION) in
            self.numberOfFlowers.setTitle("花牌：8", for: UIControl.State.normal)
            self.mahjongScoring.numberOfFlowers = 8
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel){
            (ACTION) in
            
        }
        
        numberOfFlowerSheet.addAction(chooseZeroAction)
        numberOfFlowerSheet.addAction(chooseOneAction)
        numberOfFlowerSheet.addAction(chooseTwoAction)
        numberOfFlowerSheet.addAction(chooseThreeAction)
        numberOfFlowerSheet.addAction(chooseFourAction)
        numberOfFlowerSheet.addAction(chooseFiveAction)
        numberOfFlowerSheet.addAction(chooseSixAction)
        numberOfFlowerSheet.addAction(chooseSevenAction)
        numberOfFlowerSheet.addAction(chooseEightAction)
        numberOfFlowerSheet.addAction(cancelAction)
        
        self.present(numberOfFlowerSheet, animated: true, completion: nil)
    }
    
    // 自摸 点胡 特殊番种设置
    @IBOutlet weak var selfDrawn: UIButton!
    @IBAction func chooseSelfDrawn(_ sender: UIButton) {
        if mahjongScoring.IsSelfDrawn {
            mahjongScoring.IsSelfDrawn = false
            sender.isSelected = false
        } else {
            mahjongScoring.IsSelfDrawn = true
            sender.isSelected = true
        }
    }
    
    @IBOutlet weak var lastTile: UIButton!
    @IBAction func chooseLastTile(_ sender: UIButton) {
        if mahjongScoring.IsLastTile {
            mahjongScoring.IsLastTile = false
            sender.isSelected = false
        } else {
            mahjongScoring.IsLastTile = true
            sender.isSelected = true
        }
    }
    
    
    @IBOutlet weak var specialWinArt: UIButton!
    @IBAction func chooseSpecialWinArt(_ sender: UIButton) {
        let specialWinArtSheet = UIAlertController(title: "特殊番种", message: "请选择特殊番种", preferredStyle: UIAlertController.Style.actionSheet)
        
        let chooseIsLastTileDrawAction = UIAlertAction(title: "妙手回春", style: UIAlertAction.Style.default){
            (ACTION) in
            self.specialWinArt.setTitle("特殊番种：妙手回春", for: UIControl.State.normal)
            self.mahjongScoring.clearSpecialWin()
            self.mahjongScoring.IsLastTileDraw = true
            
            self.selfDrawn.isEnabled = false
            
            if self.selfDrawn.isSelected {
                self.selfDrawn.isSelected = false
                self.mahjongScoring.IsSelfDrawn = false
            }
            
            self.lastTile.isEnabled = true
        }
        
        let chooseIsLastTileClaimAction = UIAlertAction(title: "海底捞月", style: UIAlertAction.Style.default){
            (ACTION) in
            self.specialWinArt.setTitle("特殊番种：海底捞月", for: UIControl.State.normal)
            self.mahjongScoring.clearSpecialWin()
            self.mahjongScoring.IsLastTileClaim = true
            
            self.selfDrawn.isEnabled = true
            self.lastTile.isEnabled = true
        }
        
        let chooseIsOutWithReplacementTileAction = UIAlertAction(title: "杠上开花", style: UIAlertAction.Style.default){
            (ACTION) in
            self.specialWinArt.setTitle("特殊番种：杠上开花", for: UIControl.State.normal)
            self.mahjongScoring.clearSpecialWin()
            self.mahjongScoring.IsOutWithReplacementTile = true
            
            self.selfDrawn.isEnabled = true
            self.lastTile.isEnabled = true
        }
        
        let chooseIsRobbingTheKongAction = UIAlertAction(title: "抢杠胡", style: UIAlertAction.Style.default){
            (ACTION) in
            self.specialWinArt.setTitle("特殊番种：抢杠胡", for: UIControl.State.normal)
            self.mahjongScoring.clearSpecialWin()
            self.mahjongScoring.IsRobbingTheKong = true
            
            self.lastTile.isEnabled = false
            
            if self.lastTile.isSelected {
                self.lastTile.isSelected = false
                self.mahjongScoring.IsLastTile = false
            }
            
            self.selfDrawn.isEnabled = true
            
            
            
        }
        
        let chooseNoneAction = UIAlertAction(title: "无", style: UIAlertAction.Style.default){
            (ACTION) in
            self.specialWinArt.setTitle("特殊番种：无", for: UIControl.State.normal)
            self.mahjongScoring.clearSpecialWin()
            
            self.selfDrawn.isEnabled = true
            self.lastTile.isEnabled = true
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel){
            (ACTION) in
        }
        
        specialWinArtSheet.addAction(chooseIsLastTileDrawAction)
        specialWinArtSheet.addAction(chooseIsLastTileClaimAction)
        specialWinArtSheet.addAction(chooseIsOutWithReplacementTileAction)
        specialWinArtSheet.addAction(chooseIsRobbingTheKongAction)
        specialWinArtSheet.addAction(chooseNoneAction)
        specialWinArtSheet.addAction(cancelAction)
        
        self.present(specialWinArtSheet, animated: true, completion: nil)
    }
    
    
    //选牌按钮设置
    
    @IBOutlet var ButtonEmpty: [UIButton]! //上方按钮
    var ButtonsPressedTimes = [Int](repeating: 0, count: 34) //记录按钮次数
    var listPressedButton: [Int] = []//记录上一次按过的按钮
    
    @IBOutlet var Buttons: [UIButton]!
    
    @IBAction func touchTile(_ sender: UIButton) {
        if mahjongScoring.currentIndex <= 13{
            ButtonEmpty[mahjongScoring.currentIndex].setImage(sender.currentImage, for: UIControl.State.normal)
            //ButtonEmpty[mahjongScoring.currentIndex].setTitle(sender.title(for: UIControl.State.normal), for: UIControl.State.normal)
            mahjongScoring.currentIndex += 1
            
            let tile = MahjongTile.getTile(from: Buttons.firstIndex(of: sender)!)
            mahjongScoring.mahjongTiles.append(tile)
            //print (mahjongScoring.mahjongTiles)
            
            listPressedButton.append(Buttons.firstIndex(of: sender)!)
            ButtonsPressedTimes[listPressedButton[listPressedButton.count - 1]] += 1
            if ButtonsPressedTimes[listPressedButton[listPressedButton.count - 1]] == 4 {
                sender.isEnabled = false
            }
        }
        
        //build
        if mahjongScoring.currentIndex == 14 {
            mahjongScoring.build()
            //全部设为暗
            for button in ButtonsIsExposed {
                if button.image(for: UIControl.State.normal) == UIImage(named: "icon_empty") {
                    button.setImage(UIImage(named: "icon_concealed"), for: UIControl.State.normal)
                }
            }
            
            buttonIsExposed_Pair.setImage(UIImage(named: "icon_concealed"), for: UIControl.State.normal)
            //为暗牌加上底色
            
            
            for button in ButtonsIsKong {
                let index = ButtonsIsKong.firstIndex(of: button)!
                if (mahjongScoring.melds[index]?.type == "sequence"){
                    button.setImage(UIImage(named: "icon_sequence"), for: UIControl.State.normal)
                } else if (mahjongScoring.melds[index]?.type == "triplet"){
                    button.setImage(UIImage(named: "icon_triplet"), for: UIControl.State.normal)
                } else if (mahjongScoring.melds[index]?.type == "kong"){
                    button.setImage(UIImage(named: "icon_kong"), for: UIControl.State.normal)
                } else {
                    button.setImage(UIImage(named: "icon_?"), for: UIControl.State.normal)
                }
            }
            
            if mahjongScoring.pair?.type == "pair" {
                buttonIsPair.setImage(UIImage(named: "icon_pair"), for: UIControl.State.normal)
            } else {
                buttonIsPair.setImage(UIImage(named: "icon_?"), for: UIControl.State.normal)
            }
        }
    }
    
    //选择胡牌按钮高亮
    var IndexOfLastHighlightedButton: Int? = nil
    @IBAction func highlightButton(_ sender: UIButton) {
        if sender.image(for: UIControl.State.normal) == UIImage(named: "empty") {
            return
        } //防止用户乱按空白按钮
        /*if sender.title(for: UIControl.State.normal) == "Button" {
            return
        }*/
        /*
        if IndexOfLastHighlightedButton != nil {
            ButtonEmpty[IndexOfLastHighlightedButton!].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } */
        
        if IndexOfLastHighlightedButton == ButtonEmpty.firstIndex(of: sender) {
            if sender.backgroundColor == #colorLiteral(red: 1, green: 0.7843137255, blue: 0.7843137255, alpha: 1) {
                sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                sender.backgroundColor = #colorLiteral(red: 1, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
            }
            
        } else {
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
            if IndexOfLastHighlightedButton != nil {
                ButtonEmpty[IndexOfLastHighlightedButton!].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
        mahjongScoring.winTile = MahjongTile.getTile(from: listPressedButton[ButtonEmpty.firstIndex(of: sender)!])
        mahjongScoring.winTileIndex = ButtonEmpty.firstIndex(of: sender)!
        IndexOfLastHighlightedButton = ButtonEmpty.firstIndex(of: sender)!
    }
        
    
    
    
    //明暗设置
    
    @IBOutlet var ButtonsIsExposed: [UIButton]!
    @IBAction func touchIsExposed(_ sender: UIButton) {
        let index = ButtonsIsExposed.firstIndex(of: sender)!
        if mahjongScoring.currentIndex == 14, mahjongScoring.melds[index] != nil {
            if mahjongScoring.melds[index]?.isExposed == true{
                ButtonsIsExposed[index].setImage(UIImage(named: "icon_concealed"), for: UIControl.State.normal)
                mahjongScoring.melds[index]?.isExposed = false
                
                if mahjongScoring.melds[index]?.isKong == false{
                    for j in 0..<3 {
                        ButtonEmpty[index*3+j].isEnabled = true
                    }
                }
            } else {
                ButtonsIsExposed[index].setImage(UIImage(named: "icon_exposed"), for: UIControl.State.normal)
                mahjongScoring.melds[index]?.isExposed = true
                for j in 0..<3 {
                    ButtonEmpty[index*3+j].isEnabled = false
                    ButtonEmpty[index*3+j].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
        mahjongScoring.updateType()
    }
    
    
    
    //杠刻设置
    @IBOutlet var ButtonsIsKong: [UIButton]!
    @IBAction func touchIsKong(_ sender: UIButton) {
        let index = ButtonsIsKong.firstIndex(of: sender)!
        if mahjongScoring.currentIndex == 14, (mahjongScoring.melds[index]?.type == "triplet" || mahjongScoring.melds[index]?.type == "kong"){
            if mahjongScoring.melds[index]?.isKong == true{
                ButtonsIsKong[index].setImage(UIImage(named: "icon_triplet"), for: UIControl.State.normal)
                mahjongScoring.melds[index]?.isKong = false
                
                if mahjongScoring.melds[index]?.isExposed == false{
                    for j in 0..<3 {
                        ButtonEmpty[index*3+j].isEnabled = true
                    }
                }
            } else {
                ButtonsIsKong[index].setImage(UIImage(named: "icon_kong"), for: UIControl.State.normal)
                mahjongScoring.melds[index]?.isKong = true
                for j in 0..<3 {
                    ButtonEmpty[index*3+j].isEnabled = false
                    ButtonEmpty[index*3+j].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
        mahjongScoring.updateType()
    }
    
    //将牌设置
    
    @IBOutlet weak var buttonIsExposed_Pair: UIButton!
    @IBOutlet weak var buttonIsPair: UIButton!
    
    
    //退后
    @IBAction func touchBack(_ sender: Any) {
        if mahjongScoring.currentIndex >= 1{
            mahjongScoring.currentIndex -= 1
            ButtonEmpty[mahjongScoring.currentIndex].setImage(UIImage(named: "empty"), for: UIControl.State.normal)
            ButtonsPressedTimes[listPressedButton[listPressedButton.count - 1]] -= 1//解放失效的按钮
            if ButtonsPressedTimes[listPressedButton[listPressedButton.count - 1]] < 4 {
                Buttons[listPressedButton[listPressedButton.count - 1]].isEnabled = true
            }//解放失效的按钮
            self.listPressedButton.remove(at: listPressedButton.count - 1) //解放失效的按钮
            mahjongScoring.mahjongTiles.remove(at: mahjongScoring.mahjongTiles.count - 1)
        }
        // 判断并设置明暗杠按钮的状态
        if mahjongScoring.currentIndex < 14 {
            for button in ButtonsIsExposed {
                button.setImage(UIImage(named: "icon_empty"), for: UIControl.State.normal)
            }
            for button in ButtonsIsKong {
                button.setImage(UIImage(named: "icon_empty"), for: UIControl.State.normal)
            }
            buttonIsPair.setImage(UIImage(named: "icon_empty"), for: UIControl.State.normal)
        }
        
        buttonIsExposed_Pair.setImage(UIImage(named: "icon_empty"), for: UIControl.State.normal)
        
        //解放选中的和牌
        if IndexOfLastHighlightedButton != nil {
            mahjongScoring.winTile = nil
            ButtonEmpty[IndexOfLastHighlightedButton!].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        //解放失效的ButtonEmpty
        for button in ButtonEmpty{
            button.isEnabled = true
        }
    }
    
    //删除
    @IBAction func touchDelete(_ sender: Any) {
        for button in ButtonEmpty{
            button.setImage(UIImage(named: "empty"), for: UIControl.State.normal)
        }
        mahjongScoring.mahjongTiles.removeAll()
        mahjongScoring.currentIndex = 0
        // 判断并设置明暗杠按钮的状态
        if mahjongScoring.currentIndex < 14 {
            for button in ButtonsIsExposed {
                button.setImage(UIImage(named: "icon_empty"), for: UIControl.State.normal)
            }
            for button in ButtonsIsKong {
                button.setImage(UIImage(named: "icon_empty"), for: UIControl.State.normal)
            }
            buttonIsPair.setImage(UIImage(named: "icon_empty"), for: UIControl.State.normal)
        }
        //解放失效的按钮
        for index in ButtonsPressedTimes.indices {
            ButtonsPressedTimes[index] = 0
        }
        for button in Buttons{
            button.isEnabled = true
        }
        listPressedButton.removeAll()
        
        buttonIsExposed_Pair.setImage(UIImage(named: "icon_empty"), for: UIControl.State.normal)
        
        //解放选中的和牌
        if IndexOfLastHighlightedButton != nil {
            mahjongScoring.winTile = nil
            ButtonEmpty[IndexOfLastHighlightedButton!].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        //解放失效的ButtonEmpty
        for button in ButtonEmpty{
            button.isEnabled = true
        }
    }
    
    
    //计算
    
    @IBAction func touchCalculate(_ sender: Any) {
        if mahjongScoring.currentIndex < 14 {
            let alert=UIAlertController(title:"请选择14张牌",message:nil,preferredStyle:.actionSheet)
            let action=UIAlertAction(title:"取消",style:.default,handler:nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        } else if mahjongScoring.winTile == nil {
            let alert=UIAlertController(title:"请选择和的那张牌",message:nil,preferredStyle:.actionSheet)
            let action=UIAlertAction(title:"取消",style:.default,handler:nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        var alert=UIAlertController(title:"诈和😡😡😡",message: nil,preferredStyle:.actionSheet)
        
        if mahjongScoring.getScore() {
            var finalMessage: String = ""
            var finalScore: Int = 0
            
            let winScoreIndex = mahjongScoring.winScore.indices
            let winScoreIndexSorted = winScoreIndex.sorted {(s1, s2) -> Bool in
                return mahjongScoring.winScore[s1] > mahjongScoring.winScore[s2]
            }
            
            for index in winScoreIndexSorted.indices {
                finalMessage += mahjongScoring.winType[winScoreIndexSorted[index]]
                finalMessage += ": \(mahjongScoring.winScore[winScoreIndexSorted[index]])\n"
                finalScore += mahjongScoring.winScore[winScoreIndexSorted[index]]
            }

            alert=UIAlertController(title:"总番数：\(finalScore)",message: finalMessage,preferredStyle:.actionSheet)
        }
        //mahjongScoring.build()
        
        let action=UIAlertAction(title:"取消",style:.default,handler:nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

