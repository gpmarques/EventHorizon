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
    
    init(imageNamed: String, radius: CGFloat, strenght: Float, position: CGPoint, orbitingNodes: [SKSpriteNode], entityManager: EntityManager, name: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        let size = CGSize(width: radius*2, height: radius*2)
        let spriteComponent = SpriteComponent(texture: texture,
                                              size: size,
                                              nodePosition: position,
                                              typeOfBody: .Circle,
                                              name: name)
        addComponent(spriteComponent)
        
        let collisionComponent = CollisionComponent(parentNode: spriteComponent.node,
                                                    bodyMass: 10000000)
        addComponent(collisionComponent)
        
        let gravityComponent = GravityComponent(parentNode: spriteComponent.node,
                                                radius: Float(radius)*4,
                                                strenght: strenght)
        addComponent(gravityComponent)
        
        let sizeOrbit = CGSize(width: size.width+75, height: size.height+75)
        
        let orbitComponent = OrbitComponent(orbitSpeed: 5,
                                            parentNode: spriteComponent.node,
                                            blackHoleOrbitSize: sizeOrbit.width,
                                            speed: 0,
                                            entityManager: entityManager,
                                            ship: nil,
                                            orbitingNodes: orbitingNodes)
        addComponent(orbitComponent)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
