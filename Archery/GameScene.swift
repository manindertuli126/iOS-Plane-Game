//
//  GameScene.swift
//  Archery
//
//  Created by Maninder Singh on 2020-02-07.
//  Copyright © 2020 Macbook. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

        let player = SKSpriteNode(imageNamed: "player")

        override func didMove(to view: SKView) {
          // 2
          backgroundColor = SKColor.white
            player.position = CGPoint(x: size.width * 0.08, y: size.height * 0.5)
            // 4
            addChild(player)
            if let view = self.view {
                view.isMultipleTouchEnabled = true}
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
      let touchLocation = touch.location(in: self)
        if touchLocation.x <= 130 {
            touchLocation.y < (self.size.height/2) ? player.run(SKAction.moveTo(y:touchLocation.y, duration: 0.1)) : player.run(SKAction.moveTo(y: touchLocation.y, duration:0.1))
        }
        
    }
}
