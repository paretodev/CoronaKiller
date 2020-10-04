//
//  MapView.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/05/09.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI
import MapKit
import Foundation
import Combine

struct MapView: UIViewRepresentable {

    // struct variables
    @Binding var userviewCenter : CLLocationCoordinate2D
    @Binding var UIcenter: CLLocationCoordinate2D
    @State var locationMananger = CLLocationManager()
    @Binding var userSetLocation: Bool
    @ObservedObject var artworksUpdated: NowArtworks
    @ObservedObject var stockInfoSet: storesStockInfoSet
    let getLocation = GetLocation()
    @Binding var showingAlertMapView : Bool
    
    // 1). method - 1
    func setupMananger() {
        locationMananger.desiredAccuracy = kCLLocationAccuracyBest
        locationMananger.requestAlwaysAuthorization()
        locationMananger.requestWhenInUseAuthorization()
    }
    
    // 2). method - 2
    func makeUIView(context: Context) -> MKMapView {
        
        // 셋업 매니저 호출 - 정확도 설정, 승인 받기
        setupMananger()
        // 1). 현 위치 fetch 성공시
        getLocation.run {
            
            if let location = $0 {
                
                self.$userviewCenter.wrappedValue = location.coordinate
                
                MaskStockStoresAPI(coordi: self.$userviewCenter.wrappedValue).fetchStores{ (queriedStoreInfoSet) in
                    
                    // queriedInfoSet이 다 다운될 때 까지 대기
                    self.stockInfoSet.stores = queriedStoreInfoSet.stores
                    
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
                        let storeSubtitle = "공적마스크 잔여재고 : \(stockLevelUser)\n\(store.addr)"
                        
                        return Artwork(title: storeName, subtitle: storeSubtitle, coordinate: storeCoordinates, stockLevel: stockLevelSystem)
                        
                    }
                    
                }
            }
            // 2). 유저의 현 위치 fetch 실패시
                    // 1. 디폴트 설정 위치(잠실역)로 make ui view 진행 37.513287, 127.100126
                    // 2. alert상자를 띄워서, "위치를 가져오는 데에 실패했습니다. 검색을 이용해보세요."
            else {
                
                self.$userviewCenter.wrappedValue = CLLocationCoordinate2D.init( latitude: 37.513287 , longitude: 127.100126 )
                
                MaskStockStoresAPI(coordi: self.$userviewCenter.wrappedValue).fetchStores{ (queriedStoreInfoSet) in
                    
                    // queriedInfoSet이 다 다운될 때 까지 대기
                    self.stockInfoSet.stores = queriedStoreInfoSet.stores
                    
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
                        let storeSubtitle = "공적마스크 잔여재고 : \(stockLevelUser)\n\(store.addr)"
                        
                        return Artwork(title: storeName, subtitle: storeSubtitle, coordinate: storeCoordinates, stockLevel: stockLevelSystem)
                        
                    }
                    
                }
                
                // RealMapView 바인딩 변수에 => true 전달
                self.$showingAlertMapView.wrappedValue = true
                
            }
        }
        
        // 2). 맵뷰 설정 시작
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        
        //
        mapView.register(
        ArtworkMarkerView.self,
        forAnnotationViewWithReuseIdentifier:
          MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // 3). 아트워크 더하기
        mapView.addAnnotations(self.$artworksUpdated.artworksToDisplay.wrappedValue)
        // 4). 1)에서 fetch한 현재 위치를 기준으로 반경 3키로 미터 이내 표시
        let region = MKCoordinateRegion(center: self.$userviewCenter.wrappedValue, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        // 4). 사용자 위치 표시 및 추적 헤드 표시
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        print("makeUIview완성")
        // 5). 위와 같이 설정한 지도뷰를 리턴
        return mapView
        
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        // SwiftUI is managing the memory of @State and @Binding objects and
        // automatically refreshes any UI of any Views that rely on your variable.
        // 해당 뷰의 : observable object, userSetLocation 등이 변하면, 스위프트 유아이가 해당 변수의 메모리를 관리중이다가
        // 포함하고 있는 모든 UI를 업데이트한다.
        
        // 실시간 : @state @observable object @binding 변수에 업데이트가 생기면 다음의 블록을 실행
        let region = MKCoordinateRegion(center: self.$userviewCenter.wrappedValue, latitudinalMeters: 1500, longitudinalMeters: 1500)
        // 실시간 : 바뀐 주석 추가
        uiView.addAnnotations(self.$artworksUpdated.artworksToDisplay.wrappedValue)
        // 실시간 : 바뀐 장소에 따라 뷰를 따라서 이동
        uiView.setRegion(region, animated: true)
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
        }
 
        func mapView(
          _ mapView: MKMapView,
          annotationView view: MKAnnotationView,
          calloutAccessoryControlTapped control: UIControl
        ) {
          guard let artwork = view.annotation as? Artwork else {
            return
          }
            
            let indexLineChange = artwork.subtitle!.firstIndex(of: "\n")!
            UIPasteboard.general.string = String( artwork.subtitle![artwork.subtitle!.index(after: indexLineChange)...] )
            
        }
    }
    
}


    


