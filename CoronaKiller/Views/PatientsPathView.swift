//
//  PatientsPathView.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/14.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI
import MapKit

struct PatientsPathView: View {
    
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
    // 라벨 스타일러
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(Font.custom("DoHyeon-Regular", size: 14))
        }
    }
    // 맵뷰2에 바인딩으로 전달 - 위치 잡는 것에 실패시 띄울 alert창 불리언 값
    @State var showingAlertMapView = false
    
    var body: some View {
        
        VStack{
            
            // mapview
            MapView2(userviewCenter: self.$userviewCenter, UIcenter: self.$uiCenter, userSetLocation: self.$userSetLocation, showingAlertMapView : self.$showingAlertMapView)
            
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
                
                if self.modalSelection == "search" {
                    addressSearchView2(resultsStore: self.resultStore, searchedAddress: self.$userviewCenter, userSetLocation: self.$userSetLocation, modalIsActive: self.$modalIsActive, userviewCenter: self.$userviewCenter)
                }
            
            // to create a view on a modal
        })

            .navigationBarTitle("실시간 확진자 동선")

        }
        
        
        // mapview2에서 위치 잡기 실패시 alert창 띄움
        .alert( isPresented: $showingAlertMapView ){
                
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

