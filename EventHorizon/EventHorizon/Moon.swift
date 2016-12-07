//
//  Moon.swift
//  EventHorizon
//
//  Created by Matheus Lourenco Fernandes Soares on 06/12/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//


import SpriteKit
import GameplayKit

class Moon: GKEntity {
    
    init(imageNamed: String, radius: CGFloat, position: CGPoint) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        let size = CGSize(width: radius*2, height: radius*2)
        let spriteComponent = SpriteComponent(texture: texture,
                                              size: size,
                                              nodePosition: position,
                                              typeOfBody: .Circle,
                                              name: "Moon")
        spriteComponent.physicsBody?.isDynamic = false
        addComponent(spriteComponent)
        
        let collisionComponent = CollisionComponent(parentNode: spriteComponent.node,
                                                    bodyMass: 1)
        addComponent(collisionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
