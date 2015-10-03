//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by Andrew Phommathep on 9/23/15.
//  Copyright (c) 2015 Apress. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let backgroundNode : SKSpriteNode?
    let foregroundNode : SKSpriteNode?
    var playerNode : SKSpriteNode?
    
    var impulseCount = 4
    
    let coreMotionManager = CMMotionManager()
    var xAxisAcceleration : CGFloat = 0.0
    
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
    
        self.coreMotionManager.accelerometerUpdateInterval = 0.3
        self.coreMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler: {
            (data: CMAccelerometerData!, error: NSError!) in
                if let constVar = error {
                    println("There was an error")
                }
                else {
                    self.xAxisAcceleration = CGFloat(data!.acceleration.x)
                }
        })
    
        addOrbsToForeground()
    }
    
    func addOrbsToForeground() {
            var orbNodePosition = CGPoint(x: playerNode!.position.x, y: playerNode!.position.y + 100)
            var orbXShift : CGFloat = -1.0
        
            for _ in 1...50 {
                var orbNode = SKSpriteNode(imageNamed: "PowerUp")

                if orbNodePosition.x - (orbNode.size.width * 2) <= 0 {
            orbXShift = 1.0
                }
                
                if orbNodePosition.x + orbNode.size.width >= self.size.width {
                orbXShift = -1.0
                }
                
                orbNodePosition.x += 40.0 * orbXShift
                orbNodePosition.y += 120
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

            self.coreMotionManager.accelerometerUpdateInterval = 0.3
            self.coreMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(),
            withHandler: {
                (data: CMAccelerometerData!, error: NSError!) in

                if let constVar = error {
                    println("There was an error")
                }
                else {
                    self.xAxisAcceleration = CGFloat(data!.acceleration.x)
                }
            })
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

    override func update(currentTime: NSTimeInterval) {
        backgroundNode!.position =
            CGPointMake(backgroundNode!.position.x,
            -((playerNode!.position.y - 180.0)/8))

        foregroundNode!.position =
            CGPointMake(foregroundNode!.position.x,
            -(playerNode!.position.y - 180.0))
    }

    override func didSimulatePhysics() {
        self.playerNode!.physicsBody!.velocity =
            CGVectorMake(self.xAxisAcceleration * 380.0,
            self.playerNode!.physicsBody!.velocity.dy)

        if playerNode!.position.x < -(playerNode!.size.width / 2) {
            playerNode!.position =
            CGPointMake(size.width - playerNode!.size.width / 2,
            playerNode!.position.y);
        }
        else if self.playerNode!.position.x > self.size.width {
            playerNode!.position = CGPointMake(playerNode!.size.width / 2,
            playerNode!.position.y);
        }
    }

    deinit {
        self.coreMotionManager.stopAccelerometerUpdates()
    }

}

