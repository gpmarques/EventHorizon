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
    var orbiterAngle: CGFloat
    
    init(shipNode: SKSpriteNode, shipSpeed: CGFloat, parentNode: SKSpriteNode ,blackHoleRadius: CGFloat, shipAngle: CGFloat) {
        self.parentNode = parentNode
        self.ship = shipNode
        self.orbiterSpeed = shipSpeed
        self.orbiterRadius = blackHoleRadius
        self.orbiterAngle = 0
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateOrbiter(dt: CFTimeInterval) {
        
        guard let shipNode = ship else { return }
        
        let Pi = CGFloat(M_PI)
        let DegreesToRadians = Pi / 180
        
        orbiterAngle = (orbiterAngle + orbiterSpeed * CGFloat(dt)).truncatingRemainder(dividingBy: 360)
        
        let x = cos(orbiterAngle * DegreesToRadians) * orbiterRadius
        let y = sin(orbiterAngle * DegreesToRadians) * orbiterRadius
        
        shipNode.position = CGPoint(x: shipNode.position.x + x, y: shipNode.position.y + y)
        shipNode.zRotation = -orbiterAngle * DegreesToRadians
    }
    
    func leaveOrbit(){
        
        
        
    }
    
    func getAngle(ship: SKSpriteNode) -> CGFloat {
        
        let Pi = CGFloat(M_PI)
        let DegreesToRadians = Pi / 180
        
        let xShip = ship.position.x
        let yShip = ship.position.y
        let xBlackhole = parentNode.position.x
        let yBlackhole = parentNode.position.y
        
        print(atan((xShip-xBlackhole)/(yShip-yBlackhole)*DegreesToRadians))

        return atan((xShip-xBlackhole)/(yShip-yBlackhole)*DegreesToRadians)
    }
    
    override func update(deltaTime currentTime: TimeInterval) {
        
        // to compute velocities we need delta time to multiply by points per second
        // SpriteKit returns the currentTime, delta is computed as last called time - currentTime
        let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
        lastUpdateTime = currentTime
        updateOrbiter(dt: deltaTime)
        
    }
    
}
