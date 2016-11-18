//
//  Planet.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class Planet: GKEntity {
    
    init(imageNamed: String, radius: Float, strenght: Float) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        let spriteComponent = SpriteComponent(texture: texture, size: texture.size())
        spriteComponent.physicsBody?.mass = 1000000000
        addComponent(spriteComponent)
        
        let collisionComponent = CollisionComponent(parentNode: spriteComponent.node,
                                                        bodyMass: 10000000)
        addComponent(collisionComponent)
        
        let gravityComponent = GravityComponent(parentNode: spriteComponent.node,
                                                radius: radius,
                                                strenght: strenght)
        addComponent(gravityComponent)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
