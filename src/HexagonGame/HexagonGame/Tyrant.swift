//
//  Tyrant.swift
//  HexagonGame
//
//  Created by Дмитрий Докукин on 14/01/2020.
//  Copyright © 2020 Дмитрий Докукин. All rights reserved.
//
import SpriteKit

class Tyrant {
    var arrayWithAncors: [SKShapeNode] = []
    var additionalDictionary: [Int: (i: Int, j: Int)] = [:]
    var secondDictionary: [[Int]: Int] = [:]
    var arrayWithBlackCells: [Int] = []
    var constantWhiteColor: SKColor = .white
   
    func findIndentToCells(circle num: Int) -> [[Int]] {
        var extraCells: [[Int]] = []
        func findIndentToExtraCells(circle num: Int) {
            extraCells = []
            var firstNum = 1
            for i in (-(num))..<(0) {
                for j in firstNum...num { extraCells.append([i, j]) }
                firstNum += 1         }
            firstNum = 1
            for j in (-num)..<(0) {
                for i in firstNum...num { extraCells.append([i, j]) }
                firstNum += 1       }
        }
        findIndentToExtraCells(circle: num)
        var neighborCells: [[Int]] = []
        for i in -num...num {
            for j in -num...num {
                if i == 0 && j == 0 { continue }
                neighborCells.append([i, j]) }
        }
        for n in 0..<extraCells.count {
            for m in 0..<neighborCells.count {
                if neighborCells[m] == extraCells[n] {
                    neighborCells.remove(at: m)
                    break }                   }
        }
        return neighborCells
    }
    
    func findNeighborCellsOn(circle: Int, for index: Int) -> [Int]? {
        let i = additionalDictionary[index]!.i
        let j = additionalDictionary[index]!.j
        var mainArray: [Int] = []
        var Array1 = findIndentToCells(circle: circle)
        let array2 = findIndentToCells(circle: circle-1)
        for n in array2 {
            for m in 0..<Array1.count {
                if Array1[m] == n {
                    Array1.remove(at: m)
                    break
                }
            }
        }
        for n in Array1 {
            if let a = secondDictionary[[n[0] + i, n[1] + j]] {
                mainArray.append(a)
            }
        }
        print("mainArray: \(mainArray)")
        return mainArray
    }
   
    func getEmptyCells(circle: Int, for index: Int) -> [Int] {
              var emptyCells: [Int] = []
              let cellsArray: [Int] = findNeighborCellsOn(circle: 1, for: index)!
              for n in cellsArray {
                      if arrayWithAncors[n].fillColor == constantWhiteColor {
                      emptyCells.append(n)
                      }
                  }
              print("first emptycells: \(emptyCells)")
             if circle > 1 && emptyCells != [] {
                  var secondCircleOfEmptyCells: [Int] = []
                  for n in emptyCells {
                      secondCircleOfEmptyCells += getEmptyCells(circle: circle-1, for: n)
                  }
                  return secondCircleOfEmptyCells
              }
              print("emptyCells: \(emptyCells)")
              return emptyCells
          }
    
    func findCommonCells(index: Int, circle: Int, enemyIndex: Int, enemyCircle: Int) -> [Int] {
        var commonCells: [Int] = []
        let emptyCells = getEmptyCells(circle: circle, for: index)
        let enemyEmptyCells = getEmptyCells(circle: enemyCircle, for: enemyIndex)
        if emptyCells != [] && enemyEmptyCells != [] {
            for n in enemyEmptyCells {
                for m in emptyCells {
                    if m == n { commonCells.append(m) }
                }
            }
        }
        return commonCells
    }
    
    func getMyCells() -> [Int] {
        var arrayWithGreenCells: [Int] = []
        for n in 0..<arrayWithAncors.count {
            if arrayWithAncors[n].fillColor == SKColor.green { arrayWithGreenCells.append(n) }
        }
        return arrayWithGreenCells
    }
    
    func analyse() -> [Int]? {
        let arrayWithGreenCells: [Int] = getMyCells()
        if arrayWithGreenCells != [] {
            var topTarget: [[Int]: [Int]] = [:]
            var middleTarget: [[Int]: [Int]] = [:]
            //var lowTarget: [Int] = []
            mainLoop: for index in arrayWithGreenCells {
                var array: [Int] = findNeighborCellsOn(circle: 1, for: index)!
                for n in array {
                    if arrayWithAncors[n].fillColor == SKColor.red {
                        print("Top priority for index: \(index)")
                        
                        let aux = findCommonCells(index: index, circle: 1, enemyIndex: n, enemyCircle: 1)
                        if aux != [] { topTarget[[index, n]] = aux}
                        //lowTarget += findCommonCells(index: index, circle: 2, enemyIndex: n, enemyCircle: 1) ?? []
                        
                    }
                }
                
                array = []
                array = findNeighborCellsOn(circle: 2, for: index)!
                for n in array {
                    if arrayWithAncors[n].fillColor == SKColor.red {
                        print("Middle priority for index: \(index)")
                        let auxT = findCommonCells(index: index, circle: 1, enemyIndex: n, enemyCircle: 1)
                        if auxT != [] { topTarget[[index, n]] = auxT}
                        //print(topTarget)
                        let auxM = findCommonCells(index: index, circle: 2, enemyIndex: n, enemyCircle: 1)
                        if auxM != [] { middleTarget[[index, n]] = auxM }
                        
                    }
                }
                array = []
                array = findNeighborCellsOn(circle: 3, for: index)!
                for n in array {
                    if arrayWithAncors[n].fillColor == SKColor.red {
                        print("Low priority for index: \(index)")
                        let aux = findCommonCells(index: index, circle: 2, enemyIndex: n, enemyCircle: 1)
                        if aux != [] { middleTarget[[index, n]] = aux}
                        
                    }
                }
            }
            
             if topTarget != [:] {
                let array = Array(topTarget.keys)
                let random1 = Int(arc4random_uniform(UInt32(array.count)))
                let point = topTarget[array[random1]]!
                let random2 = Int(arc4random_uniform(UInt32(point.count)))
                topTarget = [:]
                middleTarget = [:]
                print(point[random2])
                return [point[random2], -1]
             } else if middleTarget != [:] {
                let array = Array(middleTarget.keys)
                let random1 = Int(arc4random_uniform(UInt32(array.count)))
                let point = middleTarget[array[random1]]!
                let random2 = Int(arc4random_uniform(UInt32(point.count)))
                middleTarget = [:]
                print([point[random2], array[random1][0]])
                return [point[random2], array[random1][0]]
             } else {
                for el in arrayWithGreenCells {
                    let array = getEmptyCells(circle: 1, for: el)
                    if array != [] {
                        let random = Int(arc4random_uniform(UInt32(array.count)))
                        return [array[random], -1]
                    }
                }
            }
        }
        return nil
    }
    
    
    func getWhite() {
        constantWhiteColor = arrayWithAncors[30].fillColor
    }
    
}
