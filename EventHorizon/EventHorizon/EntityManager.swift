//
//  EntityManager.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 08/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    var trajectory = [GKEntity?]()
    let scene: SKScene
    var timer: Timer = Timer()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MovementComponent.self)
        return [moveSystem]
    }()
    
    init(scene: SKScene) {
        self.scene = scene
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            
            guard let spaceship = self.find(entityOfType: Spaceship.self) else {
                print("Spaceship not found")
                return
            }
            
            guard let trajectoryComponent = spaceship.component(ofType: TrajectoryComponent.self) else {
                print("Trajectory not found")
                return
            }
            
            //            guard let fuelComponent = spaceship.component(ofType: FuelComponent.self) else {
            //                print("Fuel not found")
            //                return
            //            }
            //
            //            var _ = fuelComponent.spendFuel(10)
            
            trajectoryComponent.trajectory()
            
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
    
    func update(_ deltaTime: CFTimeInterval) {
        componentSystems.forEach{ $0.update(deltaTime: deltaTime) }
        //        print("Entity update")
    }
    
    
}

// Extension to manage the copies that create the trajectory effect
extension EntityManager {
    
    func addCopy(_ copy: GKEntity) {
        trajectory.append(copy)
        
        componentSystems.forEach{$0.addComponent(foundIn: copy)}
        
        if let spriteNode = copy.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    func removeCopy(withThisName name: String) {
        
        guard let index = trajectory.index(where: { $0?.spriteComponent?.node.name == name}) else {
            print("index not found")
            return
        }
        
        removeCopy(UntilThisIndex: index)
        
    }
    
    func removeAllCopies() {
        removeCopy(UntilThisIndex: max(trajectory.count-1, 0))
    }
    
    private func removeCopy(UntilThisIndex index: Int) {
        
        print("Index", index)
        
        for i in 0...index {
            guard let copy = trajectory[i] else {
                print("Copy not found")
                return
            }
            
            guard let spriteNode = copy.component(ofType: SpriteComponent.self)?.node else {
                print("SpriteNode not found")
                return
            }
            
            spriteNode.removeFromParent()
        }
        
        trajectory.removeSubrange(0...index)
        
        print("Trajectory count", trajectory.count)
    }
    
}

extension EntityManager {
    
    func addToScene(thisNode node: SKNode) {
        scene.addChild(node)
    }
    
}
