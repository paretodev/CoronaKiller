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

struct MapView2: UIViewRepresentable {

    // struct variables
    @Binding var userviewCenter : CLLocationCoordinate2D
    @Binding var UIcenter: CLLocationCoordinate2D
    @State var locationMananger = CLLocationManager()
    @Binding var userSetLocation: Bool
    let getLocation = GetLocation()
    @State var confirmersInfoSet: Confirmer = Confirmer(type: "", features: [])
    @State var artworks : [Artwork2] = []
    
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
                print("현재 위치 fetched")
                print("위도 : ", self.$userviewCenter.wrappedValue.longitude)
                print("경도 : ", self.$userviewCenter.wrappedValue.latitude)
                
                // 현위치 기준으로 api call => Artworks2 객체들 만드릭
                API_Confirmer().getConfirmers { (confirmersSet) in
                    
                    self.confirmersInfoSet = confirmersSet
                
                    // 여기서 필요한 것 추출하기
                    
                    let features = self.confirmersInfoSet.features
                    // feature 하나 하나 마다 이터레이션 하며
                    // artworks 만들기
                    for aStructure in features {
                        
                        let lng = aStructure.geometry.coordinates[0]
                        let lat = aStructure.geometry.coordinates[1]
                        let coordinates = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
                        
                        let title = aStructure.properties.text
                        let pollutionLevel = aStructure.properties.pollution // String
                        var subtitle = ""
                        
                        switch pollutionLevel {
                        case "1":
                            subtitle = "24시간이내 방문"
                        case "2":
                            subtitle = "4일 ~ 1일이내 방문"
                        case "3":
                            subtitle = "4일 ~ 9일이내 방문"
                        default:
                            subtitle = "방문한 지 9일 초과"
                        }
                        
                        self.artworks.append(Artwork2(title: title, subtitle:subtitle, coordinate: coordinates, pollutionLevel: pollutionLevel))
                        
                    }
                    
                }
                
            }
            
        // 1). 현 위치 fetch 실패시 - 에러를 낸다, 지피에스 오류
            else {
                print("Location was not fetched.")
                print("Get Location failed \(self.getLocation.didFailWithError ?? "Location Fetch Failed." as! Error)")
            }
        }
        // 2). 맵뷰 설정 시작
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        
        //
        mapView.register(
        ArtworkMarkerView2.self,
        forAnnotationViewWithReuseIdentifier:
          MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // 3). [아직 구현 안 됨]주석 더하기
        mapView.addAnnotations(self.$artworks.wrappedValue)
        // 4). 1)에서 fetch한 현재 위치를 기준으로 반경 3키로 미터 이내 표시
        let region = MKCoordinateRegion(center: self.$userviewCenter.wrappedValue, latitudinalMeters: 750, longitudinalMeters: 750)
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
        // 실시간 : 바뀐 장소 기준으로 region객체 생성
        let region = MKCoordinateRegion(center: self.$userviewCenter.wrappedValue, latitudinalMeters: 750, longitudinalMeters: 750)
        // 실시간 : 바뀐 주석 추가
        uiView.addAnnotations(self.$artworks.wrappedValue)
        // 실시간 : 바뀐 장소에 따라 뷰 이동
        uiView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView2
        init(_ parent: MapView2) {
            self.parent = parent
        }

        func mapView(
          _ mapView: MKMapView,
          annotationView view: MKAnnotationView,
          calloutAccessoryControlTapped control: UIControl
        ) {
          guard let artwork = view.annotation as? Artwork2 else {
            return
          }

        }
    }
    
}




