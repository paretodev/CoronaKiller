//
//  ConfirmerAppearance.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/14.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation

// MARK: - Confirmer
struct Confirmer: Codable {
    let type: String
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Codable {
    let type: FeatureType
    let geometry: Geometry
    let properties: Properties
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [Double] // 여기 좌표
}

enum GeometryType: String, Codable {
    case point = "Point"
}

// MARK: - Properties
struct Properties: Codable {
    let text, pollution: String // "코로나19 부평구보건소 선별진료소","pollution":"2" 
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}

class API_Confirmer {
    func getConfirmers(completion: @escaping(Confirmer) -> () ){ // return values is possible
        guard let url = URL(string: "https://fy0810k9v5.execute-api.ap-northeast-2.amazonaws.com/dev/covid19/confirmers.json/") else {return}
        //API call
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("error in network")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print( "unexepected response from network" )
                return
            }
            
        let confirmersInfoSet = try! JSONDecoder().decode(Confirmer.self, from: data!) // decoded json format
            
        //test print newses
            // interact with the app while at same time doing api call
            DispatchQueue.main.async {
                completion(confirmersInfoSet)
            }
        }
        .resume()
    }
}
