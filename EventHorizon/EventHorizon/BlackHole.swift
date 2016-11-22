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


    init(imageNamed: String, speedOutBlackHole: CGFloat) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        let spriteComponent = SpriteComponent(texture: texture,
                                              size: texture.size(),
                                              nodePosition: CGPoint(x: 400, y: 600),
                                              typeOfBody: TypeOfBody.Circle,
                                              name: "BlackHole")
        spriteComponent.physicsBody?.mass = 100000000000
        addComponent(spriteComponent)
        
        let size = CGSize(width: texture.size().width+100, height: texture.size().height+100)
        
        let orbitComponent = OrbitComponent(orbitSpeed: 50,
                                            parentNode: spriteComponent.node,
                                            blackHoleOrbitSize: size.width,
                                            speed: speedOutBlackHole)
        addComponent(orbitComponent)
        
        let collisionComponent = CollisionComponent(parentNode: spriteComponent.node,
                                                    bodyMass: 10000000)
        addComponent(collisionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
