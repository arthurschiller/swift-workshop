//
//  Particles.swift
//  ParticleBurst
//
//  Created by Arthur Schiller on 26.07.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import UIKit

class ParticleView: UIView {
    
    var emitterLayer: CAEmitterLayer!
    var emitterCell: CAEmitterCell!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.configureParticleEmitter()
        self.emitterLayer.emitterPosition = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        self.userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func layerClass() -> AnyClass {
        return CAEmitterLayer.self
    }
    
    func startEmitting() {
        self.emitterLayer.birthRate = 1
    }
    
    func stopEmitting() {
        self.emitterLayer.birthRate = 0
    }
    
    func burstAtLocation(location: CGPoint, withColor color: CGColor) {
        
        emitterLayer.emitterPosition = location
        emitterLayer.seed = UInt32.random(0, upper: 163980609)
        emitterCell.color = color
        
        self.startEmitting()
        
        delay(0.2) { [weak self] in
            if let _self = self {
                _self.stopEmitting()
            }
        }
    }
    
    func configureParticleEmitter() {
        
        let particleColor = UIColor.whiteColor()
        
        self.emitterLayer = self.layer as! CAEmitterLayer
        
        emitterLayer.name = "emitterLayer"
        emitterLayer.emitterZPosition = 0
        
        emitterLayer.emitterSize = CGSize(width: 1, height: 1)
        emitterLayer.emitterDepth = 0.00
        
        emitterLayer.renderMode = kCAEmitterLayerBackToFront
        //emitterLayer.renderMode = kCAEmitterLayerAdditive
        
        emitterLayer.seed = 163980609
        emitterLayer.birthRate = 0
        
        // Create the emitter Cell
        self.emitterCell = CAEmitterCell()
        
        emitterCell.name = "circleParticleCell"
        emitterCell.enabled = true
        
        emitterCell.contents = makeParticleSpriteWithColor(particleColor)
        emitterCell.contentsRect = CGRectMake(0.00, 0.00, 1.00, 1.00)
        
        emitterCell.magnificationFilter = kCAFilterLinear
        emitterCell.minificationFilter = kCAFilterLinear
        emitterCell.minificationFilterBias = 0.00
        
        emitterCell.scale = 0.05
        emitterCell.scaleRange = 0.11
        emitterCell.scaleSpeed = 0.99
        
        //emitterCell.color = UIColor.yellowColor().CGColor
        emitterCell.redRange = 1
        emitterCell.greenRange = 1
        emitterCell.blueRange = 1
        emitterCell.alphaRange = 1
        
        emitterCell.redSpeed = 0
        emitterCell.greenSpeed = 0
        emitterCell.blueSpeed = 0
        emitterCell.alphaSpeed = -1.75
        
        emitterCell.lifetime = 3.00
        emitterCell.lifetimeRange = 500.00
        emitterCell.birthRate = 300.00
        emitterCell.velocity = 30.00
        emitterCell.velocityRange = 400.00
        emitterCell.xAcceleration = 5.00
        emitterCell.yAcceleration = 337.60
        emitterCell.zAcceleration = 236.00
        
        // these values are in radians, in the UI they are in degrees
        emitterCell.spin = 6.20
        emitterCell.spinRange = 4.80
        emitterCell.emissionLatitude = 2.85
        emitterCell.emissionLongitude = 3.14
        emitterCell.emissionRange = 6.00
        
        emitterLayer.emitterCells = [emitterCell]
    }
    
    func makeParticleSpriteWithColor(color: UIColor) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), false, 1)
        let context = UIGraphicsGetCurrentContext()!
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, 10, 10))
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillPath(context)
        let particleSprite = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return particleSprite.CGImage!
    }
}