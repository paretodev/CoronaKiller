//
//  News.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/04/30.
//  Copyright © 2020 suckyDuke. All rights reserved.
//
import Foundation

struct Pharmacy: Codable, Identifiable {
    
    let id = UUID()
    var username: String
    var name: String
    var address: 
    
}

class APIPharm {
    
    func getNewses(completion: @escaping([Pharmacy]) -> () ){ // return values is possible
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        
        //API call
        URLSession.shared.dataTask(with: url) { (data, _, _) in
        let pharmacies = try! JSONDecoder().decode([Pharmacy].self, from: data!) // decoded json format
        
        //test print newses
            
            // interact with the app while at same time doing api call
            DispatchQueue.main.async {
                completion(pharmacies)
            }
            
        }
        .resume()
    }
}

