//
//  Spaceship.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class Spaceship: GKEntity {
    
    let entityManager: EntityManager
    
    init(imageNamed: String, speed: Double, entityManager: EntityManager) {
        self.entityManager = entityManager
        
        super.init()
        let texture = SKTexture(imageNamed: imageNamed)
        let spriteComponent =
        SpriteComponent(texture: texture,
                        size: CGSize(width: texture.size().width/10,
                                     height: texture.size().height/10),
                        nodePosition: CGPoint(x:338.0, y:344.0),
                        typeOfBody: .Rectangle,
                        name: "Spaceship")
        spriteComponent.physicsBody?.fieldBitMask = GravityFieldCategory.Gravity
        addComponent(spriteComponent)
        
        let collisionComponent = CollisionComponent(parentNode: spriteComponent.node,
                                                    bodyMass: 0.01)
        spriteComponent.physicsBody?.categoryBitMask = CollisionCategory.None
        addComponent(collisionComponent)
        
        let movementComponent = MovementComponent(speed: speed,
                                                  maxSpeed: 500,
                                                  acceleration: 15,
                                                  parentNode: spriteComponent.node)
        addComponent(movementComponent)
        
        let trajectoryComponent = TrajectoryComponent(entityManager: entityManager)
        addComponent(trajectoryComponent)
        
        let fuelComponent = FuelComponent(entityManager: entityManager,
                                          rect: CGRect(x: 0, y: 50, width: 200, height: 40),
                                          fuel: 100)
        addComponent(fuelComponent)
        
        let timeComponent = TimeComponent(entityManager: entityManager)
        addComponent(timeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy() -> Any {
        let copy = Spaceship(imageNamed: "Spaceship", speed: 100, entityManager: entityManager)
        let fuelComponent = copy.component(ofType: FuelComponent.self)!
        fuelComponent.fuelBar.removeFromParent()
        let timeComponent = copy.component(ofType: TimeComponent.self)!
        timeComponent.timeLabel.removeFromParent()
        copy.removeComponent(ofType: TimeComponent.self)
        copy.removeComponent(ofType: FuelComponent.self)
        return copy
    }
    
}
