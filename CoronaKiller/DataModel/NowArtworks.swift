//
//  NowArtworks.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/14.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import Combine
import MapKit

class NowArtworks: ObservableObject{
    @Published var artworksToDisplay: [Artwork] = []
}
