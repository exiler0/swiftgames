//
//  Orb.swift
//  SuperSpaceMan
//
//  Created by Andrew Phommathep on 10/11/15.
//  Copyright (c) 2015 Apress. All rights reserved.
//

import Foundation
import SpriteKit

class Orb: SKSpriteNode {
    
    override init() {
    
        let texture = SKTexture(imageNamed: "PowerUp")
        super.init(texture: texture,
            color: UIColor.clearColor(),
            size: texture.size())
    
        physicsBody =
            SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
        physicsBody!.collisionBitMask = 0
        name = "POWER_UP_ORB"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}