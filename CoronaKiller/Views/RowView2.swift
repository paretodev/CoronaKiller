import SwiftUI
import MapKit

struct RowView2: View {
    
    @Binding var aResult: searchResult
    @Binding var searchedAddress: CLLocationCoordinate2D
    
    @Binding var userSetLocation: Bool
    @Binding var modalIsActive: Bool
    @Binding var userviewCenter: CLLocationCoordinate2D
    
    var body: some View {
        
        HStack{
            Text("\(aResult.title)")
            Button(action: {
                
                self.$userviewCenter.wrappedValue = self.$aResult.wrappedValue.coordinates
                self.$userSetLocation.wrappedValue = true
                self.$modalIsActive.wrappedValue = false
                
                
            }) {
                Text("이 위치로 지도 설정").font(Font.custom("Arial Rounded MT Bold", size: 10)).padding(.leading, 10)
            }
            
        }
        
    }
}
