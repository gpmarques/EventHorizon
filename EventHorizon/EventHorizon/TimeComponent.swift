//
//  TimeComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 21/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class TimeComponent: GKComponent {
    
    var timeLabel: SKLabelNode
    var timer: Timer
    var months: Int {
        didSet {
            years = max(years + months.years, years)
        }
    }
    var years: Int
    var timeRate: Int
    var entityManager: EntityManager
    
    init(entityManager: EntityManager) {
        
        self.entityManager = entityManager
        months = 0
        timeRate = 1
        years = months.years
        timer = Timer()
        timeLabel = SKLabelNode(fontNamed: "Courier-Bold")
        timeLabel.fontSize = entityManager.scene.frame.width/50
        timeLabel.text = self.years.stringfyYear + " - " + self.months.stringfyMonth
        timeLabel.position = CGPoint(x: entityManager.scene.frame.width - entityManager.scene.frame.width/4.5,
                                     y: entityManager.scene.frame.height/26)
        timeLabel.zPosition = 3
        timeLabel.name = "timeLabel"
        
        entityManager.addToScene(thisNode: timeLabel)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// dilation handling
extension TimeComponent {
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.months += self.timeRate
            self.months = self.months.reset
            self.timeLabel.text = self.years.stringfyYear + " - " + self.months.stringfyMonth
        })
    }
    
    func dilateOrbitAndMovement(withRate rate: CGFloat) {
        
        entityManager.entities.forEach({ entity in
            
            if entity.spriteComponent?.node.name == "Objective"
                || entity.spriteComponent?.node.name == "Planet" {
                
                if let orbit = entity.component(ofType: OrbitComponent.self) {
                    orbit.orbiterSpeed *= rate;
                }
                
                if let mov = entity.component(ofType: MovementComponent.self) {
                    print(entity.ClassType)
                    mov.velocity = CGVector(dx: mov.velocity.dx*rate, dy: mov.velocity.dy*rate)
                }
                
            }
            
            
        })
    }
    
    func timeDilation() {
        timeRate = 2
    }
    
    func normalizeTimeRate() {
        timeRate = 1
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
}

extension TimeComponent {
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if entityManager.isShipOrbiting() && timeRate == 1 {
            timeDilation()
            dilateOrbitAndMovement(withRate: CGFloat(timeRate+3))
        }
        if !entityManager.isShipOrbiting() && timeRate == 2 {
            normalizeTimeRate()
            dilateOrbitAndMovement(withRate: CGFloat(timeRate)/5)
        }
        
    }
    
    
}

