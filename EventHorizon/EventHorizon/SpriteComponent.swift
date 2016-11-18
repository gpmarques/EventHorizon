//
//  SpriteComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

enum TypeOfBody {
    case Circle
    case Rectangle
    case None
}

class SpriteComponent: GKComponent {
    
    var node: SKSpriteNode
    
    init(texture: SKTexture, size: CGSize, nodePosition: CGPoint, typeOfBody: TypeOfBody, name: String) {
        node = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        node.position = nodePosition
        node.anchorPoint = CGPoint(x: node.centerRect.midX,
                                   y: node.centerRect.midY )
        node.name = name
        
        switch typeOfBody {
        case .Circle:
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.width/2)
        case .Rectangle:
            node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
        case .None:
            node.physicsBody = nil
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
