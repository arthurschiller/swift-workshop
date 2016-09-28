//
//  Reminder.swift
//  From the Geotify Tutorial by RayWenderlich
//
//  Created by Ken Toh on 24/1/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let kGeoReminderLatitudeKey = "latitude"
let kGeoReminderLongitudeKey = "longitude"
let kGeoReminderRadiusKey = "radius"
let kGeoReminderIdentifierKey = "identifier"
let kGeoReminderNoteKey = "note"
let kGeoReminderEventTypeKey = "eventType"

enum EventType: Int {
  case OnEntry = 0
  case OnExit
}

class GeoReminder: NSObject, NSCoding, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var radius: CLLocationDistance
  var identifier: String
  var note: String
  var eventType: EventType

  var title: String? {
    if note.isEmpty {
      return "No Note"
    }
    return note
  }

  var subtitle: String? {
    let eventTypeString = eventType == .OnEntry ? "On Entry" : "On Exit"
    return "Radius: \(radius)m - \(eventTypeString)"
  }

  init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType) {
    self.coordinate = coordinate
    self.radius = radius
    self.identifier = identifier
    self.note = note
    self.eventType = eventType
  }

  // MARK: NSCoding

  required init?(coder decoder: NSCoder) {
    let latitude = decoder.decodeDoubleForKey(kGeoReminderLatitudeKey)
    let longitude = decoder.decodeDoubleForKey(kGeoReminderLongitudeKey)
    coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    radius = decoder.decodeDoubleForKey(kGeoReminderRadiusKey)
    identifier = decoder.decodeObjectForKey(kGeoReminderIdentifierKey) as! String
    note = decoder.decodeObjectForKey(kGeoReminderNoteKey) as! String
    eventType = EventType(rawValue: decoder.decodeIntegerForKey(kGeoReminderEventTypeKey))!
  }

  func encodeWithCoder(coder: NSCoder) {
    coder.encodeDouble(coordinate.latitude, forKey: kGeoReminderLatitudeKey)
    coder.encodeDouble(coordinate.longitude, forKey: kGeoReminderLongitudeKey)
    coder.encodeDouble(radius, forKey: kGeoReminderRadiusKey)
    coder.encodeObject(identifier, forKey: kGeoReminderIdentifierKey)
    coder.encodeObject(note, forKey: kGeoReminderNoteKey)
    coder.encodeInt(Int32(eventType.rawValue), forKey: kGeoReminderEventTypeKey)
  }
}
