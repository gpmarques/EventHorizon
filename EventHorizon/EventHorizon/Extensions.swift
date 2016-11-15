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
