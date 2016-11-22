//
//  SolarSystemButton.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 14/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//
import SpriteKit

class CustomButton : SKSpriteNode {
    
    let onButtonPress: () -> ()
    
    init(iconName: String, text: String, view: SKView, position: CGPoint, size: CGSize, onButtonPress: @escaping () -> ()) {
        
        self.onButtonPress = onButtonPress
        
        let texture = SKTexture(imageNamed: iconName)
        super.init(texture: texture, color: SKColor.white, size: view.frame.size)

        self.position = position
        self.size = size
        let label = SKLabelNode(fontNamed: "Courier-Bold")
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: -100)
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
