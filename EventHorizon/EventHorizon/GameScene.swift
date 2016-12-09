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
    
    private var lastUpdateTime : TimeInterval = 0
    var entityManager: EntityManager!
    var spaceship: Spaceship!
    var planet: Planet!
    var planet2: Planet!
    var moon1: Moon!
    var moon2: Moon!
    var blackHole: BlackHole!
    var menu: LevelMenuView!
    var gameStart = false
    var planetIsClicked = false
    var blackHoleIsClicked = false
    var selectedNode: SKSpriteNode?
    var initialSpaceshipPosition: CGPoint!
    var initialMoon1Position: CGPoint!
    var initialMoon2Position: CGPoint!
    var wonLabel: SKLabelNode!
    var lostLabel: SKLabelNode!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        entityManager = EntityManager(scene: self)
        selectedNode = SKSpriteNode()
        self.physicsWorld.contactDelegate = self
        initialSpaceshipPosition = CGPoint(x: self.frame.width/20, y: self.frame.height/7.8)
        initialMoon1Position = CGPoint(x: self.frame.width/2.3, y: self.frame.height/1.3)
        initialMoon2Position = CGPoint(x: self.frame.width/1.1, y: self.frame.height/1.3)
    }
    
    override func didMove(to view: SKView) {
        print("didMove")
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        self.view!.addGestureRecognizer(panGesture)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.deletePlanet))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        spaceship = Spaceship(  imageNamed: "Spaceship",
                                speed: 150,
                                entityManager: entityManager,
                                position: initialSpaceshipPosition)
        
        entityManager.add(spaceship)
        entityManager.startCopys()
        
        menu = LevelMenuView(scene: self, entityManager: entityManager)
        
        moon1 = Moon(imageNamed: "netuno", radius: self.frame.width/40, position: initialMoon1Position)
        entityManager.add(moon1)
        
        moon1.spriteComponent?.node.isUserInteractionEnabled = false
        
        moon2 = Moon(imageNamed: "mercurio", radius: self.frame.width/40, position: initialMoon2Position)
        entityManager.add(moon2)
        
        moon2.spriteComponent?.node.isUserInteractionEnabled = false
        
        planet = Planet(imageNamed: "jupiter", radius: self.frame.width/15, strenght: 0.75, position: CGPoint(x: self.frame.width/1.1, y:self.frame.height/1.1) , orbitingNodes: [moon1.spriteComponent!.node, moon2.spriteComponent!.node], entityManager: entityManager, name: "Objective")
        entityManager.add(planet)
        
        planet.spriteComponent?.node.isUserInteractionEnabled = false
        
        planet.component(ofType: OrbitComponent.self)?.updateOrbiter(dt: 1, orbiter: moon1.spriteComponent!.node)
        planet.component(ofType: OrbitComponent.self)?.updateOrbiter(dt: 1, orbiter: moon2.spriteComponent!.node)
        
        planet2 = Planet(imageNamed: "marte", radius: self.frame.width/25, strenght: 0, position: CGPoint(x: self.frame.width/2.3, y: self.frame.height/1.25), orbitingNodes: [], entityManager: entityManager, name: "Planet")
        
        entityManager.add(planet2)
        
        physicsWorld.gravity = CGVector.zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !gameStart {
        
            guard let touchedPoint = touches.first?.location(in: self) else {
                print("Touch location not found")
                return
            }
            
            if planetIsClicked && !gameStart {
                entityManager.spawnPlanet(inThisPoint: touchedPoint)
                planetIsClicked = false
            }
            
            if blackHoleIsClicked && !gameStart{
                entityManager.spawnblackHole(inThisPoint: touchedPoint)
                blackHoleIsClicked = false
            }
            
        } else {
            
            if let orbitComponent = entityManager.find(entityOfType: BlackHole.self)?.component(ofType: OrbitComponent.self) {
                
                if orbitComponent.collision && !orbitComponent.didClick {
                    
                    orbitComponent.didClick = true
                    orbitComponent.leaveOrbit()
                    entityManager.shipIsOrbiting(isOrbiting: false)
                    entityManager.getEmitter()?.particleAlpha = 0
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if contact.bodyA.node?.name == "Spaceship" &&
            (contact.bodyB.node?.name == "Planet" || contact.bodyB.node?.name == "BlackHole" || contact.bodyB.node?.name == "Moon") {
            if gameStart {
                entityManager.remove(spaceship)
                
            } else {
                
                contact.bodyB.node?.name = "removeThisEntity"
                guard let entity = entityManager.find(entityWithName: "removeThisEntity") else {
                    print("entity not found")
                    return
                }
                
                entityManager.remove(entity)
                entityManager.restartLevel()
                entityManager.timer.invalidate()

            }
            
            lostLabel = SKLabelNode(fontNamed: "Courier-Bold")
            lostLabel.text = "Your journey has ended."
            lostLabel.color = UIColor.white
            lostLabel.fontSize = 25
            lostLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            lostLabel.zPosition = 5
            lostLabel.name = "lost"
            self.addChild(lostLabel)
        }
        
        if contact.bodyA.node?.name == "copy" &&
            (contact.bodyB.node?.name == "Planet"
                || contact.bodyB.node?.name == "BlackHole"
                || contact.bodyB.node?.name == "Objective"
                || contact.bodyB.node?.name == "Moon") {
            
            contact.bodyA.node?.name = "removeThisCopy"
            entityManager.removeCopy(withThisName: "removeThisCopy")
        }
        
        if contact.bodyA.node?.name == "Spaceship" &&
            contact.bodyB.node?.name == "Objective" {
            
            entityManager.entities.forEach({
                entity in
                
                if entity.spriteComponent?.node.name == "Objective" {
                    
                    entity.component(ofType: OrbitComponent.self)?.ship = contact.bodyA.node as! SKSpriteNode?
                }
                
            })
            
            wonLabel = SKLabelNode(fontNamed: "Courier-Bold")
            wonLabel.text = "Your journey has been completed in\n" +
                entityManager.getTime()
            print("Journey time", entityManager.getTime())
            wonLabel.color = UIColor.white
            wonLabel.fontSize = 25
            wonLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            wonLabel.zPosition = 5
            wonLabel.name = "won"
            self.addChild(wonLabel)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let deltaTime = currentTime - lastUpdateTime
        self.lastUpdateTime = currentTime
        
        entityManager.update(deltaTime)
    }
}


extension GameScene {
    
    // draging objects
    func panForTranslation(translation: CGPoint) {
        
//        if gameStart { return }
//        
//        let position = selectedNode.position
//        guard let name = selectedNode.name else { return }

        guard let selected = selectedNode else { return }
        
        let position = selected.position
        guard let name = selected.name else { return }
        
        if name == "BlackHole" || name == "Planet" {
            selected.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        }
    }
    
    // draging objects
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
            self.selectNodeForTouch(touchLocation: touchLocation)
        } else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            self.panForTranslation(translation: translation)
            
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
        }
    }
    
    //deleting planets
    func deletePlanet (){
        
        if gameStart { return }
        guard let selected = selectedNode else { return }
        guard let name = selected.name else { return }
        
        if name == "BlackHole" || name == "Planet" {
            entityManager.entities.forEach({ entity in
                
                if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
                    if spriteComponent.node.isEqual(selectedNode) {
                        
                        entityManager.remove(entity)
                    }
                }
            })
            selected.removeFromParent()
        }
    }
    
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    //select node
    func selectNodeForTouch(touchLocation: CGPoint) {
        
        let touchedNode = self.atPoint(touchLocation)
        guard let node = touchedNode as? SKSpriteNode else { return }
        
        if !gameStart {
            
            selectedNode = node
            
//            if !selected.isEqual(touchedNode) {
//                selected.removeAllActions()
//                selected.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
//                
            
//                if selected.name == "BlackHole" || selected.name == "Planet" {
//                    let action = SKAction.scale(by: 0.9, duration: 0.5)
//                    let action2 = SKAction.scale(by: 1.11111111, duration: 0.5)
//                    let sequence = SKAction.sequence([action, action2])
////                    SKAction.rotate(byAngle: degToRad(degree: -4.0), duration: 0.1),
////                    SKAction.rotate(byAngle: 0.0, duration: 0.1),
////                    SKAction.rotate(byAngle: degToRad(degree: 4.0), duration: 0.1)
//                    selected.run(SKAction.repeatForever(sequence))
//                }
//            }
        }
    }
}

