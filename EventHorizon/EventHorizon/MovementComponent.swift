//
//  MovementComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    
    var velocity: CGVector
    var speed: Double
    var maxSpeed: Double
    var acceleration: Double
    var angle: Float
    
    init(speed: Double, maxSpeed: Double, acceleration: Double, parentNode: SKSpriteNode) {
        
        self.speed = speed
        self.maxSpeed = maxSpeed
        self.acceleration = acceleration
        self.angle = 0
        velocity = CGVector(dx: 0.0, dy: self.speed)
        parentNode.physicsBody?.isDynamic = false
        parentNode.physicsBody?.velocity = velocity
        parentNode.physicsBody?.allowsRotation = true
        
        super.init()
    }
    
    func accelerate(forThisManySeconds seconds: Double) {
        let newSpeed = speed + acceleration*seconds
        speed = (maxSpeed < newSpeed) ? maxSpeed : newSpeed
    }
    
    func rotate() {
        guard let sprite = entity?.spriteComponent else {
            print("MovementComponent Error"); return }
        guard let velocity = sprite.node.physicsBody?.velocity else {
            print("MovementComponent Error"); return }
        
        angle = velocity.angle
        sprite.node.zRotation = angle.minusPi2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        self.rotate()
    }
    
}
