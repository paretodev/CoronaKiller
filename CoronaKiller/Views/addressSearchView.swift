//
//  addressSearchView.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/05/17.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

// binding, state, combine 개념을 정리하고 => 리스트에 실시간으로 반영하기 => 버튼 클릭 없이 !!

struct addressSearchView: View {

    @ObservedObject var resultsStore: searchResultsStore
    @Binding var searchedAddress: CLLocationCoordinate2D // 로우뷰를 선택할 때 나와야함
    @Binding var userSetLocation: Bool // 로우뷰를 선택할 때 true로 바뀌어야함.
    @Binding var modalIsActive: Bool
    @Binding var userviewCenter: CLLocationCoordinate2D
    @State var naturalLanguageQuery: String = ""
    @ObservedObject var stockInfoSet: storesStockInfoSet
    @ObservedObject var artworksUpdated: NowArtworks

    // 리퀘스트 객체 생성
    let request = MKLocalSearch.Request()
    
    var body: some View {
        
        VStack{
            
            // 모달뷰의 둥근모서리에 글씨가 겹쳐 스페이스를 둠
            Spacer()
            Spacer()

            
            HStack{
            
                TextField("검색하고 싶은 위치", text: self.$naturalLanguageQuery)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                
                // 실시간으로 natural검색어 변수가 변경, 반영된다.
            
            // 새로 검색을 할 때마다 - 검색결과 어레이를 빈 어레이로 만들고 채운다. - 모달뷰 끈다.
            Button(action: {
                
                self.resultsStore.searchResultsPool = []
                
                self.request.naturalLanguageQuery = self.$naturalLanguageQuery.wrappedValue
                let search = MKLocalSearch(request: self.request)
                
                search.start(completionHandler: {(results, error) in
                    
                    if let items = results?.mapItems{
                        
                        for item in items {
                            if let coordinates = item.placemark.location?.coordinate {
                                let aResult = searchResult(title: item.name!, coordinates:
                                    coordinates)
                                self.resultsStore.searchResultsPool.append(aResult)
                            }
                        }
                    }
                })
            }) {
                Text("검색").padding(.trailing, 20)
            }
            // Button액션
            }
            // HStack
            
            List {
                
                ForEach(resultsStore.searchResultsPool){ index in
                    RowView(aResult: self.$resultsStore.searchResultsPool[index], searchedAddress: self.$searchedAddress, userSetLocation: self.$userSetLocation, modalIsActive: self.$modalIsActive, userviewCenter: self.$userviewCenter, stockInfoSet: self.stockInfoSet, artworksUpdated: self.artworksUpdated)
                }
                
                
            }
        
                
        
    
    }
}
}

struct addressSearchView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
