//
//  MainMenu.swift
//  HexagonGame
//
//  Created by Дмитрий Докукин on 14/01/2020.
//  Copyright © 2020 Дмитрий Докукин. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenu: SKScene {
    var newGameBttn: SKSpriteNode!
    override func didMove(to view: SKView) {
        newGameBttn = (self.childNode(withName: "NewGameBttn") as! SKSpriteNode)
        newGameBttn.texture = SKTexture(imageNamed: "NewGameBttn")
        self.backgroundColor = SKColor.gray
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "NewGameBttn" {
                newGameBttn.texture = SKTexture(imageNamed: "PressedBttn")
                
                let transition = SKTransition.flipVertical(withDuration: 1)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
