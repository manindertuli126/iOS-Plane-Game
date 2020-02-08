//
//  StartGameScene.swift
//  Archery
//
//  Created by Maninder Singh on 2020-02-07.
//  Copyright © 2020 Macbook. All rights reserved.
//


import SpriteKit

class StartGameScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        let button1 = SKSpriteNode(imageNamed: "monster")
        button1.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        button1.name = "monster"
        
        let button2 = SKSpriteNode(imageNamed: "player")
        button2.position = CGPoint(x: self.frame.size.width/1.5, y: self.frame.size.height/2)
        button2.name = "player"
            
        self.addChild(button1)
        self.addChild(button2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
             
            for node in nodesarray {
                switch node.name{
                case "monster":
                    GameScene.score = 1;
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene = GameScene(size: size)
                    self.view?.presentScene(scene, transition:reveal)
                break
                case "player":
                    GameScene.score = 1;
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene = GameScene(size: size)
                    self.view?.presentScene(scene, transition:reveal)
                break
                default:
                    break
                }
            }
        }
    }
}
