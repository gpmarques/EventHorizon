//
//  Spaceship.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class Spaceship: GKEntity {
    
    init(imageNamed: String) {
        super.init()
        let texture = SKTexture(imageNamed: imageNamed)
        let spriteComponent = SpriteComponent(texture: texture,
                                              size: CGSize(width: texture.size().width/10,
                                                           height: texture.size().height/10))
        spriteComponent.gravityFieldCategory = GravityFieldCategory.Gravity
        addComponent(spriteComponent)
        let movementComponent = MovementComponent(speed: 200,
                                                  maxSpeed: 500,
                                                  acceleration: 15)
        addComponent(movementComponent)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
