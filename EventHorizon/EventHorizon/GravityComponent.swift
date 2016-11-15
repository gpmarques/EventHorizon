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
    
    init(parentNode: SKSpriteNode, radius: Float, strenght: Float) {
        gravitationalFieldNode = SKFieldNode.radialGravityField()
        gravitationalFieldNode.region = SKRegion(radius: radius)
        gravitationalFieldNode.strength = strenght
        gravitationalFieldNode.falloff = 2.5
        gravitationalFieldNode.position = parentNode.anchorPoint
        gravitationalFieldNode.physicsBody?.categoryBitMask = GravityFieldCategory.Gravity
        gravitationalFieldNode.physicsBody?.fieldBitMask = GravityFieldCategory.None
        parentNode.physicsBody?.fieldBitMask = GravityFieldCategory.None
        
        parentNode.addChild(gravitationalFieldNode)

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
