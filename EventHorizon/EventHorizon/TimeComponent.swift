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
    
    init(entityManager: EntityManager) {
        
        months = 0
        timeRate = 1
        years = months.years
        timer = Timer()
        timeLabel = SKLabelNode(fontNamed: "Courier-Bold")
        timeLabel.fontSize = entityManager.scene.frame.width/50
        timeLabel.text = " "
        timeLabel.position = CGPoint(x: entityManager.scene.frame.width - entityManager.scene.frame.width/7,
                                     y: entityManager.scene.frame.height/26)
        entityManager.addToScene(thisNode: timeLabel)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.months += self.timeRate
            self.months = self.months.reset
            self.timeLabel.text = self.years.stringfyYear + " - " + self.months.stringfyMonth
        })
    }
    //modificar o update de tempo ao inves de incrementar mais por update /\/\/\/\
    
    
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
