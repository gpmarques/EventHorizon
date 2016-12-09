//
//  OrbitComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class OrbitComponent: GKComponent {
    
    var ship: SKSpriteNode?
    var orbitingNodes: [SKSpriteNode]
    var parentNode: SKSpriteNode
    var lastUpdateTime: CFTimeInterval = 0
    var speed: CGFloat
    
    var orbiterSpeed: CGFloat
    var orbiterRadius: CGFloat
    var orbiterAngle: CGFloat?
    var direction: Int?
    var collision = false
    var fuel = true
    var didClick = false
    var clockwise = false
    var noMoon = false
    
    var orbitNode: SKSpriteNode
    var entityManager: EntityManager
    
    init(orbitSpeed: CGFloat, parentNode: SKSpriteNode, blackHoleOrbitSize: CGFloat, speed: CGFloat, entityManager: EntityManager, ship: SKSpriteNode?, orbitingNodes:[SKSpriteNode]) {
        
        self.entityManager = entityManager
        self.parentNode = parentNode
        self.orbiterSpeed = orbitSpeed
        self.orbiterRadius = blackHoleOrbitSize/2
        self.speed = speed
        
        if let s = ship {
            self.ship = s
        }
        
        self.orbitingNodes = orbitingNodes
        
        orbitNode = SKSpriteNode(texture: nil, size: CGSize(width: blackHoleOrbitSize, height: blackHoleOrbitSize))
        
        orbitNode.physicsBody?.isDynamic = false
        orbitNode.physicsBody?.collisionBitMask = CollisionCategory.None
        orbitNode.physicsBody?.categoryBitMask = CollisionCategory.None
        orbitNode.alpha = 0
        parentNode.addChild(orbitNode)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateOrbiter(dt: CFTimeInterval, orbiter: SKSpriteNode) {
        
        let orbiterNode = orbiter
        let Pi = CGFloat(M_PI)
        let DegreesToRadians = Pi / 180
        
        
        if clockwise == true {
            
            orbiterAngle = (getAngle(ofObjectOrbiting: orbiterNode) + orbiterSpeed * CGFloat(dt)).truncatingRemainder(dividingBy: 360)
        
            let x = cos(orbiterAngle! * DegreesToRadians) * orbiterRadius
            let y = sin(orbiterAngle! * DegreesToRadians) * orbiterRadius
        
            orbiterNode.position = CGPoint(x: parentNode.position.x + x, y: parentNode.position.y + y)
            orbiterNode.zRotation = (orbiterAngle!) * DegreesToRadians
        }
        else {
            
            orbiterAngle = (getAngle(ofObjectOrbiting: orbiter) - orbiterSpeed * CGFloat(dt)).truncatingRemainder(dividingBy: 360)
            let x = cos(orbiterAngle! * DegreesToRadians) * orbiterRadius
            let y = sin(orbiterAngle! * DegreesToRadians) * orbiterRadius
            
            orbiterNode.position = CGPoint(x: parentNode.position.x + x, y: parentNode.position.y + y)
            orbiterNode.zRotation = (orbiterAngle! + 180) * DegreesToRadians
        }
    }
    
    func leaveOrbit(){
        
        if didClick {
            
            collision = false
            
            if clockwise == false {
                
                let Pi = CGFloat(M_PI)
                let DegreesToRadians = Pi / 180
                
                guard let orbiterAngle = self.orbiterAngle else { return }
                
                let angle = (360 + orbiterAngle).truncatingRemainder(dividingBy: 360) - 90
                
                let x1 = cos((angle) * DegreesToRadians) * speed
                let y1 = sin((angle) * DegreesToRadians) * speed
                
                let velocityVector = CGVector(dx: x1, dy: y1)
                
                ship?.physicsBody?.velocity = velocityVector

            } else {
                
                let Pi = CGFloat(M_PI)
                let DegreesToRadians = Pi / 180
                
                guard let orbiterAngle = self.orbiterAngle else { return }
                
                let angle = (360 + orbiterAngle).truncatingRemainder(dividingBy: 360) + 90
                
                let x1 = cos((angle) * DegreesToRadians) * speed
                let y1 = sin((angle) * DegreesToRadians) * speed
                
                let velocityVector = CGVector(dx: x1, dy: y1)
                
                ship?.physicsBody?.velocity = velocityVector
            }
            
        }
        
        if !fuel {
            
            collision = false
            
            let Pi = CGFloat(M_PI)
            let DegreesToRadians = Pi / 180
            
            let angle = (360 + (orbiterAngle)!).truncatingRemainder(dividingBy: 360) - 180
            
            let x1 = cos((angle) * DegreesToRadians) * speed
            let y1 = sin((angle) * DegreesToRadians) * speed
            
            let velocityVector = CGVector(dx: x1, dy: y1)
            
            ship?.physicsBody?.velocity = velocityVector
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {
            (timer) in
            
            self.didClick = false
        })
    }
    
    func getAngle(ofObjectOrbiting object: SKSpriteNode) -> CGFloat {
        
        let Pi = CGFloat(M_PI)
        let RadiansToDegrees = 180 / Pi
        
        let xShip = object.position.x
        let yShip = object.position.y
        let xBlackhole = parentNode.position.x
        let yBlackhole = parentNode.position.y
        
//        print(atan2(yShip-yBlackhole, xShip-xBlackhole) * RadiansToDegrees + 180)
    
        return atan2(yShip-yBlackhole, xShip-xBlackhole) * RadiansToDegrees
    }
    
    func setupRotationDirection(object: SKSpriteNode, dt: CFTimeInterval) {
        
        let Pi = CGFloat(M_PI)
        let DegreesToRadians = Pi / 180
        
        orbiterAngle = (getAngle(ofObjectOrbiting: object)+180)
        
        
        let clockwiseRotation = (orbiterAngle! + 180) * DegreesToRadians
        let counterClockwiseRotation = (orbiterAngle!) * DegreesToRadians
        
        
        let option1 = abs((object.zRotation)+90 - clockwiseRotation)
        let option2 = abs((object.zRotation)+90 - counterClockwiseRotation)
        
        if option1 < option2 {
            
            clockwise = true
        }
            
        else {
            
            clockwise = false
        }
    }
    
    override func update(deltaTime: CFTimeInterval) {
        
        if orbitingNodes.count == 0 {
            
            if let shipNode = ship {
                if self.orbitNode.intersects(shipNode) && !self.didClick && fuel && entityManager.gameStarted() {
                    
                    if collision == false {
                        
                        setupRotationDirection(object: shipNode, dt: deltaTime)
                        collision = true
                        
                    } else {
                        
                        guard let emitter = entityManager.getEmitter() else {
                            print("particle not found")
                            return
                        }
                        
                        emitter.particleAlpha = 1
                        entityManager.shipIsOrbiting(isOrbiting: true)
                        shipNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        updateOrbiter(dt: deltaTime, orbiter: shipNode)
                        
                        
                    }
                } else {
                    
                    collision = false
                }
            }
            
            if !fuel {
                
                leaveOrbit()
            }
        } else {
            
            if entityManager.gameStarted(){
                
                for i in 0..<orbitingNodes.count {
                    
                    updateOrbiter(dt: deltaTime, orbiter: orbitingNodes[i])
                }
            }
            
            if let shipNode = ship {
                
                if self.orbitNode.intersects(shipNode) && entityManager.gameStarted() {
                    
                    //entityManager.shipIsOrbiting(isOrbiting: true)
                    shipNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    updateOrbiter(dt: deltaTime, orbiter: shipNode)
                    
                }
            }
        }
    }
}




















