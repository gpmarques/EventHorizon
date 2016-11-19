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
    let entityManager: EntityManager
    let fullFuel: CGFloat
    var fuel: CGFloat {
        didSet {
            switch fuel {
            case 0..<30:
                fuelColor = UIColor.red
            case 30..<60:
                fuelColor = UIColor.yellow
            case 60...100:
                fuelColor = UIColor.green
            default:
                print("Out of Range")
            }
        }
    }
    var fuelColor: UIColor
    
    init(entityManager: EntityManager, rect: CGRect, fuel: CGFloat) {
        self.fuel = fuel
        self.fullFuel = fuel
        self.fuelBar = SKShapeNode(rect: rect, cornerRadius: rect.height/2)
        self.fuelBar.fillColor = UIColor.green
        self.fuelBar.strokeColor = UIColor.clear
        self.fuelColor = UIColor.green
        self.entityManager = entityManager
        entityManager.addToScene(thisNode: fuelBar)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spendFuel(_ spentFuel: CGFloat) -> Bool {
        
        fuel = max(fuel - spentFuel, 0)
        
        let fuelScale = fuel/fullFuel
        let scaleAction = SKAction.scaleX(to: fuelScale, duration: 0.5)
        fuelBar.fillColor = fuelColor
        fuelBar.run(SKAction.group([scaleAction]))
        
        return fuel == 0
    }
    
}
