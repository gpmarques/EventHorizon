//
//  GameScene.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 04/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entityManager: EntityManager!
    var spaceship: Spaceship!
    var planet: Planet!
    var blackHole: BlackHole!
    var gameStart = false
    private var lastUpdateTime : TimeInterval = 0
    
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        print("didLoad")
        entityManager = EntityManager(scene: self)
        self.physicsWorld.contactDelegate = self
    }
    
    override func didMove(to view: SKView) {
        
        spaceship = Spaceship(imageNamed: "Spaceship",
                              speed: 100,
                              entityManager: entityManager)
        entityManager.add(spaceship)
        
        

        planet = Planet(imageNamed: "jupiter", radius: 400, strenght: 5)
        entityManager.add(planet)
        
        blackHole = BlackHole(imageNamed: "blackhole", speedOutBlackHole: 100)
        entityManager.add(blackHole)
        
        physicsWorld.gravity = CGVector.zero
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !gameStart {
            gameStart = true
            spaceship.spriteComponent?.physicsBody?.isDynamic = true
            spaceship.spriteComponent?.physicsBody?.categoryBitMask = CollisionCategory.Collision
            entityManager.timer.invalidate()
            entityManager.removeAllCopies()
            spaceship.component(ofType: TimeComponent.self)?.startTimer()
        } else if blackHole.component(ofType: OrbitComponent.self)?.collision == true {
            
            spaceship.component(ofType: ParticleComponent.self)?.emitter.particleAlpha = 0
            blackHole.component(ofType: OrbitComponent.self)?.didClick = true
            blackHole.component(ofType: OrbitComponent.self)?.leaveOrbit()
            spaceship.component(ofType: TimeComponent.self)?.normalizeTimeRate()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact.contactPoint)
        if contact.bodyA.node?.name == "Spaceship" &&
            contact.bodyB.node?.name == "Planet" {
            entityManager.remove(spaceship)
        }
        if contact.bodyA.node?.name == "copy" &&
            (contact.bodyB.node?.name == "Planet"
                || contact.bodyB.node?.name == "BlackHole") {
            contact.bodyA.node?.name = "removeThisCopy"
            entityManager.removeCopy(withThisName: "removeThisCopy")
        }
        if contact.bodyA.node?.name == "Spaceship" &&
            contact.bodyB.node?.name == "BlackHole" {
            entityManager.remove(spaceship)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let deltaTime = currentTime - lastUpdateTime
        self.lastUpdateTime = currentTime
        
        entityManager.update(deltaTime)
        
        self.lastUpdateTime = (deltaTime >= 1) ? currentTime : lastUpdateTime
        
        entityManager.update(deltaTime)
        
        blackHole.update(deltaTime: deltaTime)
        
        guard let orbit = blackHole.component(ofType: OrbitComponent.self) else {return}
        
        if  orbit.orbitNode.intersects((spaceship.spriteComponent?.node)!) &&
            orbit.didClick == false {
            
            spaceship.component(ofType: ParticleComponent.self)?.emitter.particleAlpha = 1
            let angle = blackHole.component(ofType: OrbitComponent.self)?.getAngle(ofObjectOrbiting: (spaceship.spriteComponent?.node)!)
            blackHole.component(ofType: OrbitComponent.self)?.ship = spaceship.spriteComponent?.node
            blackHole.component(ofType: OrbitComponent.self)?.orbiterAngle = angle!
            blackHole.component(ofType: OrbitComponent.self)?.collision = true
            blackHole.component(ofType: OrbitComponent.self)?.setupRotationDirection(object: (spaceship.spriteComponent?.node)!)
            spaceship.component(ofType: TimeComponent.self)?.timeDilation()
            
            if (spaceship.component(ofType: FuelComponent.self)?.spendFuel(0.5))! {
                
                spaceship.component(ofType: ParticleComponent.self)?.emitter.particleAlpha = 0
                blackHole.component(ofType: OrbitComponent.self)?.fuel = false
                blackHole.component(ofType: OrbitComponent.self)?.leaveOrbit()
            }
        }
    }
}
