//
//  RealMapView.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/27.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI
import MapKit

struct RealMapView: View {
    
    // user의 지도뷰 기준 좌표
    @State var userviewCenter : CLLocationCoordinate2D = CLLocationCoordinate2D.init( ) // 좌표 디폴트
    // 화면 뷰 기준 좌표
    @State var uiCenter: CLLocationCoordinate2D = CLLocationCoordinate2D()
    // 유저 검색 관련
    @State var userSetLocation = false
    // 검색 뷰 오픈 통제
    @State var modalIsActive = false
    @State var modalSelection : String = "search" // modal 선택
    // 현위치 잡기위한 객체
    let getLocation = GetLocation()
    // 검색뷰에 바인딩 전달할 것 - 서치결과 struct들을 포함하고 있다.
    @ObservedObject var resultStore: searchResultsStore = searchResultsStore()
    
    // API통신 저장  객체 - !! 기억 전달할 것.
        // 재고 정보 저장 객체
    @ObservedObject var stockInfoSet: storesStockInfoSet = storesStockInfoSet()
        // 아트워크 저장 객체
    @ObservedObject var nowArtWorks: NowArtworks = NowArtworks()
    
    var body: some View {
            
            VStack{
                
                // mapview
                MapView(userviewCenter: self.$userviewCenter, UIcenter: self.$uiCenter, userSetLocation: self.$userSetLocation, artworksUpdated: self.nowArtWorks,
stockInfoSet: self.stockInfoSet)
                
                //
                // button for searchview
                HStack{
                    
                    Button(action:{
                        self.modalIsActive = true
                        self.modalSelection = "search"
                    }
                        ) {
                            Text("장소 검색하여 보기").padding(.bottom, 25).padding(.trailing, 10)
                    }
                    
                    Button( action:{
                        
                        self.getLocation.run {
                            if let location = $0 {
                                self.userviewCenter = location.coordinate
                            }else{//do nothing}
                        }
                    }
                        
                    }){
                        Text("현재 위치로 보기").padding(.bottom, 25).padding(.leading, 10)
                    }
                }
                    
                
            // 위치 검색 시트 띄우기
                .sheet(isPresented: $modalIsActive, content: {
                    
                    if self.modalSelection == "search" {
                        addressSearchView(resultsStore: self.resultStore, searchedAddress: self.$userviewCenter, userSetLocation: self.$userSetLocation, modalIsActive: self.$modalIsActive, userviewCenter: self.$userviewCenter, stockInfoSet: self.stockInfoSet, artworksUpdated: self.nowArtWorks)
                    }
                    
                    if self.modalSelection == "maskBuyPossibleCheck" {
                        Sheet2()
                    }
                
                // to create a view on a modal
            })
                    
        .navigationBarTitle("실시간 공적마스크 재고")
                    
        .navigationBarItems(trailing:
                
                    Button(action: {
                        self.modalSelection = "maskBuyPossibleCheck"
                        self.modalIsActive = true
                    }) {
                       Text("공적마스크 구매 가능 확인")
                    }
                
                
                )
            }
        }
    }


// Modal sheet 옵션2
struct Sheet2: View {
    var body: some View {
        PublicMaskQuestion()
    }
}



