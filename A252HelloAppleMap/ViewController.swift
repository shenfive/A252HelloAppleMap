//
//  ViewController.swift
//  A252HelloAppleMap
//
//  Created by 申潤五 on 2025/3/23.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()

    @IBOutlet weak var theMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        checkLocationAuthorizationStatus(locationManager)
        
        
        locationManager.activityType = .automotiveNavigation
        locationManager.startUpdatingLocation()
        
        theMapView.userTrackingMode = .followWithHeading

        theMapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
    locations: [CLLocation]) {
        let coordinate = locations[0].coordinate
        print(coordinate)
        
        if let coordinate = locationManager.location?.coordinate{
            let xScale:CLLocationDegrees = 0.001
            let yScale:CLLocationDegrees = 0.001
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: xScale, longitudeDelta: yScale)
            let region =  MKCoordinateRegion(center: coordinate, span: span)
            theMapView.setRegion(region, animated: true)
        }
    }
    
            
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//            let latitude:CLLocationDegrees = 25.0444032
//            let longitude:CLLocationDegrees = 121.5141468
//            
//            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            
//            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location
//            annotation.title = "譯智"
//            annotation.subtitle = "教育訓練中心"
//            self.theMapView.addAnnotation(annotation)
//            
//            
//            
//            
//            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
//            let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
//            self.theMapView.setRegion(region, animated: true)
//            
//
//        }
    
//    }

    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {
        print("long Press")
        let touchPoint = sender.location(in: theMapView)
        print(touchPoint)
        let location = theMapView.convert(touchPoint, toCoordinateFrom: theMapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "自訂"
        self.theMapView.addAnnotation(annotation)
    }
    
    
    @IBAction func switchMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.theMapView.mapType = .standard
        case 1:
            self.theMapView.mapType = .satellite
        case 2:
            self.theMapView.mapType = .hybrid
        default:
            break
        }
    }
    
    //檢查位置使用授權
    func checkLocationAuthorizationStatus(_ locationManager: CLLocationManager) {
        let status = CLLocationManager().authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // 提示使用者前往設定頁面授權
            showAlertForSettings()
        case .authorizedAlways, .authorizedWhenInUse:
            // 已獲取授權
            break
        @unknown default:
            break
        }
    }

    
    //顯示位置授權
    func showAlertForSettings() {
        let alertController = UIAlertController(title: "需要你授權使用你的位置",
                                                message: "請按下【設定頁面】並選擇【位置】-＞【使用APP期間】或【永遠】，完成之後再回到APP，以利正確定位",
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "設定頁面", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        let cancelAction = UIAlertAction(title: "放棄", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

