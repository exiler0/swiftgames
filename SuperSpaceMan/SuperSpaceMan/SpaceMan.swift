//
//  SpaceMan.swift
//  SuperSpaceMan
//
//  Created by Andrew Phommathep on 10/11/15.
//  Copyright (c) 2015 Apress. All rights reserved.
//

import Foundation
import SpriteKit

class SpaceMan: SKSpriteNode {
    
    override init() {
    
        let texture = SKTexture(imageNamed: "Player")
        super.init(texture: texture,
            color: UIColor.clearColor(),
            size: texture.size())
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody!.dynamic = false
        self.physicsBody!.linearDamping = 1.0
        self.physicsBody!.allowsRotation = false
    
        self.physicsBody!.categoryBitMask = CollisionCategoryPlayer
        self.physicsBody!.contactTestBitMask =
            CollisionCategoryPowerUpOrbs | CollisionCategoryBlackHoles
        self.physicsBody!.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
