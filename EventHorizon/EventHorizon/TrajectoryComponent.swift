//
//  TrajectoryComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 14/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class TrajectoryComponent: GKComponent {
    
    let entityManager: EntityManager
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func trajectory() {
        
        guard let entityClassType = entity?.ClassType else { return }
        guard let trajectoryOwner = entityManager.find(entityOfType: entityClassType) else {
            print("trajectory owner not found")
            return
        }
        let copy = trajectoryOwner.copy() as! GKEntity
        copy.spriteComponent?.physicsBody?.isDynamic = true
        copy.spriteComponent?.node.name = "copy"
        
        entityManager.addCopy(copy)
        
    }
    
}
