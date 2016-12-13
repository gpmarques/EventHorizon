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
    let fuelTank: SKShapeNode
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
        self.fuelTank = SKShapeNode(rect: CGRect(x: rect.minX, y: rect.minY - 0.5, width: rect.width + 0.1, height: rect.height + 0.5)  , cornerRadius: rect.height/2)
        self.fuelTank.strokeColor = UIColor.black
        self.fuelTank.lineWidth = 1
        self.fuelTank.fillColor = UIColor.darkGray
        self.fuelTank.zPosition = 3
        self.fuelTank.name = "fuelTank"
        
        self.fuelBar = SKShapeNode(rect: rect, cornerRadius: rect.height/2.1)
        self.fuelBar.fillColor = UIColor.green
        self.fuelBar.strokeColor = UIColor.clear
        self.fuelBar.zPosition = 4
        
        self.fuelColor = UIColor.green
        self.entityManager = entityManager
        
        self.fuelTank.addChild(fuelBar)
        entityManager.addToScene(thisNode: fuelTank)
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
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if entityManager.isShipOrbiting() {
            if spendFuel(1) {
                guard let blackHole = entityManager.find(entityOfType: BlackHole.self) as? BlackHole else { print("blackhole not found"); return }
                guard let orbit = blackHole.component(ofType: OrbitComponent.self) else { print("orbit not found"); return }
                orbit.fuel = false
            }
        }
        
    }
}
