//
//  ViewController.swift
//  GoogleMapTest
//
//  Created by Aoyagi Hiroki on 2020/04/14.
//  Copyright © 2020 Aoyagi Hiroki. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    //グローバル変数
    //位置情報取得用のManager
    let locationManager = CLLocationManager()
        
    //理工キャンパスを中心のcameraとmapView
    let camera = GMSCameraPosition.camera(withLatitude: 35.706031, longitude: 139.706818, zoom: 17.0)
    let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.9), camera: GMSCameraPosition.camera(withLatitude: 35.706031, longitude: 139.706818, zoom: 17.0))
    
    /// 経路検索APIのベースとなるURL
    let baseUrl = "https://maps.googleapis.com/maps/api/directions/json"
    /// 西早稲田キャンパスの座標
    let nishiwasedaCampusLocation = "35.706031,139.706818"
    /// Google API key
    let GOOGLE_API_KEY = "AIzaSyDiyMJF8nyHzfuSTbuZIjJiOEFNDAloKbY"
    
    
    
    //理工キャンパスへカメラが移動するボタンの動作
    @IBAction func didTapZoomRikoCampus(_ sender: Any) {
        print("tap button1")
        
        let rikoCampusCamera = GMSCameraPosition.camera(withLatitude: 35.706031, longitude: 139.706818, zoom: 17.0)
        mapView.camera = rikoCampusCamera
    }
    
    //経路検索ボタンの動作
    @IBAction func didTapSearchWay(_ sender: Any) {
        print("tap button2")
        setupLocationManager()
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
            let myLocationString = String(mylocation.coordinate.latitude) + "," + String(mylocation.coordinate.longitude)
            showDirection(startLocation: myLocationString, destinationLocation: nishiwasedaCampusLocation)
            
        } else {
          print("User's location is unknown")
        }
        
        
    }
    
    //現在地へカメラが移動するボタンの動作
    @IBAction func didTapZoomCurrentPlace(_ sender: Any) {
        
        print("tap button3")
        setupLocationManager()
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
            
            let currentPlace = GMSCameraPosition.camera(withLatitude: mylocation.coordinate.latitude, longitude: mylocation.coordinate.longitude, zoom: 17.0)
            mapView.camera = currentPlace
        } else {
          print("User's location is unknown")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLocationManager()
        
        
        
        //理工キャンパスを中心にして表示
        self.view.addSubview(mapView)
        
        
        //これ書かないとdidTapAtが動作しない
        mapView.delegate = self
        
    
        
        //マップの各種設定
        //コンパスボタンの表示をonに(北が上でない時だけ表示される)
        mapView.settings.compassButton = true
        //自分の現在地を表示するボタンをonに
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        //傾ける動作を無効化(うざいので)
        mapView.settings.tiltGestures = false
        
        if let mylocation = mapView.myLocation {
          print("User's location: \(mylocation)")
        } else {
          print("User's location is unknown")
        }
        
        
        
        //地図の上を北にする
        //bearingの値が0で北が上、180で南が上
        mapView.animate(toBearing: 0)
        
        
        
        //Ground Overlaysで画像を地図上に表示
        let southWest = CLLocationCoordinate2D(latitude: 35.705432, longitude: 139.704790)
        let northEast = CLLocationCoordinate2D(latitude: 35.706599, longitude: 139.708722)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)

        // Image from https://fukuno.jig.jp/app/printmap/latlngmap.html#18/35.706079/139.706770/&base=std&ls=std&disp=1&vs=c1j0l0u0f1
        let icon = UIImage(named: "nishi_waseda_campus")

        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
        overlay.bearing = 0
        overlay.map = mapView
        
        // マーカーを理工キャンパスと高田馬場駅に表示
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 35.706031, longitude: 139.706818)
        marker.title = "西早稲田キャンパス"
        marker.snippet = "理工展開催中！"
        marker.map = mapView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 35.712678, longitude: 139.703738)
        marker2.title = "高田馬場駅"
        marker2.snippet = "西早稲田キャンパスまで徒歩15分"
        marker2.map = mapView
        
        
        
    }
    

    
    //タップしたときの動作を定義
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //63号館をタップした時
        if(35.705530 <= Double(coordinate.latitude) &&
            Double(coordinate.latitude) <= 35.706192 &&
            139.704962 <= Double(coordinate.longitude) &&
            Double(coordinate.longitude) <= 139.705450){
                print("Tapped at Building 63")
        }else{
            print("Tapped at coordinate: " + String(coordinate.latitude) + " "
            + String(coordinate.longitude))
        }
 
    }
    
    
    
    //位置情報取得用のManager
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()

        // 「アプリ使用中の位置情報取得」の許可が得られた場合のみ、CLLocationManagerクラスのstartUpdatingLocation()を呼んで、位置情報の取得を開始する
        if .authorizedWhenInUse == CLLocationManager.authorizationStatus() {

            // 許可が得られた場合にViewControllerクラスがCLLoacationManagerのデリゲート先になるようにする
            locationManager.delegate = self
            // 何メートル移動ごとに情報を取得するか。ここで設定した距離分移動したときに現在地を示すマーカーも移動する
            locationManager.distanceFilter = 1
            // 位置情報取得開始
            locationManager.startUpdatingLocation()
        }
    }

    // 位置情報を取得・更新するたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        //let location = locations.first
        let latitude =  String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)

        
        print("latitude: \(latitude)\n longitude: \(longitude)")
    }
    
    // 現在地から目的地までのルートを表示するメソッド
    private func showDirection(startLocation: String, destinationLocation: String) {

        //検索URLを作成
        let url = baseUrl + "?origin=" + startLocation + "&destination=" + destinationLocation + "&key=" + GOOGLE_API_KEY
        print(url)
        
        //http通信で上記URLにアクセス。JSONファイルをもらう。
        AF.request(url).responseJSON { response in
            switch response.result {
                case .success(let value):
                    //もらったJSONをハンドリング
                    let json = JSON(value)
                    print("json: \(json)")
                    let routes = json["routes"]
                    print("routes: \(routes)")
                    let points = routes[0]["overview_polyline"]["points"].string
                    print("points: \(points ?? "")")
                
                    //overview_polylineをマップに描く
                    let path = GMSMutablePath(fromEncodedPath: points ?? "")
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeWidth = 3.0
                    polyline.map = self.mapView
                
                
                case .failure(let error):
                    print(error)
            }
            
        }
        
        
    }
    
}
