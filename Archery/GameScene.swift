//
//  GameScene.swift
//  Archery
//
//  Created by Maninder Singh on 2020-02-07.
//  Copyright © 2020 Macbook. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let monster   : UInt32 = 0b1       // 1
  static let projectile: UInt32 = 0b10      // 2
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

class GameScene: SKScene {
        var monstersDestroyed = 0
        var actualDuration = CGFloat(2.0)
        var MissHit = 0
        var GameLevel = 1
        static var StartGame = 0
        var totalScore = 0
        var missileFlame : SKSpriteNode!
        let userDefault = UserDefaults.standard
        var player : SKSpriteNode!
        var backgroundimage : SKSpriteNode!
        let liveslabel = SKLabelNode(fontNamed: "Chalkduster")
        let levellabel = SKLabelNode(fontNamed: "Chalkduster")
        let playerlabel = SKLabelNode(fontNamed: "Chalkduster")

        override func didMove(to view: SKView) {
        
            imageBG(BG: "background\(self.GameLevel)")
            
            if(GameScene.StartGame == 0){
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let startGameScene = StartGameScene(size: self.size)
                self.view?.presentScene(startGameScene, transition: reveal)
            }
            
            let playername = userDefault.string(forKey: "Player")!
            player = SKSpriteNode(imageNamed: "Player\(playername)")
            player?.zPosition = 100
            player!.position = CGPoint(x: size.width * 0.08, y: size.height * 0.5)
            // 4
            addChild(player!)
            
            if let view = self.view {
                view.isMultipleTouchEnabled = true}
            
            //Monster
            run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 2.0)
                ])
            ))
            
            physicsWorld.gravity = .zero
            physicsWorld.contactDelegate = self
        
            
            liveslabel.text = "Lives Left: 3"
            liveslabel.fontColor = SKColor.white
            liveslabel.fontSize = 15
            liveslabel.zPosition = 100
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            liveslabel.position = CGPoint(x: screenWidth / 10, y: screenHeight / 15)
            addChild(liveslabel)
            
            levellabel.zPosition = 100
            levellabel.text = "Level: 1"
            levellabel.fontColor = SKColor.white
            levellabel.fontSize = 15
            levellabel.position = CGPoint(x: screenWidth / 10, y: screenHeight / 8)
            addChild(levellabel)
            
            
            playerlabel.zPosition = 100
            playerlabel.text = "Player: \(playername)"
            playerlabel.fontColor = SKColor.white
            playerlabel.fontSize = 15
            playerlabel.position = CGPoint(x: screenWidth / 10, y: screenHeight / 5.5)
            addChild(playerlabel)
    }
    
    func imageBG(BG : String){
        backgroundimage = SKSpriteNode(imageNamed: "\(BG)")
        backgroundimage.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(backgroundimage)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
      let touchLocation = touch.location(in: self)
        if touchLocation.x <= 130 {
            touchLocation.y < (self.size.height/2) ? player!.run(SKAction.moveTo(y:touchLocation.y, duration: 0.1)) : player!.run(SKAction.moveTo(y: touchLocation.y, duration:0.1))
        }else{
            let projectile = SKSpriteNode(imageNamed: "Missile")
            projectile.position = player!.position
            projectile.zPosition = 100
            let offset = touchLocation - projectile.position
            if offset.x < 0 { return }
            addChild(projectile)
            let direction = offset.normalized()
            let shootAmount = direction * 1000
            let realDest = shootAmount + projectile.position
            let actionMove = SKAction.move(to: realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            run(SKAction.playSoundFileNamed("MissleLaunch.m4a", waitForCompletion: false))
            
        }
        
    }
    
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }

    func addMonster() {
        let monster = SKSpriteNode(imageNamed: "Enemy")
        monster.zPosition = 100
        let actualX = random(min: 130, max: size.width - monster.size.width/2)
        monster.position = CGPoint(x:actualX , y: size.height + monster.size.height/2)
        addChild(monster)
        let actionMove = SKAction.move(to: CGPoint(x:actualX , y: monster.size.width/2),duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
        guard let `self` = self else { return }
            if(self.MissHit > 2){
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, won: false, score: self.totalScore)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }else{
                self.MissHit += 1
                self.liveslabel.text = "Lives Left: \(3-self.MissHit)"
            }
        }
        
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        monster.physicsBody?.isDynamic = true // 2
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
    }
    
    func addOne(projectile: SKSpriteNode) {
        missileFlame = SKSpriteNode(imageNamed: "Flame")
       missileFlame.position = projectile.position
        missileFlame.zPosition = 1
        self.addChild(missileFlame)
    }
    
    func removeOne() {

        missileFlame.removeFromParent()

    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
      projectile.removeFromParent()
      monster.removeFromParent()

        run(SKAction.playSoundFileNamed("Explosion.mp3", waitForCompletion: false))
        
        let myFunction = SKAction.run({()in self.addOne(projectile: projectile)})
        let wait = SKAction.wait(forDuration: 0.5)
        let remove = SKAction.run({() in self.removeOne()})
        self.run(SKAction.sequence([myFunction, wait, remove]))
        
        totalScore += 1
        monstersDestroyed += 1
        if monstersDestroyed > 2 {
            actualDuration -= 0.5
            monstersDestroyed = 0
            GameLevel += 1
            imageBG(BG: "background\(self.GameLevel)")
            self.levellabel.text = "Level: \(GameLevel)"
            if(actualDuration == CGFloat(0.0)){
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, won: true, score: totalScore)
                    view?.presentScene(gameOverScene, transition: reveal)
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
        if let monster = firstBody.node as? SKSpriteNode,
          let projectile = secondBody.node as? SKSpriteNode {
          projectileDidCollideWithMonster(projectile: projectile, monster: monster)
        }
      }
    }
}
