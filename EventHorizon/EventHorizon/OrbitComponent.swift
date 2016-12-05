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
    
    var orbitNode: SKSpriteNode
    var entityManager: EntityManager
    
    init(orbitSpeed: CGFloat, parentNode: SKSpriteNode, blackHoleOrbitSize: CGFloat, speed: CGFloat, entityManager: EntityManager) {
        
        self.entityManager = entityManager
        self.parentNode = parentNode
        self.orbiterSpeed = orbitSpeed
        self.orbiterRadius = blackHoleOrbitSize/2
        self.speed = speed
        
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
    
    func updateOrbiter(dt: CFTimeInterval, ship: SKSpriteNode) {
        
        let shipNode = ship
        let Pi = CGFloat(M_PI)
        let DegreesToRadians = Pi / 180
        
        
        if clockwise == true {
            
            orbiterAngle = (getAngle(ofObjectOrbiting: ship) + orbiterSpeed * CGFloat(dt)).truncatingRemainder(dividingBy: 360)
        
            let x = cos(orbiterAngle! * DegreesToRadians) * orbiterRadius
            let y = sin(orbiterAngle! * DegreesToRadians) * orbiterRadius
        
            shipNode.position = CGPoint(x: parentNode.position.x + x, y: parentNode.position.y + y)
            shipNode.zRotation = (orbiterAngle!) * DegreesToRadians
        }
        else {
            
            orbiterAngle = (getAngle(ofObjectOrbiting: ship) - orbiterSpeed * CGFloat(dt)).truncatingRemainder(dividingBy: 360)
            let x = cos(orbiterAngle! * DegreesToRadians) * orbiterRadius
            let y = sin(orbiterAngle! * DegreesToRadians) * orbiterRadius
            
            shipNode.position = CGPoint(x: parentNode.position.x + x, y: parentNode.position.y + y)
            shipNode.zRotation = (orbiterAngle! + 180) * DegreesToRadians
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
                
                
            }
            else {
                
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
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {
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
        
        return atan2(yShip-yBlackhole, xShip-xBlackhole) * RadiansToDegrees
    }
    
    func setupRotationDirection(object: SKSpriteNode, dt: CFTimeInterval) {
        
        let Pi = CGFloat(M_PI)
        let DegreesToRadians = Pi / 180
        
        orbiterAngle = (getAngle(ofObjectOrbiting: ship!)).truncatingRemainder(dividingBy: 360)
        
        let clockwiseRotation = (orbiterAngle! + 180) * DegreesToRadians
        let counterClockwiseRotation = (orbiterAngle!) * DegreesToRadians
        
        print((ship?.zRotation)! - abs(clockwiseRotation))
        print((ship?.zRotation)! - abs(counterClockwiseRotation))
        
        if abs((ship?.zRotation)! - abs(clockwiseRotation)) < abs((ship?.zRotation)! - abs(counterClockwiseRotation)) {
            
            clockwise = true
        }
            
        else {
            
            clockwise = false
        }
    }
    
    override func update(deltaTime: CFTimeInterval) {
        
        guard let node = entityManager.getShipNode() else { return }
        ship = node
        
        if  self.orbitNode.intersects(ship!) && !self.didClick && fuel && entityManager.gameStarted() {
            
            if collision == false {
                print("denis")
                setupRotationDirection(object: ship!, dt: deltaTime)
                collision = true
            }
            
            else {
                
                guard let emitter = entityManager.getEmitter() else {
                    print("particle not found")
                    return
                }
                
                emitter.particleAlpha = 1
                entityManager.shipIsOrbiting(isOrbiting: true)
                ship?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                updateOrbiter(dt: deltaTime, ship: ship!)
            }
        }
        
        if !fuel {
            
            leaveOrbit()
        }
    }
}
