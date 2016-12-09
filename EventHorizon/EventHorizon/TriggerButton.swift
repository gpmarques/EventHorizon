//
//  TriggerButton.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 23/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit

class TriggerButton : CustomButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        onButtonPress()
        self.run(actionPress)
        self.run(action)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        onButtonReleased()
        self.run(actionRelease)
        self.run(action2)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.run(actionRelease)
        self.run(action2)
    }
    
}
