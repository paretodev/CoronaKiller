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
    // 맵뷰1에 바인딩 전달 - 위치 잡는 것에 실패시 띄울 경고 불리언 값
    @State var showingAlertMapView = false
    
    // API통신 내용 저장 객체
        // 재고 정보 저장 객체 / // 현재 정부에서, 공적마스크 공급 중단으로 인해, API 서버를 닫은 상태입니다 !!
    @ObservedObject var stockInfoSet: storesStockInfoSet = storesStockInfoSet()
        // 아트워크 저장 객체
    @ObservedObject var nowArtWorks: NowArtworks = NowArtworks()
    // 라벨 스타일러
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(Font.custom("DoHyeon-Regular", size: 14))
        }
    } 
    
    //
    var body: some View {
            
            VStack{
                
                // mapview
                MapView(userviewCenter: self.$userviewCenter, UIcenter: self.$uiCenter, userSetLocation: self.$userSetLocation, artworksUpdated: self.nowArtWorks,
                        stockInfoSet: self.stockInfoSet, showingAlertMapView: self.$showingAlertMapView )
                
                //
                // button for searchview
                HStack{
                    
                    Button(action:{
                        self.modalIsActive = true
                        self.modalSelection = "search"
                    }
                        ) {
                            Text("장소 검색하여 보기").padding(.bottom, 25).padding(.trailing, 10).modifier(LabelStyle())
                    }
                    
                    Button( action:{
                        
                        self.getLocation.run {
                            if let location = $0 {
                                self.userviewCenter = location.coordinate
                            }else{//do nothing}
                        }
                    }
                        
                    }){
                        Text("현재 위치로 보기").padding(.bottom, 25).padding(.leading, 10).modifier(LabelStyle())
                    }
                }
                    
                
            // 위치 검색 시트 띄우기
                .sheet(isPresented: $modalIsActive, content: {
                    
                    // 검색용 시트 띄우기
                    if self.modalSelection == "search" {
                        addressSearchView(resultsStore: self.resultStore, searchedAddress: self.$userviewCenter, userSetLocation: self.$userSetLocation, modalIsActive: self.$modalIsActive, userviewCenter: self.$userviewCenter, stockInfoSet: self.stockInfoSet, artworksUpdated: self.nowArtWorks)
                    }
                    
                    // 공적 마스크 구매 가능 여부 시트 띄우기
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
                       Text("공적마스크 구매 가능 확인").modifier(LabelStyle())
                    }
                )
            }
            
        // map1에서 위치 잡기 실패시 alert창 띄움
        .alert(isPresented: $showingAlertMapView ) {
                
            Alert( title: Text("위치 설정 오류"),
                    message: Text("GPS가 정상적으로 작동하지 않고 있습니다. 위치 검색을 대신 사용해보세요."),
                    primaryButton: .destructive( Text("네"), action: {
                    // setback
                    self.$showingAlertMapView.wrappedValue = false
                    }
                    ),
                    secondaryButton: .cancel( Text("아니오"), action: {
                    self.$showingAlertMapView.wrappedValue = false
                    }
                )
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


