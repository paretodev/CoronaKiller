//
//  MaskSales.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/14.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation

// MARK: - MasksSale
struct MasksSale: Codable, Identifiable {
    var id = UUID()
    let title: String
    let price: Int
    let url: String
}


class MaskSalesAPI {
    
    func getSalesInfos(completion: @escaping([MasksSale]) -> () ){ // return values is possible
        // 현재는 서버가 내려간 상태입니다.
        guard let url = URL(string: "https://fy0810k9v5.execute-api.ap-northeast-2.amazonaws.com/dev/covid19/stores.json/") else {return}
        //API call
        URLSession.shared.dataTask(with: url) { (data, _, _) in
        let salesinfos = try! JSONDecoder().decode([MasksSale].self, from: data!) // decoded json format
            // from global queue -> main queue, asynch
                // 비동기로 메인 큐에서 다음의 과정을 시작합니다.
            DispatchQueue.main.async {
                completion(salesinfos)
            }
        }
            
        .resume()
    }
}
