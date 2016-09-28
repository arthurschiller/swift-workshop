//
//  GeoReminderMainViewController.swift
//  GeoReminder
//
//  Created by Arthur Schiller on 28.07.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let kSavedItemsKey = "savedItems"

class GeoReminderMainViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var geoReminders = [GeoReminder]()
    let locationManager = CLLocationManager() // Add this statement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        // 1
        locationManager.delegate = self
        // 2
        locationManager.requestAlwaysAuthorization()
        // 3
        loadAllGeotifications()
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
    
    func saveAllGeoReminders() {
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
        
        navigationItem.rightBarButtonItem?.enabled = (geoReminders.count < 20)
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
    
    // MARK: Geofencing
    func regionWithGeoReminder(geoReminder: GeoReminder) -> CLCircularRegion {

        let region = CLCircularRegion(center: geoReminder.coordinate, radius: geoReminder.radius, identifier: geoReminder.identifier)

        region.notifyOnEntry = (geoReminder.eventType == .OnEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoringGeoReminder(geoReminder: GeoReminder) {

        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
            return
        }

        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            showSimpleAlertWithTitle("Warning", message: "Your geoReminder is saved but will only be activated once you grant GeoReminder permission to access the device location.", viewController: self)
        }

        let region = regionWithGeoReminder(geoReminder)

        locationManager.startMonitoringForRegion(region)
    }
    
    func stopMonitoringGeotification(geoReminder: GeoReminder) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == geoReminder.identifier {
                    locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
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
    
    // MARK: Other mapview functions
    
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        zoomToUserLocationInMapView(mapView)
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
        stopMonitoringGeotification(geoReminder)
        removeGeoReminder(geoReminder)
        saveAllGeoReminders()
    }
}

extension GeoReminderMainViewController: AddGeoReminderViewControllerDelegate {
    
//    func addGeoReminderViewController(controller: AddGeoReminderViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
//        
//        controller.dismissViewControllerAnimated(true, completion: nil)
//        // Add geotification
//        let geoReminder = GeoReminder(coordinate: coordinate, radius: radius, identifier: identifier, note: note, eventType: eventType)
//        addGeoReminder(geoReminder)
//        saveAllGeotifications()
//    }

    func addGeoReminderViewController(controller: AddGeoReminderViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)

        let clampedRadius = (radius > locationManager.maximumRegionMonitoringDistance) ? locationManager.maximumRegionMonitoringDistance : radius
        
        let geoReminder = GeoReminder(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)

        addGeoReminder(geoReminder)
        startMonitoringGeoReminder(geoReminder)
        saveAllGeoReminders()
    }

}

extension GeoReminderMainViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
}