//
//  CinemaViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/11.
//

import UIKit
import MapKit

import CoreLocation

class CinemaViewController: UIViewController {
    
    static let identifier = "CinemaViewController"
    
    @IBOutlet weak var cinemaMapView: MKMapView!
    
    // 2. 위치에 대한 대부분을 담당하는 CLLocationManager 인스턴스 생성
    let locationManager = CLLocationManager()
    
    let cinemaList = CinemaList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 3. 프로토콜 연결
        locationManager.delegate = self
        
        setNaviItem()
        
        
        
    }
    
    // 1. 현재 위치 정하기
    func myRegionAndAnnotation(_ title: String, _ meters: Double ,_ center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: meters, longitudinalMeters: meters)
        cinemaMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        
        cinemaMapView.addAnnotation(annotation)
    }
    
    // 위치 버튼 눌렀을 때 위치 권한 denied, restricted인 경우 showAlert -> 아닐 시 현재위치
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
        locationManager.startUpdatingLocation()
        
    }
    

}


extension CinemaViewController {
    
    func setNaviItem(){
    // filter누르면 액션시트
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(presentAlert))
    }
    
    @objc
    func presentAlert() {
        setAlert()
    }
    
    func setAlert() {
        
        let cinemaAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let megabox = UIAlertAction(title: "메가박스", style: .default) { action in
            self.showCinemaAnnotation(action)
        }
        
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { action in
            self.showCinemaAnnotation(action)
        }
        
        let cgv = UIAlertAction(title: "CGV", style: .default) { action in
            self.showCinemaAnnotation(action)
        }
        
        let all = UIAlertAction(title: "전체보기", style: .default) { _ in
            self.cinemaMapView.removeAnnotations(self.cinemaMapView.annotations)
            for item in self.cinemaList.mapAnnotations {
                self.myRegionAndAnnotation(item.location, 16000, CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        
        cinemaAlert.addAction(megabox)
        cinemaAlert.addAction(lotte)
        cinemaAlert.addAction(cgv)
        cinemaAlert.addAction(all)
        cinemaAlert.addAction(cancel)
        
        present(cinemaAlert, animated: true)
    }
    
    // 선택한 영화관만
    func showCinemaAnnotation(_ alertAction: UIAlertAction) {
        cinemaMapView.removeAnnotations(cinemaMapView.annotations)
        
        for item in cinemaList.mapAnnotations {
            if item.type == alertAction.title {
                
//                latitudeArr.append(item.latitude)
//                longitudeArr.append(item.longitude)

                
                myRegionAndAnnotation(item.location, 11000, CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
            }
        }
    }
    
}



// 5. 위치서비스 활성화 여부, 사용자의 위치 권한 상태 확인
// 활성화 여부에 따른 Alert표시 후 설정으로 이동하는 함수
// 총 3가지 작성
extension CinemaViewController {

    // 5-1 사용자의 위치서비스 활성화 여부 물어보기
    // iOS 14 버전에 따른 분기 처리 밑, 위치 서비스 활성화 여부 확인
    func checkUserDeviceLocationServiceAuthorization() {
        
        // 서비스 활성 상태
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0 , *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // 위치 서비스 활성화 상태 여부 확인
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스 활성화가 되어있으므로 사용자에게 위치 권한을 물어보는 메서드 들어가야됨
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            // showAlert
            print("위치 서비스 활성화가 되어있지 않습니다.")
        }
            
    }
    // 5-2 사용자의 위치 권한 상태 확인
    // inPut으로 현재 서비스 활성화 상태가 들어가야 됨
    // notDetermined -> 처음 앱 실행, 버튼을 눌러서 설정하도록 권유
    // restricted, denied -> 위치 서비스가 꺼져있어 서비스 제공 x 위치 서비스 활성화 하도록 권유
    // authorizedWhenInUse ->
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            //앱을 사용하는 동안에 위치 권한 요청 + plist에 privacy(location when in use 등록 필수)
           
            
            // 제한이 됐다는 것이기 때문에 Alert page로 이동!
        case .restricted, .denied:
            print("RESTRICTED")
            let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
            myRegionAndAnnotation("청년취업사관학교 영등포 캠퍼스", 600, center)
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            // startUpdatingLocation이 있다면 stopUpdatingLocation도 구현해줘야 함
            // 아래 메서드가 실행하면 4-1의 메서드가 실행된다. 따라서 stop은 4-1에서 구현
            locationManager.startUpdatingLocation()
            
        default:
            print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
    
    
    
}





// 4. 프로토콜 선언 (3가지 구현!)
extension CinemaViewController: CLLocationManagerDelegate {
    // 4-1
    // 위치 가져오는 거 성공했을 때
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        
        // location 파라미터 안에 coordinate(사용자의 현재 위치)를 가져와서 다시 위치를 찍어줌
        if let coordinate = locations.last?.coordinate {
            myRegionAndAnnotation("현재 위치", 600, coordinate)
        }
        
        //⭐️ start updatingLocation을 하고나서 멈추기 필수!
        locationManager.stopUpdatingLocation()
    }
    
    // 4-2
    // 위치 가져오는 거 실패했을 때
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // 사용자의 권한 상태가 바뀔 때 호출되는 메서드
    // 앱이 처음 실행됐을 때도 실행된다.-> CllocationManager() 인스턴스를 생성
    // iOS 14 이상
    // 4-3-1
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    // iOS 14 미만
    // 4-3-1
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
    }
    
}

extension CinemaViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
}
