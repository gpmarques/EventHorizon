//
//  FuelComponent.swift
//  EventHorizon
//
//  Created by Guilherme Marques on 05/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit
import GameplayKit

class FuelComponent: GKComponent {

    let fuelBar: SKShapeNode
    
    init(parentNode: SKSpriteNode, rect: CGRect) {
        fuelBar = SKShapeNode(rect: rect, cornerRadius: rect.height/2)
        let shader = SKShader(fileNamed: <#T##String#>)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
