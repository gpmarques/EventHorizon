//
//  BlackHoleOrbit.swift
//  EventHorizon
//
//  Created by Matheus Lourenco Fernandes Soares on 18/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import Foundation
import GameplayKit

class BlackHoleOrbit: GKEntity {
    
    init(imageNamed: String, size: CGSize){
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        let spriteComponent = SpriteComponent(texture: texture,
                                              size: CGSize(width: size.width+100, height: size.height+100) ,
                                              nodePosition: CGPoint(x: 338, y: 700),
                                              typeOfBody: TypeOfBody.Circle,
                                              name: "BlackHole")
        spriteComponent.physicsBody?.mass = 100000000000
        addComponent(spriteComponent)
        spriteComponent.physicsBody?.isDynamic = false
        spriteComponent.physicsBody?.collisionBitMask = CollisionCategory.None
        spriteComponent.physicsBody?.categoryBitMask = CollisionCategory.None
        spriteComponent.node.alpha = 0
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
