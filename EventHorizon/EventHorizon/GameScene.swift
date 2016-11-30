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
    var menu: LevelMenuView!
    var gameStart = false
    private var lastUpdateTime : TimeInterval = 0
    var planetIsClicked = false
    var blackHoleIsClicked = false
    var selectedNode: SKSpriteNode!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        entityManager = EntityManager(scene: self)
        selectedNode = SKSpriteNode()
        self.physicsWorld.contactDelegate = self
    }
    
    override func didMove(to view: SKView) {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        self.view!.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapShip(recognizer:)))
        self.view!.addGestureRecognizer(tapGesture)
        
        spaceship = Spaceship(imageNamed: "Spaceship",
                              speed: 150,
                              entityManager: entityManager)
        entityManager.add(spaceship)
        
        menu = LevelMenuView(scene: self, entityManager: entityManager)
        
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
                    print("LeaveOrbit")
                    orbitComponent.didClick = true
                    orbitComponent.leaveOrbit()
                    entityManager.shipIsOrbiting(isOrbiting: false)
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
            (contact.bodyB.node?.name == "Planet" || contact.bodyB.node?.name == "BlackHole") {
            if gameStart {
                entityManager.remove(spaceship)
            }
            else {
                
                contact.bodyB.node?.name = "removeThisEntity"
                guard let entity = entityManager.find(entityWithName: "removeThisEntity") else {
                    print("entity not found")
                    return
                }
                entityManager.remove(entity)
                
            }
        }
        
        
        
        if contact.bodyA.node?.name == "copy" &&
            (contact.bodyB.node?.name == "Planet"
                || contact.bodyB.node?.name == "BlackHole") {
            contact.bodyA.node?.name = "removeThisCopy"
            entityManager.removeCopy(withThisName: "removeThisCopy")
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let deltaTime = currentTime - lastUpdateTime
        self.lastUpdateTime = currentTime
        
        //if gameStart {
            entityManager.update(deltaTime)
        //}
        
    }
}

// draging objects
extension GameScene {
    
    func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        guard let name = selectedNode.name else { return }
        
        if name == "BlackHole" || name == "Planet" {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        }
    }
    
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
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        // 1
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            // 2
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                
                guard let node = touchedNode as? SKSpriteNode else { return }
                selectedNode = node
                // 3
                if selectedNode.name == "BlackHole" || selectedNode.name == "Planet" {
                    let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(degree: -4.0), duration: 0.1),
                                                      SKAction.rotate(byAngle: 0.0, duration: 0.1),
                                                      SKAction.rotate(byAngle: degToRad(degree: 4.0), duration: 0.1)])
                    selectedNode.run(SKAction.repeatForever(sequence))
                }
            }
        }
    }
    
}


// tap ship and start game
extension GameScene {
    func tapShip(recognizer: UITapGestureRecognizer) {
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        
        if recognizer.state == .ended {
            selectNodeForTouch(touchLocation: touchLocation)
            if selectedNode.name == "Spaceship" {
                if !gameStart && !planetIsClicked && !blackHoleIsClicked {
                    gameStart = true
                    spaceship.spriteComponent?.physicsBody?.isDynamic = true
                    spaceship.spriteComponent?.physicsBody?.categoryBitMask = CollisionCategory.Collision
                    entityManager.timer.invalidate()
                    entityManager.removeAllCopies()
                    spaceship.component(ofType: TimeComponent.self)?.startTimer()
                }
            }
        }

    }
}
