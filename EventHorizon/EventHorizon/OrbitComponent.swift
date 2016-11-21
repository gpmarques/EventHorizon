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
    var collision = false
    var fuel = true
    var direction: Int?
    var didClick = false
    
    var orbitNode: SKSpriteNode
    
    
    init(orbitSpeed: CGFloat, parentNode: SKSpriteNode, blackHoleOrbitSize: CGFloat, speed: CGFloat) {
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
        
        print(collision)
        
        orbiterAngle = (getAngle(ofObjectOrbiting: ship) - orbiterSpeed * CGFloat(dt)).truncatingRemainder(dividingBy: 360)
        
        let x = cos(orbiterAngle! * DegreesToRadians) * orbiterRadius
        let y = sin(orbiterAngle! * DegreesToRadians) * orbiterRadius
        
        shipNode.position = CGPoint(x: parentNode.position.x + x, y: parentNode.position.y + y)
        shipNode.zRotation = (orbiterAngle! + 180) * DegreesToRadians
        //shipNode.children.first?.zRotation = shipNode.zRotation
    }
    
    func leaveOrbit(){
        
        if didClick == true {
            
            collision = false
            
            let Pi = CGFloat(M_PI)
            let DegreesToRadians = Pi / 180
            
            let angle = (360 + (orbiterAngle)!).truncatingRemainder(dividingBy: 360) - 90
            
            let x1 = cos((angle) * DegreesToRadians) * speed
            let y1 = sin((angle) * DegreesToRadians) * speed
            
            let velocityVector = CGVector(dx: x1, dy: y1)
            
            ship?.physicsBody?.velocity = velocityVector
        }
        
        if fuel == false {
            
            collision = false
            
            let Pi = CGFloat(M_PI)
            let DegreesToRadians = Pi / 180
            
            let angle = (360 + (orbiterAngle)!).truncatingRemainder(dividingBy: 360) - 180
            
            let x1 = cos((angle) * DegreesToRadians) * speed
            let y1 = sin((angle) * DegreesToRadians) * speed
            
            let velocityVector = CGVector(dx: x1, dy: y1)
            
            ship?.physicsBody?.velocity = velocityVector
        }
    }
    
    func getAngle(ofObjectOrbiting object: SKSpriteNode) -> CGFloat {
        
        let Pi = CGFloat(M_PI)
        let RadiansToDegree = 180 / Pi
        
        let xShip = object.position.x
        let yShip = object.position.y
        let xBlackhole = parentNode.position.x
        let yBlackhole = parentNode.position.y
        
        return atan2(yShip-yBlackhole, xShip-xBlackhole) * RadiansToDegree
    }
    
    func setupRotationDirection(object: SKSpriteNode) {
        
    }
    
    func manageParticle () {
        
        
    }
    
    override func update( deltaTime: CFTimeInterval) {
        
        guard (ship != nil) else {return}
        
        if collision == true {
            
            ship?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            updateOrbiter(dt: deltaTime, ship: ship!)
        }
    }
}
