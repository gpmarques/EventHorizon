//
//  BlackHole.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class BlackHole: GKEntity {
    
<<<<<<< Updated upstream
    // TO-DO
    override init() {
=======
    init(imageNamed: String, ship: SKSpriteNode) {
>>>>>>> Stashed changes
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        let spriteComponent = SpriteComponent(texture: texture, size: texture.size())
        spriteComponent.physicsBody?.mass = 100000000000
        addComponent(spriteComponent)
        
        let orbitComponent = OrbitComponent(shipNode: ship,
                                            shipSpeed: 120,
                                            parentNode: spriteComponent.node,
                                            blackHoleRadius: 10,
                                            shipAngle: 180)
        addComponent(orbitComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
