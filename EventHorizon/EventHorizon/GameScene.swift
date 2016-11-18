//
//  GameScene.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 04/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit
import ReplayKit

class GameScene: SKScene {
    
    var entityManager: EntityManager!
    fileprivate var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
    }
    
    override func didMove(to view: SKView) {
        entityManager = EntityManager(scene: self)
        
        let spaceship = Spaceship(imageNamed: "Spaceship")
        if let spriteComponent = spaceship.spriteComponent {
            spriteComponent.node.position = CGPoint(x: spriteComponent.node.size.width/2, y: size.height/2)
        }
        if let movementComponent = spaceship.component(ofType: MovementComponent.self) {
            movementComponent.setupEntityDependentProperties()
        }
        entityManager.add(spaceship)
        
        let planet = Planet(imageNamed: "blackhole", radius: 400, strenght: 5)
        if let spriteComponent = planet.spriteComponent {
            spriteComponent.node.position = CGPoint(x: size.width - 2.5*spriteComponent.node.size.width, y: size.height/1.85)
        }
        if let gravityComponent = planet.component(ofType: GravityComponent.self) {
            gravityComponent.setupEntityDependentProperties()
        }
        entityManager.add(planet)
        
        physicsWorld.gravity = CGVector.zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        let deltaTime = currentTime - lastUpdateTime
        self.lastUpdateTime = currentTime
        entityManager.update(deltaTime)
        print("Scene update")
        
        
    }
}
