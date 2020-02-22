//
//  StartGameScene.swift
//  Archery
//
//  Created by Maninder Singh on 2020-02-07.
//  Copyright © 2020 Macbook. All rights reserved.
//


import SpriteKit

class StartGameScene: SKScene {
    
    let userDefault = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "homebackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        let backgroundMusic = SKAudioNode(fileNamed: "GameBGSound.m4a")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        let homeBG = SKSpriteNode(imageNamed: "HomeBG")
        homeBG.position = CGPoint(x: self.frame.size.width/3, y: self.frame.size.height/1.5)
        homeBG.zPosition = 100
               addChild(homeBG)
        
        let button1 = SKSpriteNode(imageNamed: "homeplayerA")
        button1.zPosition = 100
        button1.position = CGPoint(x: self.frame.size.width/6, y: self.frame.size.height/2.6)
        button1.name = "PlayerA"
        
        let button2 = SKSpriteNode(imageNamed: "homeplayerB")
        button2.zPosition = 100
        button2.position = CGPoint(x: self.frame.size.width/6, y: self.frame.size.height/6)
        button2.name = "PlayerB"
            
        self.addChild(button1)
        self.addChild(button2)
     
        let scorebtn = SKSpriteNode(imageNamed: "ScoreMenu")
        scorebtn.zPosition = 100
        scorebtn.position = CGPoint(x: self.frame.size.width/2.5, y: self.frame.size.height/6)
        scorebtn.name = "Score"
        self.addChild(scorebtn)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
             
            for node in nodesarray {
                switch node.name{
                case "PlayerA":
                    userDefault.set("A", forKey: "Player")
                    GameScene.StartGame = 1;
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene = GameScene(size: size)
                    self.view?.presentScene(scene, transition:reveal)
                break
                case "PlayerB":
                    userDefault.set("B", forKey: "Player")
                    GameScene.StartGame = 1;
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene = GameScene(size: size)
                    self.view?.presentScene(scene, transition:reveal)
                break
                    case "Score":
                        userDefault.set("B", forKey: "Player")
                        GameScene.StartGame = 1;
                        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                        let gameOverScene = GameOverScene(size: self.size, won: true, score: 0)
                            view?.presentScene(gameOverScene, transition: reveal)
                    break
                default:
                    break
                }
            }
        }
    }
}
