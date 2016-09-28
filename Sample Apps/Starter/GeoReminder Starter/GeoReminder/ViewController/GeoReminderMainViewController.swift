//
//  GeoReminderMainViewController.swift
//  GeoReminder
//
//  Created by Arthur Schiller on 28.07.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import UIKit
import MapKit

let kSavedItemsKey = "savedItems"

class GeoReminderMainViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var geoReminders = [GeoReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        geoReminders = []
        
        if let savedItems = NSUserDefaults.standardUserDefaults().arrayForKey(kSavedItemsKey) {
            for savedItem in savedItems {
                if let geoReminder = NSKeyedUnarchiver.unarchiveObjectWithData(savedItem as! NSData) as? GeoReminder {
                    addGeoReminder(geoReminder)
                }
            }
        }
    }
    
    func saveAllGeotifications() {
        let items = NSMutableArray()
        for geoReminder in geoReminders {
            let item = NSKeyedArchiver.archivedDataWithRootObject(geoReminder)
            items.addObject(item)
        }
        NSUserDefaults.standardUserDefaults().setObject(items, forKey: kSavedItemsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    // MARK: Functions that update the model/associated views with geotification changes
    
    func addGeoReminder(geoReminder: GeoReminder) {
        geoReminders.append(geoReminder)
        mapView.addAnnotation(geoReminder)
        addRadiusOverlayForGeoReminder(geoReminder)
        updateGeoRemindersCount()
    }
    
    func removeGeoReminder(geoReminder: GeoReminder) {
        if let indexInArray = geoReminders.indexOf(geoReminder) {
            geoReminders.removeAtIndex(indexInArray)
        }
        
        mapView.removeAnnotation(geoReminder)
        addRadiusOverlayForGeoReminder(geoReminder)
        updateGeoRemindersCount()
    }
    
    func updateGeoRemindersCount() {
        title = "GeoReminders – (\(geoReminders.count))"
    }
    
    
    // MARK: Map overlay functions
    
    func addRadiusOverlayForGeoReminder(geoReminder: GeoReminder) {
        mapView?.addOverlay(MKCircle(centerCoordinate: geoReminder.coordinate, radius: geoReminder.radius))
    }
    
    func removeRadiusOverlayForGeoReminder(geoReminder: GeoReminder) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        if let overlays = mapView?.overlays {
            for overlay in overlays {
                if let circleOverlay = overlay as? MKCircle {
                    let coord = circleOverlay.coordinate
                    if coord.latitude == geoReminder.coordinate.latitude && coord.longitude == geoReminder.coordinate.longitude && circleOverlay.radius == geoReminder.radius {
                        mapView?.removeOverlay(circleOverlay)
                        break
                    }
                }
            }
        }
    }
    
    // MARK: Navigation Functions
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addGeoReminder" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let viewController = navigationController.viewControllers.first as! AddGeoReminderViewController
            viewController.delegate = self
        }
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
    }
}

extension GeoReminderMainViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeoReminder"
        if annotation is GeoReminder {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .Custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "DeleteGeotification")!, forState: .Normal)
                annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = UIColor.purpleColor()
            circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
            return circleRenderer
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        let geoReminder = view.annotation as! GeoReminder
        removeGeoReminder(geoReminder)
        saveAllGeotifications()
    }
}

extension GeoReminderMainViewController: AddGeoReminderViewControllerDelegate {
    
    func addGeoReminderViewController(controller: AddGeoReminderViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        // Add geotification
        let geoReminder = GeoReminder(coordinate: coordinate, radius: radius, identifier: identifier, note: note, eventType: eventType)
        addGeoReminder(geoReminder)
        saveAllGeotifications()
    }
}