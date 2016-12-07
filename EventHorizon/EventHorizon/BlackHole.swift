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


    init(imageNamed: String, speedOutBlackHole: CGFloat, position: CGPoint, entityManager: EntityManager, ship: SKSpriteNode, orbitingNodes: [SKSpriteNode]) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
//        let size = CGSize(width: texture.size.width, height: <#T##Double#>)
        let spriteComponent = SpriteComponent(texture: texture,
                                              size: texture.size(),
                                              nodePosition: position,
                                              typeOfBody: TypeOfBody.Circle,
                                              name: "BlackHole")
        spriteComponent.physicsBody?.isDynamic = false
        addComponent(spriteComponent)
        
        let size = CGSize(width: texture.size().width+100, height: texture.size().height+100)
        
        let orbitComponent = OrbitComponent(orbitSpeed: 50,
                                            parentNode: spriteComponent.node,
                                            blackHoleOrbitSize: size.width,
                                            speed: speedOutBlackHole,
                                            entityManager: entityManager,
                                            ship: ship,
                                            orbitingNodes: orbitingNodes)
        addComponent(orbitComponent)
        
        let collisionComponent = CollisionComponent(parentNode: spriteComponent.node,
                                                    bodyMass: 10000000)
        addComponent(collisionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
