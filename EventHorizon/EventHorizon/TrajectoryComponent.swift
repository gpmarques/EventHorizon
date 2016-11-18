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
    var copyCounter: Int
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        copyCounter = 0
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func trajectory() {
        
        guard let entityClassType = entity?.ClassType else { return }
        print("ClassType", entityClassType as Any)
        guard let trajectoryOwner = entityManager.find(entityOfType: entityClassType) else {
            print("trajectory owner not found")
            return
        }
        copyCounter += 1
        let copy = trajectoryOwner.copy() as! GKEntity
        copy.removeComponent(ofType: FuelComponent.self)
        copy.spriteComponent?.physicsBody?.isDynamic = true
        copy.spriteComponent?.node.name = "copy"
        
        entityManager.addCopy(copy)
        
    }
    
}
