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
    var blackHole: BlackHole!
    var menu: LevelMenuView!
    var gameStart = false
    var planetIsClicked = false
    var blackHoleIsClicked = false
    var selectedNode: SKSpriteNode!
    var initialSpaceshipPosition: CGPoint!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        entityManager = EntityManager(scene: self)
        selectedNode = SKSpriteNode()
        self.physicsWorld.contactDelegate = self
        initialSpaceshipPosition = CGPoint(x: self.frame.width/20, y: self.frame.height/7.8)
    }
    
    override func didMove(to view: SKView) {
        
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
                entityManager.restartLevel()
                entityManager.timer.invalidate()
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
        
        entityManager.update(deltaTime)
    }
}


extension GameScene {
    
    // draging objects
    func panForTranslation(translation: CGPoint) {
        
        let position = selectedNode.position
        guard let name = selectedNode.name else { return }
        
        if name == "BlackHole" || name == "Planet" {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
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
        
        guard let name = selectedNode.name else { return }
        
        if name == "BlackHole" || name == "Planet" {
            entityManager.entities.forEach({ entity in
                
                if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
                    if spriteComponent.node.isEqual(selectedNode) {
                        entityManager.remove(entity)
                        
                    }
                }
            })
            selectedNode.removeFromParent()
        }
    }
    
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    //select node
    func selectNodeForTouch(touchLocation: CGPoint) {
        
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                
                guard let node = touchedNode as? SKSpriteNode else { return }
                selectedNode = node
                
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

