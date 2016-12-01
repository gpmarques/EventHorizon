//
//  Extensions.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 08/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension GKEntity {
    var spriteComponent: SpriteComponent? {
        return self.component(ofType: SpriteComponent.self)
    }
    
    var ClassType: AnyClass {
        return self.classForCoder.self
    }
}

extension CGVector {
    var angle: Float {
        return atan2f(Float(self.dy),
                      Float(self.dx))
    }    
}

extension Float {
    var minusPi2:CGFloat {
        return CGFloat(Double(self) - M_PI_2)
    }
}

extension EntityManager {
    func find(entityOfType entityType: AnyClass) -> GKEntity? {
        return entities.first(where: { $0.isKind(of: entityType) })
    }
    
    func find(entityWithName name: String) -> GKEntity? {
        return entities.first(where: { $0.spriteComponent?.node.name == name })
    }
    
    var getScene: SKScene {
        return self.scene
    }
}

extension SpriteComponent {
    var physicsBody: SKPhysicsBody? {
        get {
            return self.node.physicsBody
        }
        set(newPhysicsBody) {
            self.node.physicsBody = newPhysicsBody
        }
    }
}

extension Int {
    var years: Int { return self/12 }
    var reset: Int { return (self >= 12) ? 1 : self}
    var stringfyYear: String {
        return (self>1 || self == 0) ? "\(self) years" : "\(self) year" }
    var stringfyMonth: String {
        return (self>1 || self == 0) ? "\(self) months" : "\(self) month" }
}

extension CGPoint {
    
    func isOutOfBounds(viewWidth width: CGFloat, viewHeight height: CGFloat) -> Bool {
        
        if self.x < -width/5 || self.x > width + width/5 ||
            self.y < -height/5 || self.y > height + height/5 {
            return true
        } else {
            return false
        }
        
    }
    
}


