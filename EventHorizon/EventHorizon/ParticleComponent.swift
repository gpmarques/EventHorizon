//
//  ParticleComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 18/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class ParticleComponent: GKComponent {
    
    var emitter: SKEmitterNode
    
    init(fileNamed: String, parentNode: SKSpriteNode, entityManager: EntityManager) {
        
        self.emitter = SKEmitterNode(fileNamed: fileNamed)!
        self.emitter.targetNode = entityManager.scene
        self.emitter.particleAlpha = 0
        self.emitter.position.y = -14.5
        super.init()
        parentNode.addChild(emitter)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
