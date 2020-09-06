//
//  RowView.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/05/17.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI
import MapKit

struct RowView: View {
    
    @Binding var aResult: searchResult
    @Binding var searchedAddress: CLLocationCoordinate2D
    
    @Binding var userSetLocation: Bool
    @Binding var modalIsActive: Bool
    @Binding var userviewCenter: CLLocationCoordinate2D
    @ObservedObject var stockInfoSet: storesStockInfoSet
    @ObservedObject var artworksUpdated: NowArtworks
    
    var body: some View {
        
        HStack{
            Text("\(aResult.title)")
            Button(action: {
                
                self.$userviewCenter.wrappedValue = self.$aResult.wrappedValue.coordinates
                self.$userSetLocation.wrappedValue = true
                self.$modalIsActive.wrappedValue = false
                // api call 해서 => stockInfoSet과 artworksUpdated를 업데이트 하기
                
                MaskStockStoresAPI(coordi: self.$userviewCenter.wrappedValue).fetchStores{ (queriedStoreInfoSet) in
                             
                             // DataTask가 끝나면 다음이 실행됨 - 다 다운되면,
                             self.$stockInfoSet.stores.wrappedValue = queriedStoreInfoSet.stores
                    
                             // self.focusInfoStores.store를 => [Artwork]로 맵핑
                             self.$artworksUpdated.artworksToDisplay.wrappedValue = self.stockInfoSet.stores.map{ (store) in
                                 // 가게명
                                 let storeName = store.name
                                 // 재고량, 유저가 보는 재고량
                                 let stockLevelSystem = store.remain_stat ?? "unknown"
                                 var stockLevelUser: String = ""
                                 switch stockLevelSystem {
                                 case "plenty":
                                     stockLevelUser = "100개 이상"
                                 case "some":
                                     stockLevelUser = "30 ~ 100개"
                                 case "few":
                                     stockLevelUser = "2 ~ 3개"
                                 case "emtpy":
                                     stockLevelUser = "1개 이하"
                                 default:
                                     stockLevelUser = "미파악 또는 판매중지"
                                 }
                                 // 좌표
                                 let storeCoordinates = CLLocationCoordinate2D.init(latitude: store.lat, longitude: store.lng)
                                 // callout에 표시할 subtitle
                                 let storeSubtitle = "공적마스크 잔여재고 : \(stockLevelUser)\n주소 : \(store.addr)"
                                 return Artwork(title: storeName, subtitle: storeSubtitle, coordinate: storeCoordinates, stockLevel: stockLevelSystem)
                                 
                             }
                             print("검색에 의한 업데이트 완료")
                         }
                
                
            }) {
                Text("이 위치로 지도 설정").font(Font.custom("Arial Rounded MT Bold", size: 10)).padding(.leading, 10)
            }
            
        }
        
    }
}
