//
//  focusStoresInfoSet.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/14.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import Combine
import MapKit

class storesStockInfoSet: ObservableObject {
    @Published var count: Int = 0
    @Published var stores: [ Store ] = []
}
