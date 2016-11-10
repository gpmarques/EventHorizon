//
//  GravityComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit


struct GravityFieldCategory {
    static let None: UInt32 = 0
    static let Gravity: UInt32 = 1
}

class GravityComponent: GKComponent {
    
    var gravitationalFieldNode: SKFieldNode
    
    init(radius: Float, strenght: Float) {
        gravitationalFieldNode = SKFieldNode.radialGravityField()
        gravitationalFieldNode.region = SKRegion(radius: radius)
        gravitationalFieldNode.strength = strenght
        gravitationalFieldNode.falloff = 2.5

        super.init()
    }
    
    func setupEntityDependentProperties() {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        gravitationalFieldNode.position = spriteComponent.node.anchorPoint
        gravitationalFieldNode.physicsBody?.categoryBitMask = GravityFieldCategory.Gravity
        gravitationalFieldNode.physicsBody?.fieldBitMask = GravityFieldCategory.None
        spriteComponent.gravityFieldCategory = GravityFieldCategory.None
        gravitationalFieldNode.isEnabled = true
        spriteComponent.node.addChild(gravitationalFieldNode)
        
        print(gravitationalFieldNode.position.x)
        print(gravitationalFieldNode.position.y)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
