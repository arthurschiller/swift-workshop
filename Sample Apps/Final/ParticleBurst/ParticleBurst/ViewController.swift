//
//  ViewController.swift
//  ParticleBurst
//
//  Created by Arthur Schiller on 30.06.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let particleColors: [UIColor] = [UIColor.greenColor(), UIColor.redColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.cyanColor()]

    var particleView: ParticleView {
        
        let view = ParticleView()
        view.frame = view.bounds
        self.view.addSubview(view)
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewWasTapped(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func viewWasTapped(gestureRecognizer: UITapGestureRecognizer) {
        
        let location = gestureRecognizer.locationInView(gestureRecognizer.view)
        //print("View was tapped at location: \(location)")
        let color = randomColor()
        print(color)
        particleView.burstAtLocation(location, withColor: color.CGColor)
    }
    
    private func randomColor() -> UIColor {
        return particleColors[Int(UInt32.random(0, upper: UInt32(particleColors.count)))]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        particleView.frame = view.bounds
    }
}