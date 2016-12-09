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
    let scene: GameScene
    var timer: Timer = Timer()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MovementComponent.self)
        let orbitSystem = GKComponentSystem(componentClass: OrbitComponent.self)
        let fuelSystem = GKComponentSystem(componentClass: FuelComponent.self)
        let timeSystem = GKComponentSystem(componentClass: TimeComponent.self)
        let collisionSystem = GKComponentSystem(componentClass: CollisionComponent.self)
        return [moveSystem, orbitSystem, fuelSystem, timeSystem, collisionSystem]
    }()
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        
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
        entities.remove(entity)
        
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        componentSystems.forEach{ $0.update(deltaTime: deltaTime) }
        removeCopiesOutOfBound()
    }
    
}

// Extension to manage the copies that create the trajectory effect
extension EntityManager {
    
    func addCopy(_ copy: GKEntity) {
        trajectory.append(copy)
        
        componentSystems.forEach{ $0.addComponent(foundIn: copy) }
        
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
        
        if trajectory.count == 0 {
            print("Trajectory count is 0")
            return
        }
        
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
    }
    
    func removeCopiesOutOfBound() {
        
        trajectory.forEach({ copy in
            
            guard let spriteComponent = copy?.spriteComponent else { fatalError("Copy should have a spritecomponent") }
            
            if spriteComponent.node.position.isOutOfBounds(viewWidth: (scene.view?.frame.width)!,
                                                           viewHeight: (scene.view?.frame.height)!) {
                spriteComponent.node.name = "removeThisCopy"
                removeCopy(withThisName: "removeThisCopy")
            }
        
        })
    }
    
}

// Miscellanea
extension EntityManager {
    
    func addToScene(thisNode node: SKNode) {
        scene.addChild(node)
    }
    
    func shipIsOrbiting(isOrbiting: Bool) {
        if let ship = self.find(entityOfType: Spaceship.self) as? Spaceship {
            ship.isOrbiting = isOrbiting
        }
    }
    
    func isShipOrbiting() -> Bool {
        if let ship = self.find(entityOfType: Spaceship.self) as? Spaceship {
            return ship.isOrbiting
        }
        
        return false
    }
    
    func getShipNode() -> SKSpriteNode? {
        if let ship = self.find(entityOfType: Spaceship.self) as? Spaceship {
            return (ship.spriteComponent?.node)!
        }
        return nil
    }
    
    func getEmitter() -> SKEmitterNode? {
        if let ship = self.find(entityOfType: Spaceship.self) as? Spaceship {
            return (ship.component(ofType: ParticleComponent.self)?.emitter)!
        }
        return nil
    }
    
    func getTime() -> String {
        if let ship = self.find(entityOfType: Spaceship.self) as? Spaceship {
            guard let time = ship.component(ofType: TimeComponent.self) else {
                fatalError("The ship is expected to have a timecomponent")
            }
            
            time.timer.invalidate()
            return (time.timeLabel.text)!
        } else {
            return ""
        }        
    }
    
}

// spawn objects
extension EntityManager {
    
    func planetIsClicked() {
        
        if scene.planetIsClicked {
            scene.planetIsClicked = false
//            if let button = scene.children.first(where: {$0.name == "jupiter"}) as? CustomButton {
//                let sequence = SKAction.sequence([button.action.reversed(), button.action2.reversed()])
//                button.run(sequence)
//            }
        } else {
            scene.planetIsClicked = true
            scene.blackHoleIsClicked = false
        }
        
    }
    
    func spawnPlanet(inThisPoint point: CGPoint) {
        
        let planet = Planet(imageNamed: "jupiter", radius: scene.frame.width/15, strenght: 0.75, position: point, orbitingNodes: [], entityManager: self, name: "Planet")
        planet.component(ofType: OrbitComponent.self)?.noMoon = true
        add(planet)
        
    }
    
    func blackHoleIsClicked() {
        
        if scene.blackHoleIsClicked {
            scene.blackHoleIsClicked = false
//            if let button = scene.children.first(where: {$0.name == "blackhole"}) as? CustomButton {
//                let sequence = SKAction.sequence([button.action.reversed(), button.action2.reversed()])
//                button.run(sequence)
//            }
        } else {
            scene.blackHoleIsClicked = true
            scene.planetIsClicked = false
        }
        
    }
    
    func spawnblackHole(inThisPoint point: CGPoint) {
        
        let blackhole = BlackHole(imageNamed: "blackhole", speedOutBlackHole: 100, position: point, entityManager: self, ship: (scene.spaceship.spriteComponent?.node)!, orbitingNodes: [])
        add(blackhole)
        
    }
    
    func gameStarted() -> Bool {
        
        return scene.gameStart
    }
    
    
    
    func manageStartRestartLevel() {
        
        if scene.gameStart {
            
            restartLevel()
            let button = scene.children.first(where: { $0.name == "play" }) as! TriggerButton
            
            button.texture = SKTexture(imageNamed: "play")
            
        } else {
            
            startLevel()
            let button = scene.children.first(where: { $0.name == "play" }) as! TriggerButton
            
            button.texture = SKTexture(imageNamed: "restart")
        }
    }
    
    func restartLevel() {
        
        self.remove(scene.spaceship)
        scene.removeChildren(in: [scene.childNode(withName: "fuelTank")!, scene.childNode(withName: "timeLabel")!])
        
        scene.spaceship = Spaceship(  imageNamed: "Spaceship",
                                      speed: 150,
                                      entityManager: self,
                                      position: scene.initialSpaceshipPosition)
        self.add(scene.spaceship)
        
        entities.forEach({ entity in
            
            if entity.spriteComponent?.node.name == "BlackHole" {
                
                entity.component(ofType: OrbitComponent.self)?.ship = self.getShipNode()
            }
            
        })
        
        self.startCopys()
        scene.gameStart = false
        scene.spaceship.spriteComponent?.node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
    }
    
    func startLevel() {
        
        scene.planetIsClicked = false
        scene.blackHoleIsClicked = false
        
        scene.gameStart = true
        scene.spaceship.spriteComponent?.physicsBody?.isDynamic = true
        scene.spaceship.spriteComponent?.physicsBody?.categoryBitMask = CollisionCategory.Collision
        scene.entityManager.timer.invalidate()
        scene.entityManager.removeAllCopies()
        scene.selectedNode = nil
        scene.spaceship.component(ofType: TimeComponent.self)?.startTimer()
    }
    
    func startCopys(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            
            guard let spaceship = self.find(entityOfType: Spaceship.self) else {
                print("Spaceship not found")
                return
            }
            
            guard let trajectoryComponent = spaceship.component(ofType: TrajectoryComponent.self) else {
                print("Trajectory not found")
                return
            }
            
            trajectoryComponent.trajectory()
            
        })
    }
    
}

