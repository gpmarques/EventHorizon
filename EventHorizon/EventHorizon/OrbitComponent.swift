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
    
    var orbiterSpeed: CGFloat
    var orbiterRadius: CGFloat
    var orbiterAngle: CGFloat?
    var collision: Int = 0
    
    var OrbitNode: SKSpriteNode
    
    
    init(shipSpeed: CGFloat, parentNode: SKSpriteNode, blackHoleOrbitSize: CGFloat) {
        self.parentNode = parentNode
        self.orbiterSpeed = shipSpeed
        self.orbiterRadius = blackHoleOrbitSize/2
        
        OrbitNode = SKSpriteNode(texture: nil, size: CGSize(width: blackHoleOrbitSize, height: blackHoleOrbitSize))
        
        OrbitNode.physicsBody?.isDynamic = false
        OrbitNode.physicsBody?.collisionBitMask = CollisionCategory.None
        OrbitNode.physicsBody?.categoryBitMask = CollisionCategory.None
        OrbitNode.alpha = 0
        parentNode.addChild(OrbitNode)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateOrbiter(dt: CFTimeInterval, ship: SKSpriteNode) {
        
        let shipNode = ship
        let Pi = CGFloat(M_PI)
        let DegreesToRadians = Pi / 180
        //print(orbiterAngle!*DegreesToRadians)
        orbiterAngle = (getAngle(ofObjectOrbiting: ship) + orbiterSpeed * CGFloat(dt)).truncatingRemainder(dividingBy: 360)
        
        let x = cos(orbiterAngle! * DegreesToRadians) * orbiterRadius
        let y = sin(orbiterAngle! * DegreesToRadians) * orbiterRadius
        
        shipNode.position = CGPoint(x: parentNode.position.x + x, y: parentNode.position.y + y)
        shipNode.zRotation = orbiterAngle! * DegreesToRadians
    }
    
    func leaveOrbit(){
        
        
        
    }
    
    func getAngle(ofObjectOrbiting object: SKSpriteNode) -> CGFloat {
        
        let Pi = CGFloat(M_PI)
        let RadiansToDegree = 180 / Pi
        
        let xShip = object.position.x
        let yShip = object.position.y
        let xBlackhole = parentNode.position.x
        let yBlackhole = parentNode.position.y
        
        print(atan2(yShip-yBlackhole, xShip-xBlackhole)*RadiansToDegree)
        return atan2(yShip-yBlackhole, xShip-xBlackhole) * RadiansToDegree
    }
    
    override func update(deltaTime currentTime: TimeInterval) {
        
        let deltaTime = 1.0/60
        lastUpdateTime = currentTime
        
        guard (ship != nil) else {return}
        
        if collision == 1 {
            
            ship?.speed = 0
            updateOrbiter(dt: deltaTime, ship: ship!)
        }
    }
}
