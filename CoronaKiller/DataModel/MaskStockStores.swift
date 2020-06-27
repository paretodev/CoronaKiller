//
//  maskStockStores.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/27.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import Combine
import MapKit


// MARK: - MasksSales
struct storesStore: Codable {
    let count: Int
    let stores: [Store]
}

// MARK: - Store
struct Store: Codable {
    
    let name, type: String
    let addr, code : String
    let lat, lng: Double
    
    let created_at: String?
    let stock_at : String?
    let remain_stat: String?

}

