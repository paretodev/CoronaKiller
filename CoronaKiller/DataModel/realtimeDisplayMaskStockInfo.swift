//
//  realtimeDisplayMaskStockInfo.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/11.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import Combine

// Publisher 객체의 템플릿 => 구독자에게 실시간 정보 변화 알림
class realtimeDisplayMaskStockInfo: ObservableObject {
    
    @Published var queriedStoresNumber: Int = 0
    @Published var stores: [Store] = []
}

