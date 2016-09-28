//
//  AddGeoReminderViewController.swift
//  GeoReminder
//
//  Created by Arthur Schiller on 28.07.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import UIKit
import MapKit

protocol AddGeoReminderViewControllerDelegate {
    func addGeoReminderViewController(controller: AddGeoReminderViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
                                        radius: Double, identifier: String, note: String, eventType: EventType)
}

class AddGeoReminderViewController: UIViewController {
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var zoomButton: UIBarButtonItem!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainInputView: UIView!
    @IBOutlet weak var mainInputMaskView: UIView!
    
    @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: AddGeoReminderViewControllerDelegate!
    
    let cornerRadius: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAdditionalViewStyles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topLayoutGuideHeight = topLayoutGuide.length
        scrollView.contentInset.top = topLayoutGuideHeight
    }
    
    func setAdditionalViewStyles() {
        
        mainInputMaskView.layer.cornerRadius = cornerRadius
        mainInputMaskView.clipsToBounds = true
        
        mainInputView.layer.shadowOffset = CGSizeZero
        mainInputView.layer.shadowOpacity = 0.1
        mainInputView.layer.shadowRadius = 25
        mainInputView.layer.shadowPath = UIBezierPath(roundedRect: mainInputView.bounds, cornerRadius: cornerRadius).CGPath
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func onAdd(sender: AnyObject) {
        let coordinate = mapView.centerCoordinate
        let radius = (radiusTextField.text! as NSString).doubleValue
        let identifier = NSUUID().UUIDString
        let note = noteTextField.text
        let eventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? EventType.OnEntry : EventType.OnExit
        delegate!.addGeoReminderViewController(self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: eventType)
    }
    
    @IBAction private func onZoomToCurrentLocation(sender: AnyObject) {
        zoomToUserLocationInMapView(mapView)
    }
}
