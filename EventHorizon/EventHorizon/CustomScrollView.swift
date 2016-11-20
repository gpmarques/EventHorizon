//
//  CustomScrollView.swift
//  EventHorizon
//
//  Created by Rodrigo Labronici on 17/11/16.
//  Copyright © 2016 Guilherme Marques. All rights reserved.
//

import SpriteKit

/// Scroll direction
enum ScrollDirection {
    case vertical // cases start with small letters as I am following Swift 3 guildlines.
    case horizontal
}

class CustomScrollView: UIScrollView {
    
    // MARK: - Static Properties
    
    /// Touches allowed
    static var disabledTouches = false
    
    /// Scroll view
    fileprivate static var scrollView: UIScrollView!
    
    // MARK: - Properties
    
    /// Current scene
    let currentScene: SKScene
    
    /// Moveable node
    fileprivate let moveableNode: SKNode
    
    /// Scroll direction
    fileprivate let scrollDirection: ScrollDirection
    
    /// Touched nodes
    fileprivate var nodesTouched = [AnyObject]()
    
    // MARK: - Init
    init(frame: CGRect, scene: SKScene, moveableNode: SKNode) {
        self.currentScene = scene
        self.moveableNode = moveableNode
        //self.scrollDirection = scrollDirection
        self.scrollDirection = .vertical
        super.init(frame: frame)
        
        CustomScrollView.scrollView = self
        self.frame = frame
        delegate = self
        indicatorStyle = .white
        isScrollEnabled = true
        isUserInteractionEnabled = true
        //canCancelContentTouches = false
        //self.minimumZoomScale = 1
        //self.maximumZoomScale = 3
        
        if scrollDirection == .horizontal {
            let flip = CGAffineTransform(scaleX: -1,y: -1)
            transform = flip
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Touches
extension CustomScrollView {
    
    /// Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            guard !CustomScrollView.disabledTouches else { return }
            
            /// Call touches began in current scene
            currentScene.touchesBegan(touches, with: event)
            
            /// Call touches began in all touched nodes in the current scene
            nodesTouched = currentScene.nodes(at: location)
            for node in nodesTouched {
                node.touchesBegan(touches, with: event)
            }
        }
    }
    
    /// Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            guard !CustomScrollView.disabledTouches else { return }
            
            /// Call touches moved in current scene
            currentScene.touchesMoved(touches, with: event)
            
            /// Call touches moved in all touched nodes in the current scene
            nodesTouched = currentScene.nodes(at: location)
            for node in nodesTouched {
                node.touchesMoved(touches, with: event)
            }
        }
    }
    
    /// Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            guard !CustomScrollView.disabledTouches else { return }
            
            /// Call touches ended in current scene
            currentScene.touchesEnded(touches, with: event)
            
            /// Call touches ended in all touched nodes in the current scene
            nodesTouched = currentScene.nodes(at: location)
            for node in nodesTouched {
                node.touchesEnded(touches, with: event)
            }
        }
    }
    
    /// Cancelled
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        
        for touch in touches! {
            let location = touch.location(in: currentScene)
            
            guard !CustomScrollView.disabledTouches else { return }
            
            /// Call touches cancelled in current scene
            currentScene.touchesCancelled(touches!, with: event)
            
            /// Call touches cancelled in all touched nodes in the current scene
            nodesTouched = currentScene.nodes(at: location)
            for node in nodesTouched {
                //node.touchesCancelled(touches!, withEvent: event)
                node.touchesCancelled(touches!, with: event)
            }
        }
    }
}

// MARK: - Touch Controls
extension CustomScrollView {
    
    /// Disable
    class func disable() {
        CustomScrollView.scrollView?.isUserInteractionEnabled = false
        CustomScrollView.disabledTouches = true
    }
    
    /// Enable
    class func enable() {
        CustomScrollView.scrollView?.isUserInteractionEnabled = true
        CustomScrollView.disabledTouches = false
    }
}

// MARK: - Delegates
extension CustomScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollDirection == .horizontal {
            moveableNode.position.x = scrollView.contentOffset.x
        } else {
            moveableNode.position.y = scrollView.contentOffset.y
        }
    }
}
