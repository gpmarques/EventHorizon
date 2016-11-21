//
//  TimeComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 21/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

extension Int {
    var years: Int { return self/12 }
    var reset: Int { return (self%12 == 0) ? 0 : self}
}

class TimeComponent: GKComponent {
    
    var timeLabel: SKLabelNode
    var timer: Timer
    var months: Int {
        didSet {
            years = max(years + months.years, years)
        }
    }
    var years: Int
    
    init(entityManager: EntityManager) {
        
        months = 0
        years = months.years
        timer = Timer()
        timeLabel = SKLabelNode(fontNamed: "SF-UI-Display-Ultralight")
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
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeIncrement), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.months += 1
            self.months = self.months.reset
            self.timeLabel.text = "\(self.years) years - \(self.months) months"
        })
    }
    
//    @objc private func timeIncrement() {
//        months += 1
//        months = months.reset
//        timeLabel.text = "\(years) years - \(months) months"
//    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
}
