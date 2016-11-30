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
    var isOrbiting: Bool
    var collisionComponent: CollisionComponent!
    
    init(imageNamed: String, speed: Double, entityManager: EntityManager) {
        self.entityManager = entityManager
        self.isOrbiting = false
        
        super.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        let spriteComponent =
        SpriteComponent(texture: texture,
                        size: CGSize(width: texture.size().width/5,
                                     height: texture.size().height/5),
                        nodePosition: CGPoint(x:338.0, y:100.0),
                        typeOfBody: .Rectangle,
                        name: "Spaceship")
        spriteComponent.physicsBody?.fieldBitMask = GravityFieldCategory.Gravity
        addComponent(spriteComponent)
        
        collisionComponent = CollisionComponent(parentNode: spriteComponent.node,
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
                                          rect: CGRect(x: 0,
                                                       y: entityManager.getScene.frame.width/40,
                                                       width: entityManager.getScene.frame.width/5 + 10 ,
                                                       height: entityManager.getScene.frame.height/35), fuel: 100)
        addComponent(fuelComponent)
        
        let timeComponent = TimeComponent(entityManager: entityManager)
        addComponent(timeComponent)
        
        let particleComponent = ParticleComponent(fileNamed: "SpaceshipRocket.sks",
                                                  parentNode: spriteComponent.node,
                                                  entityManager: entityManager)
        addComponent(particleComponent)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy() -> Any {
        let copy = Spaceship(imageNamed: "Spaceship", speed: 150, entityManager: entityManager)
        copy.spriteComponent?.node.alpha = 0.5
        let fuelComponent = copy.component(ofType: FuelComponent.self)!
        fuelComponent.fuelBar.removeFromParent()
        fuelComponent.fuelTank.removeFromParent()
        let timeComponent = copy.component(ofType: TimeComponent.self)!
        timeComponent.timeLabel.removeFromParent()
        let particleComponent = copy.component(ofType: ParticleComponent.self)!
        particleComponent.emitter.removeFromParent()
        copy.removeComponent(ofType: TimeComponent.self)
        copy.removeComponent(ofType: FuelComponent.self)
        copy.removeComponent(ofType: ParticleComponent.self)
        return copy
    }
    
}
