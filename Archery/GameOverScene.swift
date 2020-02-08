//
//  GameOverScene.swift
//  Archery
//
//  Created by Maninder Singh on 2020-02-07.
//  Copyright © 2020 Macbook. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
  init(size: CGSize, won:Bool) {
    super.init(size: size)
    
    // 1
    backgroundColor = SKColor.white
    
    // 2
    let message = won ? "You Won!" : "You Lose :["
    
    // 3
    let label = SKLabelNode(fontNamed: "Chalkduster")
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.black
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)
    
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
              if node.name == "monster" {
                  GameScene.score = 0;
                  let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                  let scene = GameScene(size: size)
                  self.view?.presentScene(scene, transition:reveal)
               }
            if node.name == "player" {
               GameScene.score = 1;
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
