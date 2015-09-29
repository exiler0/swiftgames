//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by Andrew Phommathep on 9/23/15.
//  Copyright (c) 2015 Apress. All rights reserved.
//

import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let backgroundNode : SKSpriteNode?
    let foregroundNode : SKSpriteNode?
    var playerNode : SKSpriteNode?
    
    var impulseCount = 4
    
    let CollisionCategoryPlayer      : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(size: CGSize) {
        super.init(size: size)
    
        physicsWorld.contactDelegate = self
    
        physicsWorld.gravity = CGVectorMake(0.0, -2.0);
    
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
        userInteractionEnabled = true
        
        // adding the background
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode!)
    
        foregroundNode = SKSpriteNode()
        addChild(foregroundNode!)
    
        // add the player
        playerNode = SKSpriteNode(imageNamed: "Player")
        
        playerNode!.physicsBody =
            SKPhysicsBody(circleOfRadius: playerNode!.size.width / 2)
        playerNode!.physicsBody!.dynamic = false
        
        playerNode!.position = CGPoint(x: self.size.width / 2.0, y: 180.0)
        playerNode!.physicsBody!.linearDamping = 1.0
        playerNode!.physicsBody!.allowsRotation = false
        playerNode!.physicsBody!.categoryBitMask = CollisionCategoryPlayer
        playerNode!.physicsBody!.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode!.physicsBody!.collisionBitMask = 0
        foregroundNode!.addChild(playerNode!)
        
        var orbNodePosition = CGPointMake(playerNode!.position.x,
            playerNode!.position.y + 100)
        for i in 0...19 {
            var orbNode = SKSpriteNode(imageNamed: "PowerUp")
            orbNodePosition.y += 140
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody!.dynamic = false
            orbNode.physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody!.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            foregroundNode!.addChild(orbNode)
        }
        
        orbNodePosition = CGPointMake(playerNode!.position.x + 50, orbNodePosition.y)
        for i in 0...19 {
            var orbNode = SKSpriteNode(imageNamed: "PowerUp")
            orbNodePosition.y += 140
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody!.dynamic = false
            orbNode.physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody!.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            foregroundNode!.addChild(orbNode)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            if !playerNode!.physicsBody!.dynamic {
                playerNode!.physicsBody!.dynamic = true
            }
            
            if impulseCount > 0 {
                playerNode!.physicsBody!.applyImpulse(CGVectorMake(0.0, 40.0))
                impulseCount--
            }
    }

    func didBeginContact(contact: SKPhysicsContact!) {
        var nodeB = contact!.bodyB!.node!

        if nodeB.name == "POWER_UP_ORB"  {
            impulseCount++
            nodeB.removeFromParent()
        }
    }
}

