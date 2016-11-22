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
    
    init(imageNamed: String, radius: Float, strenght: Float, poaition: CGPoint) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        let size = CGSize(width: texture.size().width/2, height: texture.size().height/2)
        let spriteComponent = SpriteComponent(texture: texture,
                                              size: size,
                                              nodePosition: poaition,
                                              typeOfBody: .Circle,
                                              name: "Planet")
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
