//
//  EntityManager.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 08/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

extension EntityManager {
    
    func addCopy(_ copy: GKEntity) {
        trajectory.append(copy)
        
        componentSystems.forEach{$0.addComponent(foundIn: copy)}
        
        if let spriteNode = copy.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    func removeCopy() {
        
        guard let copy = trajectory.first else { return }
        
        if let spriteNode = copy.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        trajectory.removeFirst()
    }
    
    func removeAllCopies() {
        trajectory.forEach{ _ in removeCopy() }
    }
}

class EntityManager {
    
    var entities = Set<GKEntity>()
    var trajectory = [GKEntity]()
    let scene: SKScene
    var timer: Timer = Timer()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MovementComponent.self)
        let orbitSystem = GKComponentSystem(componentClass: OrbitComponent.self)
        return [moveSystem, orbitSystem]
    }()
    
    init(scene: SKScene) {
        self.scene = scene
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in 
            
            guard let spaceship = self.find(entityOfType: Spaceship.self) else {
                print("Spaceship not found")
                return
            }
            
            guard let trajectory = spaceship.component(ofType: TrajectoryComponent.self) else {
                print("Trajectory not found")
                return
            }
            
            trajectory.trajectory()
            
        })
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        componentSystems.forEach{$0.addComponent(foundIn: entity)}
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    func remove(_ entity: GKEntity) {
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
//        toRemove.insert(entity)
        entities.remove(entity)
        
    }

    func update(deltaTime: CFTimeInterval) {
        componentSystems.forEach{ $0.update(deltaTime: deltaTime) }
//        print("Entity update")
    }
    
    
}
