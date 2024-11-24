//
//  GameScene.swift
//  HexagonGame
//
//  Created by Дмитрий Докукин on 11/01/2020.
//  Copyright © 2020 Дмитрий Докукин. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    var StrMax: String = ""
    var index = 0
    var additionalDictionary: [Int: (i: Int, j: Int)] = [:]
    var secondDictionary: [[Int]: Int] = [:]
    var blackArray: [Int] = []
    var ancorsArray = [SKShapeNode]()
    var points = [CGPoint(x: -18, y: 28),
                  CGPoint(x: 18, y: 28),
                  CGPoint(x: 40, y: 0),
                  CGPoint(x: 18, y: -28),
                  CGPoint(x: -18, y: -28),
                  CGPoint(x: -40, y: 0),
                  CGPoint(x: -18, y: 28)
                ]
    var blackConst = SKColor.black
    
   /* var points = [CGPoint(x: -14, y: 25),
                  CGPoint(x: 14, y: 25),
                  CGPoint(x: 30, y: 0),
                  CGPoint(x: 14, y: -25),
                  CGPoint(x: -14, y: -25),
                  CGPoint(x: -30, y: 0),
                  CGPoint(x: -14, y: 25)
                 ] */
    var Nemesis = Tyrant()
    override func didMove(to view: SKView) {
        SceneSetting()
        createAncors()
        preparingField()
        Nemesis.arrayWithAncors = ancorsArray
        Nemesis.additionalDictionary = additionalDictionary
        Nemesis.secondDictionary = secondDictionary
        Nemesis.arrayWithBlackCells = blackArray
        Nemesis.getWhite()
        blackConst = ancorsArray[21].fillColor
    
    }
    
    func SceneSetting() {
        self.backgroundColor = SKColor.gray
    }
    
    func createAncors() {
        //let realX = 375, realY = 300
        //let some_x = 265, some_x1 = -265 // / 53 = 5
        var x = 0, y = 240 // 272
        for i in 1...9 {
            x = 375 - 70*(i-1)
            y = 931 - 33*(i-1)
            for j in 1...9 {
                if x >= 725 || x <= 25 {
                    x += 70//53
                    y -= 33//30
                    continue
                }
                ancorsArray.append(SKShapeNode(points: &points, count: points.count))
                ancorsArray[index].lineWidth = 5 // задаем размер линий
                ancorsArray[index].fillColor = SKColor.white
                ancorsArray[index].strokeColor = SKColor.blue // задаем цвет контура
                ancorsArray[index].position = CGPoint(x: x, y: y)
                self.addChild(ancorsArray[index])
                ancorsArray[index].name = String(index)
                additionalDictionary[index]=(i: i, j: j)
                //print(additionalDictionary[index] as Any)
                secondDictionary[[i, j]] = index
                x += 70//53
                y -= 33//30
                index += 1
            }
        }
        print("The last index: = \(index-1)")
        
    }
    
    func strokeColoring(index internalIndex: Int) {
        stepOne(I: -1, J: 0, externalIndex: internalIndex, color: .red, repeating: 1)
        stepOne(I: 0, J: 1, externalIndex: internalIndex, color: .red, repeating: 1)
        stepOne(I: 1, J: 1, externalIndex: internalIndex, color: .red, repeating: 1)
        stepOne(I: 1, J: 0, externalIndex: internalIndex, color: .red, repeating: 1)
        stepOne(I: 0, J: -1, externalIndex: internalIndex, color: .red, repeating: 1)
        stepOne(I: -1, J: -1, externalIndex: internalIndex, color: .red, repeating: 1)
    }
    
    func stepOne(I: Int, J: Int, externalIndex: Int, color: SKColor, repeating: Int) {
        let i = additionalDictionary[externalIndex]!.i + I
        let j = additionalDictionary[externalIndex]!.j + J
        if let secondIndex = secondDictionary[[i, j]] {
             for a in 0...2 {
                 if secondIndex == blackArray[a] {return}
             }
            if ancorsArray[secondIndex].fillColor == SKColor.green {return}
            if ancorsArray[secondIndex].strokeColor == SKColor.red { return}
            if ancorsArray[secondIndex].fillColor == SKColor.red { return}
             if ancorsArray[secondIndex].fillColor != SKColor.red {
                 ancorsArray[secondIndex].strokeColor = color
             }
        } else { return}
        if repeating > 0 {
            stepOne(I: -1, J: 0, externalIndex: secondDictionary[[i, j]]!, color: .yellow, repeating: repeating-1)
            stepOne(I: 0, J: 1, externalIndex: secondDictionary[[i, j]]!, color: .yellow, repeating: repeating-1)
            stepOne(I: 1, J: 1, externalIndex: secondDictionary[[i, j]]!, color: .yellow, repeating: repeating-1)
            stepOne(I: 1, J: 0, externalIndex: secondDictionary[[i, j]]!, color: .yellow, repeating: repeating-1)
            stepOne(I: 0, J: -1, externalIndex: secondDictionary[[i, j]]!, color: .yellow, repeating: repeating-1)
            stepOne(I: -1, J: -1, externalIndex: secondDictionary[[i, j]]!, color: .yellow, repeating: repeating-1)
        }
    }
    
    func paintStrokesBlue() {
        for i in 0..<index {
            ancorsArray[i].strokeColor = SKColor.blue
        }
    }
    
    func preparingField() {
        var a = secondDictionary[[1, 1]]!
        ancorsArray[a].fillColor = SKColor.red
        a = secondDictionary[[9, 5]]!
        ancorsArray[a].fillColor = SKColor.red
        a = secondDictionary[[5, 9]]!
        ancorsArray[a].fillColor = SKColor.red
        
        a = secondDictionary[[9, 9]]!
        ancorsArray[a].fillColor = SKColor.green
        a = secondDictionary[[1, 5]]!
        ancorsArray[a].fillColor = SKColor.green
        a = secondDictionary[[5, 1]]!
        ancorsArray[a].fillColor = SKColor.green
        
        a = secondDictionary[[4, 4]]!
        blackArray.append(a)
        ancorsArray[a].fillColor = SKColor.black
        a = secondDictionary[[5, 6]]!
        blackArray.append(a)
        ancorsArray[a].fillColor = SKColor.black
        a = secondDictionary[[6, 5]]!
        blackArray.append(a)
        ancorsArray[a].fillColor = SKColor.black
    }
    
    var firstCircleCells: [Int] = []
  
    func paintEnemy(externalIndex: Int, color: SKColor) {
        var i = 0
         var j = 0
         for addi in [-1, 0, 1] {
             preMainLoop: for addj in [-1, 0, 1] {
                 if (addi == 0 && addj == 0) || (addi == 1 && addj == -1) || (addi == -1 && addj == 1) {continue}
                 i = additionalDictionary[externalIndex]!.i + addi
                 j = additionalDictionary[externalIndex]!.j + addj
                 if let secondIndex = secondDictionary[[i, j]] {
                     for a in 0...2 {
                         if secondIndex == blackArray[a] {continue preMainLoop}
                     }
                    if color == SKColor.green {
                        if ancorsArray[secondIndex].fillColor == SKColor.red  {
                            ancorsArray[secondIndex].fillColor = color
                         continue preMainLoop
                         } else if ancorsArray[secondIndex].fillColor == SKColor.green {
                         continue preMainLoop
                     }
                     firstCircleCells.append(secondIndex)
                    } else if color == SKColor.red {
                        if ancorsArray[secondIndex].fillColor == SKColor.green  {
                               ancorsArray[secondIndex].fillColor = color
                            continue preMainLoop
                            } else if ancorsArray[secondIndex].fillColor == SKColor.red {
                            continue preMainLoop
                        }
                    }
                 }
             }
         }
    }
    
    var indexCatcher = 0
    
    func paintWhiteToRed() {
        for n in 0..<ancorsArray.count {
            let constant = ancorsArray[n].fillColor
            if (constant != .red) && (constant != .green) && (constant != blackConst) {
                ancorsArray[n].fillColor = SKColor.red
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            let keyWord: String = nodesArray.first?.name ?? ""
            
            if let helpNum = Int(keyWord) {
               // if helpNum >= 0 && helpNum < index {
                    if ancorsArray[helpNum].fillColor == SKColor.red {
                        paintStrokesBlue()
                        strokeColoring(index: helpNum)
                        indexCatcher = helpNum
                    } else if ancorsArray[helpNum].strokeColor == SKColor.red {
                        ancorsArray[helpNum].fillColor = SKColor.red
                        paintEnemy(externalIndex: helpNum, color: .red)
                        paintStrokesBlue()
                        Nemesis.arrayWithAncors = ancorsArray
                        if let a = Nemesis.analyse() {
                            ancorsArray[a[0]].fillColor = SKColor.green
                            paintEnemy(externalIndex: a[0], color: .green)
                            if a[1] != -1 {
                                ancorsArray[a[1]].fillColor = SKColor.white
                            }
                        } else {
                            paintWhiteToRed()
                        }
                        
                    } else if ancorsArray[helpNum].strokeColor == SKColor.yellow {
                        ancorsArray[helpNum].fillColor = SKColor.red
                        paintEnemy(externalIndex: helpNum, color: .red)
                        ancorsArray[indexCatcher].fillColor = SKColor.white
                        paintStrokesBlue()
                        Nemesis.arrayWithAncors = ancorsArray
                        if let a = Nemesis.analyse() {
                            ancorsArray[a[0]].fillColor = SKColor.green
                            paintEnemy(externalIndex: a[0], color: .green)
                            if a[1] != -1 {
                                ancorsArray[a[1]].fillColor = SKColor.white
                            }
                        } else {
                            paintWhiteToRed()
                        }
                        
                        indexCatcher = 0
                    }
                //  }
            }
        }
    }
    
    //override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
   // }
}
