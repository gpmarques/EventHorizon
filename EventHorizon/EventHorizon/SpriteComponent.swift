//
//  SpriteComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    var node: SKSpriteNode
    
    init(texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
