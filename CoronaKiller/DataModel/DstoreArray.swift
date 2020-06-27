//
//  DstoreArray.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/05/16.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation

// 1. Make a data model for API3.

// MARK: - DstoreElement
struct DstoreElement: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}
// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}
// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}
// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}

// Whole data
typealias Dstore = [DstoreElement]

