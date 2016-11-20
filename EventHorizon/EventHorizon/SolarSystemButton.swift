//
//  SolarSystemButton.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 14/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//
import SpriteKit

class SolarSystemButton : SKSpriteNode {
    
    let onButtonPress: () -> ()
    
    init(iconName: String, text: String, view: SKView, onButtonPress: @escaping () -> ()) {
        
        self.onButtonPress = onButtonPress
        
        let texture = SKTexture(imageNamed: "sistemaSolar")
        super.init(texture: texture, color: SKColor.white, size: view.frame.size)

        self.position = view.center
        self.size = CGSize(width: 800, height: 550)
        let label = SKLabelNode(fontNamed: "Courier-Bold")
        label.fontSize = 50
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width * 0.25, y: 0)
        label.zPosition = 1
        label.verticalAlignmentMode = .center
        label.text = text
        self.addChild(label)
        
        isUserInteractionEnabled = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onButtonPress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
