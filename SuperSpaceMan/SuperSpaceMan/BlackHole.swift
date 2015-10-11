//
//  BlackHole.swift
//  SuperSpaceMan
//
//  Created by Andrew Phommathep on 10/11/15.
//  Copyright (c) 2015 Apress. All rights reserved.
//

import Foundation
import SpriteKit

class BlackHole: SKSpriteNode {
    
    override init() {
    
        let textureAtlas = SKTextureAtlas(named: "sprites.atlas")
        
        var frame0 = textureAtlas.textureNamed("BlackHole0")
        var frame1 = textureAtlas.textureNamed("BlackHole1")
        var frame2 = textureAtlas.textureNamed("BlackHole2")
        var frame3 = textureAtlas.textureNamed("BlackHole3")
        var frame4 = textureAtlas.textureNamed("BlackHole4")
        
        var blackHoleTextures = [frame0, frame1, frame2, frame3, frame4]
        var animateAction =
            SKAction.animateWithTextures(blackHoleTextures, timePerFrame: 0.2)
        var rotateAction = SKAction.repeatActionForever(animateAction)
            super.init(texture: frame0,
            color: UIColor.clearColor(),
            size: frame0.size())
    
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = CollisionCategoryBlackHoles
        physicsBody!.collisionBitMask = 0
        name = "BLACK_HOLE"
    
        runAction(rotateAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
