//
//  GameScene.swift
//  SKLabelNodes_experiment
//
//  Created by Andrew Phommathep on 10/6/15.
//  Copyright (c) 2015 Apress. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let simpleLabel = SKLabelNode(fontNamed: "Copperplate")
        simpleLabel.text = "Hello, Sprite Kit!"
        simpleLabel.fontSize = 40
        simpleLabel.position =
            CGPoint(x: size.width / 2.0,
                    y: frame.height - simpleLabel.frame.height)
        
        simpleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        simpleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        addChild(simpleLabel)
    }
    
//    override func didMoveToView(view: SKView) {
//        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
//    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
