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
    let onButtonReleased: () -> ()
    
    init(iconName: String, text: String, view: SKView, size: CGSize, onButtonPress: @escaping () -> (), onButtonReleased: @escaping ()->()) {
        
        self.onButtonPress = onButtonPress
        self.onButtonReleased = onButtonReleased
        
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
        let action = SKAction.colorize(with: UIColor.black, colorBlendFactor: 0.5, duration: 0.01)
        let action2 = SKAction.scale(by: 0.9, duration: 0.1)
        let actionSequence = SKAction.sequence([action, action2])
        self.run(actionSequence)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onButtonReleased()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
