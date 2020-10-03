//
//  RegionPatient.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/04/30.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import SwiftUI


struct ARegionData: Codable, Identifiable {
    
    let id =  UUID()
    let cityName: String
    let confirmed, deaths, recovered: Int
    let dateUpdated: String

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case confirmed, deaths, recovered
        case dateUpdated = "date_updated"
    
    }
}

class ApiRegionsDatum {
    func getRegionsDatum(completion: @escaping([ARegionData]) -> () ) {
        // url 지정
        guard let url = URL(string: "https://fy0810k9v5.execute-api.ap-northeast-2.amazonaws.com/dev/covid19/dashboard.json/") else {return}
        // 유알엘에서 제이슨을 해독해서 포스트로 가져온다.
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let regionsDatum = try! JSONDecoder().decode( [ARegionData].self , from: data! )
            DispatchQueue.main.async {
                completion(regionsDatum)
            }
        }
        .resume()
    }
}

struct RegionPatient_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
