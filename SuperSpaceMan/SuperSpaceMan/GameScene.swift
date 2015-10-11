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
    let backgroundStarsNode  : SKSpriteNode?
    let backgroundPlanetNode : SKSpriteNode?
    let foregroundNode : SKSpriteNode?
    var playerNode : SKSpriteNode?
    
    var impulseCount = 4
    
    let coreMotionManager = CMMotionManager()
    var xAxisAcceleration : CGFloat = 0.0
        
    let engineExhaust : SKEmitterNode?
    var exhaustTimer : NSTimer?

    var score = 0
    let scoreTextNode = SKLabelNode(fontNamed: "Copperplate")
    
    let impulseTextNode = SKLabelNode(fontNamed: "Copperplate")
    
    let startGameTextNode = SKLabelNode(fontNamed: "Copperplate")
    
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
    
        backgroundStarsNode = SKSpriteNode(imageNamed: "Stars")
        backgroundStarsNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundStarsNode!.position = CGPoint(x: 160.0, y: 0.0)
        addChild(backgroundStarsNode!)
        
        backgroundPlanetNode = SKSpriteNode(imageNamed: "PlanetStart")
        backgroundPlanetNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundPlanetNode!.position = CGPoint(x: 160.0, y: 0.0)
        addChild(backgroundPlanetNode!)

        foregroundNode = SKSpriteNode()
        addChild(foregroundNode!)
    
        playerNode = SpaceMan()
        playerNode!.position = CGPoint(x: 160.0, y: 220.0)
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
        
        addBlackHolesToForeground()
        addOrbsToForeground()
    
        let engineExhaustPath =
            NSBundle.mainBundle().pathForResource("EngineExhaust", ofType: "sks")
        engineExhaust =
            NSKeyedUnarchiver.unarchiveObjectWithFile(engineExhaustPath!) as? SKEmitterNode
        engineExhaust!.position =
            CGPointMake(0.0, -(playerNode!.size.height / 2))
        
        playerNode!.addChild(engineExhaust!)
        engineExhaust!.hidden = true;

        scoreTextNode.text = "SCORE : \(score)"
        scoreTextNode.fontSize = 20
        scoreTextNode.fontColor = SKColor.whiteColor()
        scoreTextNode.position = CGPointMake(size.width - 10, size.height - 20)
        scoreTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        addChild(scoreTextNode)
    
        impulseTextNode.text = "IMPULSES : \(impulseCount)"
        impulseTextNode.fontSize = 20
        impulseTextNode.fontColor = SKColor.whiteColor()
        impulseTextNode.position = CGPointMake(10.0, size.height - 20)
        impulseTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        addChild(impulseTextNode)

        let orbPopAction = SKAction.playSoundFileNamed("orb_pop.wav",
            waitForCompletion: false)
        
        startGameTextNode.text = "TAP ANYWHERE TO START!"
        startGameTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        startGameTextNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        startGameTextNode.fontSize = 20
        startGameTextNode.fontColor = SKColor.whiteColor()
        startGameTextNode.position =
            CGPoint(x: scene!.size.width / 2, y: scene!.size.height / 2)
        addChild(startGameTextNode)
    }
    
    func addOrbsToForeground() {
        var orbNodePosition = CGPoint(x: playerNode!.position.x, y: playerNode!.position.y + 100)
        var orbXShift : CGFloat = -1.0
    
        for i in 0...49 {
            
            // new code to use an orb
            var orbNode = Orb()
            
            if orbNodePosition.x - (orbNode.size.width * 2) <= 0 {
                orbXShift = 1.0
            }
            
            if orbNodePosition.x + orbNode.size.width >= self.size.width {
                orbXShift = -1.0
            }
            
            orbNodePosition.x += 40.0 * orbXShift
            orbNodePosition.y += 120
            orbNode.position = orbNodePosition
            self.foregroundNode!.addChild(orbNode)
        }
    }
    
    
    func addBlackHolesToForeground() {
            
        var moveLeftAction = SKAction.moveToX(0.0, duration: 2.0)
        var moveRightAction = SKAction.moveToX(self.size.width, duration: 2.0)
        var actionSequence = SKAction.sequence([moveLeftAction, moveRightAction])
        var moveAction = SKAction.repeatActionForever(actionSequence)
            
        for i in 1...10 {
            
            // new black hole usage code
            var blackHoleNode = BlackHole()
            
            blackHoleNode.position = CGPointMake(self.size.width - 80.0, 600.0 * CGFloat(i))
            blackHoleNode.runAction(moveAction)
            
            foregroundNode!.addChild(blackHoleNode)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if !playerNode!.physicsBody!.dynamic {

            startGameTextNode.removeFromParent()
                
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
            impulseTextNode.text = "IMPULSES : \(impulseCount)"
                
            engineExhaust!.hidden = false
 
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self,
                    selector: "hideEngineExaust:", userInfo: nil, repeats: false)
        }
    }


    func didBeginContact(contact: SKPhysicsContact!) {
        var nodeB = contact!.bodyB!.node!

        if nodeB.name == "POWER_UP_ORB"  {
            impulseTextNode.text = "IMPULSES : \(impulseCount)"
                
            impulseCount++
            impulseTextNode.text = "IMPULSES : \(impulseCount)"

            score++
            scoreTextNode.text = "SCORE : \(score)"
            
            nodeB.removeFromParent()
        } else {
            playerNode!.physicsBody!.contactTestBitMask = 0
            impulseCount = 0

            var colorizeAction = SKAction.colorizeWithColor(UIColor.redColor(),
                colorBlendFactor: 1.0, duration: 1)
            playerNode!.runAction(colorizeAction)
    
        }
    }

    override func update(currentTime: NSTimeInterval) {
                
        if playerNode != nil {
                
            if playerNode!.position.y >= 180.0 &&
               playerNode!.position.y < 6400.0 {
                    
                backgroundNode!.position =
                    CGPointMake(backgroundNode!.position.x,
                    -((playerNode!.position.y - 180.0)/8))
                        
                backgroundStarsNode!.position = CGPointMake(backgroundStarsNode!.position.x, -((playerNode!.position.y - 180.0)/6))
                
                backgroundPlanetNode!.position =
                    CGPointMake(backgroundPlanetNode!.position.x,
                    -((playerNode!.position.y - 180.0)/8));
                        
                foregroundNode!.position =
                    CGPointMake(foregroundNode!.position.x,
                    -(playerNode!.position.y - 180.0))
                        
            } else if playerNode!.position.y > 7000.0 {
        
                gameOverWithResult(true)
                        
            } else if playerNode!.position.y < 0.0 {
        
                gameOverWithResult(false)
            }
        }
    }

    override func didSimulatePhysics() {
                        
        if playerNode != nil {
                
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
    }

    deinit {
        self.coreMotionManager.stopAccelerometerUpdates()
    }

    func hideEngineExaust(timer:NSTimer!) {
        if !engineExhaust!.hidden {
            engineExhaust!.hidden = true
        }
    }

    func gameOverWithResult(gameResult: Bool) {
    
        playerNode!.removeFromParent()
        playerNode = nil
    
        let transition = SKTransition.crossFadeWithDuration(2.0)
        let menuScene = MenuScene(size: size,
            gameResult: gameResult,
            score: score)
        view?.presentScene(menuScene, transition: transition)
    }
}

