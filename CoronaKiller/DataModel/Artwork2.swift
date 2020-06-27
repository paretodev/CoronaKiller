//
//  Artwork2.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/14.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import MapKit

class Artwork2 : NSObject, MKAnnotation{
    
    // < properties >
    let coordinate: CLLocationCoordinate2D
    let title: String?
    var subtitle: String?
    var pollutionLevel: String?
    
    // 다른 속성에 따라 계산되는 속성
    var markerTintColor: UIColor  {
      switch pollutionLevel {
        
      case "2":
        return .yellow
      case "3":
        return .black
      case "4":
        return .green
      default:
        return .red
      }
        
    }
    
    // initializer
    init(
      title: String,
      subtitle: String?,
      coordinate: CLLocationCoordinate2D,
      pollutionLevel : String?
    ) {
      self.title = title
      self.subtitle = subtitle
      self.coordinate = coordinate
      self.pollutionLevel = pollutionLevel
      super.init()
    }

}
