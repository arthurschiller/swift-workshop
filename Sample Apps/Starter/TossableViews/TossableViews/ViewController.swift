//
//  ViewController.swift
//  TossableViews
//
//  Created by Arthur Schiller on 26.07.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import UIKit

/* remove landscape support for now */
class ViewController: UIViewController {

    @IBOutlet weak var tossableView: Ellipse!
    
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    
    var collision: UICollisionBehavior?

    var panGesture: UIPanGestureRecognizer?
    
    /* Added Code Step 6 */
    var attach: UIAttachmentBehavior?

    /* Added Code Step 7 */
    var push: UIPushBehavior?
    var snap: UISnapBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDynamics()
        setupPanGestureRecognizer()
        setupTapGestureRecognizer()
    }
    
    private func setupDynamics() {
        
        // Instantiates the animator
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Instantiates the Gravity Behavior and assigns the box to it
        gravity = UIGravityBehavior(items: [tossableView])

        // Instantiates the Collision Behavior and assigns the box to it
        collision = UICollisionBehavior(items: [tossableView])
        collision!.translatesReferenceBoundsIntoBoundary = true
        
        
        // There we go!
        animator?.addBehavior(gravity!)
        animator?.addBehavior(collision!)

        push = UIPushBehavior(items: [tossableView], mode: UIPushBehaviorMode.Instantaneous)
        push?.setAngle(CGFloat(M_PI / -2), magnitude: 10)
        
        
        /* Added code last step */
        snap = UISnapBehavior(item: tossableView, snapToPoint: CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds)))
    }
    
    private func setupPanGestureRecognizer() {
        // Instantiates the Pan Gesture Recognizers and adds it to the greenBox instance
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panning(_:)))
        tossableView.addGestureRecognizer(panGesture)
    }

    private func setupTapGestureRecognizer() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.onTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func onTap(tap: UITapGestureRecognizer) {
        
        animator?.removeBehavior(snap!)
        
        push?.active = false
        snap?.snapPoint = tap.locationInView(view)
        animator?.addBehavior(snap!)
        push?.active = true
    }
    
    func panning(pan: UIPanGestureRecognizer) {
        
        print("Our box is panning...")
        
        let location = pan.locationInView(view)
        let touchLocation = pan.locationInView(tossableView)
        
        switch pan.state {
        
        case .Began:
            //Removes all the behaviors attached to the animators for now
            self.animator!.removeAllBehaviors()
            
            let offset = UIOffsetMake(touchLocation.x - CGRectGetMidX(tossableView.bounds), touchLocation.y - CGRectGetMidY(tossableView.bounds))
            attach = UIAttachmentBehavior(item: tossableView, offsetFromCenter: offset, attachedToAnchor: location)
            animator?.addBehavior(attach!)
            
        case .Changed:
            attach!.anchorPoint = location
            
        case .Ended:
        
            animator?.removeBehavior(attach!)
            
            let itemBehavior = UIDynamicItemBehavior(items: [tossableView])
            itemBehavior.addLinearVelocity(pan.velocityInView(view), forItem: tossableView)
            itemBehavior.angularResistance = 0
            itemBehavior.elasticity = 0.8
            animator?.addBehavior(itemBehavior)
        
            animator?.addBehavior(gravity!)
            animator?.addBehavior(collision!)
            
        default:
            break
        }
    }
}

class Ellipse: UIView {
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = CGRectGetWidth(bounds) / 2
    }
}

// Reference Code
/*
 switch pan.state {
 
 case .Began:
 //Removes all the behaviors attached to the animators for now
 self.animator!.removeAllBehaviors()
 tossableView.center = location
 
 case .Changed:
 tossableView.center = location
 
 case .Ended:
 // What should happen when the box is released...
 animator?.addBehavior(gravity!)
 animator?.addBehavior(collision!)
 
 default:
 break
 }
*/