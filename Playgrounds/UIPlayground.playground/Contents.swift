//: Playground - noun: a place where people can play

// CREDITS: http://www.techotopia.com/index.php/An_Introduction_to_Xcode_7_Playgrounds

import UIKit
// for iOS UIKit, for mac cocoa, share a lot
import XCPlayground // for live views

/* some example */
var x = 10

for index in 1...20 {
    
    let y = index * --x // x -= 1
}

let canvas = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
canvas.backgroundColor = UIColor.whiteColor()
XCPlaygroundPage.currentPage.liveView = canvas

let title = UILabel(frame: CGRectMake(50, 50, 100, 20))
title.text = "Hello world"
title.textColor = UIColor.blueColor()
title.textAlignment = NSTextAlignment.Center
canvas.addSubview(title)

let button = UIButton(frame: CGRectMake(50, 100, 100, 50))
button.backgroundColor = UIColor.whiteColor()
button.layer.cornerRadius = 10
button.setTitle("Button", forState: UIControlState.Normal)
button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
canvas.addSubview(button)

button.layer.cornerRadius = 10
button.layer.shadowColor = UIColor.blackColor().CGColor
button.layer.shadowOpacity = 10
button.layer.shadowOffset = CGSize(width: 10, height: 10)
button.layer.shadowRadius = 10


// ## some animations
UIView.animateWithDuration(0.5, animations: {
    button.transform = CGAffineTransformMakeTranslation(40, 40)
})

UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        button.transform = CGAffineTransformMakeScale(0.5, 0.5)
    }, completion: { _ in
        print("fired after completion")
})

UIView.animateWithDuration(0.8, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
    button.transform = CGAffineTransformMakeRotation(40)
}, completion: nil)
