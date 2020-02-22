//
//  GameOverScene.swift
//  Archery
//
//  Created by Maninder Singh on 2020-02-07.
//  Copyright © 2020 Macbook. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let userDefault = UserDefaults.standard
    let scorelabel = SKLabelNode(fontNamed: "Arial-Bold")
    let highestscorelabel = SKLabelNode(fontNamed: "Arial-Bold")
    let player1scorelabel = SKLabelNode(fontNamed: "Arial-Bold")
    let player2scorelabel = SKLabelNode(fontNamed: "Arial-Bold")
    var highestScore = 0
    let fontcolor = SKColor.white
    
    init(size: CGSize, won:Bool, score:Int) {
    super.init(size: size)

    let message = won ? "You Won .." : "Game Over .. You Lose"
    
    let label = SKLabelNode(fontNamed: "Arial-Bold")
    let screenSize = UIScreen.main.bounds
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
    label.text = message
    label.fontSize = 40
        label.zPosition = 100
    label.fontColor = fontcolor
    label.position = CGPoint(x: size.width/2, y: screenHeight/1.3)
    
        backgroundColor = SKColor.darkGray
        
        let backgroundMusic = SKAudioNode(fileNamed: "GameBGSound.m4a")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    
    let button1 = SKSpriteNode(imageNamed: "HomeBtn")
    button1.position = CGPoint(x: self.frame.size.width/2, y: screenHeight/2)
        button1.zPosition = 100
    button1.name = "HomeBtn"
    
    let button2 = SKSpriteNode(imageNamed: "PlayAgainBtn")
    button2.position = CGPoint(x: self.frame.size.width/1.5, y: screenHeight/2)
         button2.zPosition = 100
    button2.name = "PlayAgainBtn"
        
    let button3 = SKSpriteNode(imageNamed: "ResetBtn")
    button3.position = CGPoint(x: self.frame.size.width/3, y: screenHeight/2)
         button3.zPosition = 100
    button3.name = "ResetBtn"
        
        var getOlderScoreA = userDefault.string(forKey: "PlayerAscore")!
        var getOlderScoreB = userDefault.string(forKey: "PlayerBscore")!
        if(userDefault.string(forKey: "Player")! == "A"){
            if(Int(getOlderScoreA)! <= score){
                userDefault.set(score, forKey: "PlayerAscore")
            }
        }else{
            if(Int(getOlderScoreB)! <= score){
                userDefault.set(score, forKey: "PlayerBscore")
            }
        }
        
        getOlderScoreA = userDefault.string(forKey: "PlayerAscore")!
        getOlderScoreB = userDefault.string(forKey: "PlayerBscore")!
        
        if(Int(getOlderScoreA)! > Int(getOlderScoreB)!){
            if(Int(getOlderScoreA)! >= score){
                highestScore = Int(getOlderScoreA)!
            }
        }else if(Int(getOlderScoreB)! >= score){
            highestScore = Int(getOlderScoreB)!
        }
        
        scorelabel.text = "Player\(userDefault.string(forKey: "Player")!) Current Game Score: \(score)"
        scorelabel.fontColor = fontcolor
        scorelabel.fontSize = 25
        scorelabel.zPosition = 100
        scorelabel.position = CGPoint(x: size.width/2, y: screenHeight/1.5)
        
        highestscorelabel.text = "Highest Score: \(highestScore)"
        highestscorelabel.fontColor = fontcolor
        highestscorelabel.fontSize = 25
        highestscorelabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 8)
        highestscorelabel.zPosition = 100
        
        player1scorelabel.text = "Player A Score: \(getOlderScoreA)"
        player1scorelabel.fontColor = fontcolor
        player1scorelabel.fontSize = 25
        player1scorelabel.position = CGPoint(x: screenWidth / 5, y: screenHeight / 4)
        player1scorelabel.zPosition = 100
        
        player2scorelabel.text = "Player B Score: \(getOlderScoreB)"
        player2scorelabel.fontColor = fontcolor
        player2scorelabel.fontSize = 25
        player2scorelabel.zPosition = 100
        player2scorelabel.position = CGPoint(x: screenWidth / 1.4, y: screenHeight / 4)
        
        if(score == 0){
            self.addChild(button1)
            addChild(player2scorelabel)
            addChild(player1scorelabel)
            addChild(highestscorelabel)
        }else{
            addChild(label)
            self.addChild(button3)
            self.addChild(button2)
            self.addChild(button1)
            addChild(scorelabel)
            addChild(player2scorelabel)
            addChild(player1scorelabel)
            addChild(highestscorelabel)
        }
    
   }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if let touch = touches.first {
          let location = touch.location(in: self)
          let nodesarray = nodes(at: location)
           
          for node in nodesarray {
              if node.name == "HomeBtn" {
                  GameScene.StartGame = 0;
                  let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                  let scene = GameScene(size: size)
                  self.view?.presentScene(scene, transition:reveal)
               }
            if node.name == "PlayAgainBtn" {
               GameScene.StartGame = 1;
               let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
               self.view?.presentScene(scene, transition:reveal)
            }
            if node.name == "ResetBtn" {
                userDefault.set(0, forKey: "PlayerAscore")
                userDefault.set(0, forKey: "PlayerBscore")
                GameScene.StartGame = 0;
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
          }
      }
  }
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
