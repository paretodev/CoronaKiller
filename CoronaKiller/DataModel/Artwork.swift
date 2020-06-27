//
//  Artwork.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/11.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import MapKit

class Artwork : NSObject, MKAnnotation{
    
    // < properties >
    let coordinate: CLLocationCoordinate2D
    let title: String?
    var subtitle: String?
    var stockLevel: String?
    
    // 다른 속성에 따라 계산되는 속성
    var markerTintColor: UIColor  {
      switch stockLevel {
      case "plenty":
        return .green
      case "some":
        return .yellow
      case "few":
        return .red
      default:
        return .black
      }
    }
    
    // initializer
    init(
      title: String,
      subtitle: String?,
      coordinate: CLLocationCoordinate2D,
      stockLevel : String?
    ) {
      self.title = title
      self.subtitle = subtitle
      self.coordinate = coordinate
      self.stockLevel = stockLevel
      super.init()
    }

}
