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
    
    var speed: Double
    var maxSpeed: Double
    var acceleration: Double
    
    init(speed: Double, maxSpeed: Double, acceleration: Double) {
        
        self.speed = speed
        self.maxSpeed = maxSpeed
        self.acceleration = acceleration
        super.init()
    }
    
    func setupEntityDependentProperties() {
        if let spriteComponent = entity?.spriteComponent {
            spriteComponent.physicsBody?.isDynamic = true
            spriteComponent.speed = CGVector(dx: 0.0, dy: self.speed)
            spriteComponent.physicsBody?.allowsRotation = true
        }
    }
    
    func accelerate(forThisManySeconds seconds: Double) {
        let newSpeed = speed + acceleration*seconds
        speed = (maxSpeed < newSpeed) ? maxSpeed : newSpeed
    }
    
    func rotate() {
        guard let sprite = entity?.spriteComponent else { return }
        let velocity = sprite.node.physicsBody!.velocity
        let angle = atan2f(Float(velocity.dy), Float(velocity.dx))
        print(angle)
        sprite.node.zRotation = angle.minusPi2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        print("Component update")
        self.rotate()
    }
    
}
