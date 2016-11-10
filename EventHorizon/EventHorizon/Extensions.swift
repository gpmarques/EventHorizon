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
    
    var gravityFieldCategory: UInt32? {
        get {
            return self.node.physicsBody?.fieldBitMask
        }
        set(category) {
            self.node.physicsBody?.fieldBitMask = category!
        }
    }
    
    var speed: CGVector? {
        get {
            return self.node.physicsBody?.velocity
        }
        set(speed) {
            self.node.physicsBody?.velocity = speed!
        }
    }
}

extension Float {
    var minusPi2:CGFloat {
        return CGFloat(Double(self) - M_PI_2)
    }
}
