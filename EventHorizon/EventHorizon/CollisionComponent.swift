//
//  CollisionComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 08/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit


struct CollisionCategory {
    static let None: UInt32 = 0x1 << 0
    static let Collision: UInt32 = 0x1 << 1
    static let CollisionTrajectory: UInt32 = 0x1 << 2
}

class CollisionComponent: GKComponent {
    
    init(parentNode: SKSpriteNode, bodyMass: CGFloat) {
        super.init()
        parentNode.physicsBody?.mass = bodyMass
        parentNode.physicsBody?.categoryBitMask = CollisionCategory.Collision
        parentNode.physicsBody?.collisionBitMask = CollisionCategory.Collision
        parentNode.physicsBody?.contactTestBitMask = CollisionCategory.Collision
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
