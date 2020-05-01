//
//  ViewController.swift
//  GoogleMapTest
//
//  Created by Aoyagi Hiroki on 2020/04/14.
//  Copyright © 2020 Aoyagi Hiroki. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    //グローバル変数
    //位置情報取得用のManager
    let locationManager = CLLocationManager()
        
    //理工キャンパスを中心のcameraとmapView
    let camera = GMSCameraPosition.camera(withLatitude: 35.706031, longitude: 139.706818, zoom: 17.0)
    let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.9), camera: GMSCameraPosition.camera(withLatitude: 35.706031, longitude: 139.706818, zoom: 15.0))
    
    /// 経路検索APIのエンドポイント. 経路検索APIはSDKとして提供されていないため、エンドポイントはベタ書きになります
    let baseUrl = "https://maps.googleapis.com/maps/api/directions/json"
    /// 仮の目的地の座標（適当に GINZA SIX にしてみています）
    let ginzaSixLocation = "35.669798,139.7639302"
    /// Google API key
    let GOOGLE_API_KEY = "AIzaSyDiyMJF8nyHzfuSTbuZIjJiOEFNDAloKbY"
    
    struct Direction: Codable {
        let routes: [Route]
    }

    struct Route: Codable {
        let legs: [Leg]
    }

    struct Leg: Codable {
        /// 経路のスタート座標
        let startLocation: LocationPoint
        /// 経路の目的地の座標
        let endLocation: LocationPoint
        /// 経路
        let steps: [Step]
        
        enum CodingKeys: String, CodingKey {
            case startLocation = "start_location"
            case endLocation = "end_location"
            case steps
        }
    }

    struct Step: Codable {
        let startLocation: LocationPoint
        let endLocation: LocationPoint

        enum CodingKeys: String, CodingKey {
            case startLocation = "start_location"
            case endLocation = "end_location"
        }
    }

    struct LocationPoint: Codable {
        let lat: Double
        let lng: Double
    }
    
    // 現在地から目的地までのルートを検索する
    private func getDirection(destination: String, start startLocation: String, completion: @escaping (Direction) -> Void) {

        guard var components = URLComponents(string: baseUrl) else { return }

        components.queryItems = [
            URLQueryItem(name: "key", value: GOOGLE_API_KEY),
            URLQueryItem(name: "origin", value: startLocation),
            URLQueryItem(name: "destination", value: destination)
        ]

        guard let url = components.url else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decorder = JSONDecoder()
                do {
                    let direction = try decorder.decode(Direction.self, from: data)
                    completion(direction)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print(error ?? "Error")
            }
        }
        task.resume()
    }

    private func showRoute(_ direction: Direction) {
        //guard let route = direction.routes.first, let leg = route.legs.first else { return }
        
        let pathArray = [
            "gx|xEunusY@P?@?@@?@?\\?",
            "cw|xE_nusY?M?A?A@?@?d@?",
            "yu|xEqnusY?EB_D@_B?K?I?W@U?]?A@U",
            "ou|xEqzusYUCA?o@EMAu@GWAi@EaAGC?C?CAa@CMAa@CIAMASA[Cc@CYCGAaAG]CG?QAe@IEAWGGAe@Kw@O]IcCe@o@KCAeB]YGEAmAWwAYu@O}@QKCQCECUICAu@_@uAs@WOUMUKuAq@[Ic@U_@Oe@SQIUMQGSIOEMGEAw@YMEa@Oa@MYKMGGAw@WSCUIg@QoAc@mCaAa@OUIa@OKCEACAMCIAOAKAG?C?K@K@E@C?QDE@MDSFUFA@C?A?CAAAC@MH",
            "ep_yEuvvsYODFH@BBBBBB@BBD@B?B?DABAFEFGJCFCJCB?HCHAJCB?@?@?B?@?@@D@PF",
            "gk_yEmvvsYHSDMDK@C?C@C@C@C@AHW@EDMDK@CBEDOFMZ}@DI@CJ]Xs@Nc@To@Ng@DMTu@?C\\cA@EJYJWPc@Ti@DKJWBIBGDOBIXaAFOPk@JY",
            "{}~xEetwsYHWYkAEOCS]sAK]Qs@I[Oi@CKEOMi@Om@EOOg@k@yBGWOg@Oq@W{@Ki@K[EUc@{AEMWq@Wo@u@sBKWGOGEECAEAEGMACOU",
            "cn_yEo~xsYQIMG?K?M?GBW?ADg@@Q@GDGHQHKDE@ADI@EFQBKDSDMF[@CHUDKBILUFI@CJOLM?ANMFELI@ATMPGDCTKNGPEFCFCDABAHANCFAFAHAF?F@",
            "wb_yEwnysYTIBAJEZMDCZM`@O^OBAHEFCdCaAn@WBADCjAe@DABC`@O`@O^QbA_@^Qh@SDCDA`Aa@`@ORIl@WhAc@DCDAp@Wp@YBCNELGHEJEDELETKLGHCDENILILIHGDCLKLKLMHK@AFGFGBCJMLU@ADGDIDEHQJUFMJUHWBEPi@Pk@Pm@Rq@Z_AFUDKZeANg@Lc@JYLg@@CDODO@EJa@Jm@BMBQBOBQDUBSFo@Hw@?E@E@M@UBYH{@HcAFw@?EFi@?AFs@Ba@Fq@Fm@BQ@SJuARyB@YBYJkAFw@P}BB[@UBSH_AB]Di@BW@GDi@BOBSBMBIDKFQDIFKBGHKFGLKLI@AJENGPGLCTGPCNCb@Gb@GFAXEJCVGVEXINEREVGZI`@GJANEf@MB?@ALC`@KPENEdAW`@Kf@M^MDANEBCDADCFCHGFEFGPQJKFKBCBEFMBEHSFUDUBI@I@MBO@Y@m@?c@As@?m@AwACoB?S?g@AE?k@?IAa@?I?W?Y?G@[?G@E@K@S@OBMDSDQNe@Vc@PWNOJIJINKBAPKRK\\OZOfD{AhAe@RKJEh@UHEJEzAq@ZOBAVMHCVMFC^M@ATIJCNEHABAREHAJCNCLARCTCXCBAB?VCVCBAB?`@Ed@GZC`@ENABA@?H?HAz@Kl@Gn@GRC^GTEHAJATENELCFCHC@A",
            "avzxEco~sYLQTOPKBCHIJKDEBCLMPUDKHKBGDIDK@GBEFQDMBMJc@BQBOPgABKDYBK@C@CBMBKDIDKFK@EBE@ADEJODEDETWVUTYBCZ[PO",
            "_izxEwc_tYRUTSZ[t@y@Z[XYRSZ]@ALOHK@AFIFMDEFK@AHOHQFOFS@C@EBIBM@I@EBOBQ?ABW@M@S@O@O?G?I?Y@Q?m@?I?a@?I@_@?A?Q?S@[@O@IBOFUF_@J_@L_@HUTc@N[BGFMP_@HY@AJUBMHYBK@GHWBUNo@FMNa@FOBC@E@AFKHMPUDEX_@NSLOHOFKDIDIFOFOBKBMDO@MFc@Fi@Fo@Fg@Di@BQFo@Dk@BYBK",
            "aoyxEqbatYCA?AAAAA?CAA?ABW@A@M@O@O@Q@MBUFi@@KDWBMBMBMDODMFOHSR[P]JQHOBENYDGLSFI@CHMJMBCFIVYZYf@e@LIHIFEDETQLKTSZYROPOLK\\\\UNIJGPIDAb@Q\\\\K@?XKJCt@WPGHEVOFEDEFGHIJMBG@CFKHQ?ADKDQ@CHg@DY@GP}AFk@D_@?AB[BSBQFu@DKBGBc@@EBS@UNwA@WBQ?S@i@@K@MAQ?GCWAKCWAQ?W?I?IAEEe@Gg@AKGe@Io@AMGg@Ec@?KAG?GAO?Q@O@OBO?GFOBKDIBGBEDGNMFGHGFCDCNCLCJ?F?B?LBJ@B@NDFBB@@?DBTLHDFDVN^RRLJD`@N?@THHD@?DBB@B?BAD?PHLFB@`Af@^Rv@^RJJFFD`Ad@^P\\PbAf@^RrAn@HDp@^\\\\NRJ`@T~Az@z@`@d@Tb@VvBdA`@RZN^TTJTLD@FBbAj@",
            "c~vxEaqbtYPNFDLHRLLFTLNJVNLFJFFBHFFB?@VLDBFDLHJDJFNHNHF@DBFBB?D@@?B?HAD@R@H@`@?@?b@@V?R@J@J@@?J@D@fAT@?~A\\t@PTDPDRFPFLDHDNHFBRHXLVNNHPJLHJJ@?HFl@j@BB|@~@TZT\\FFV^BBh@n@",
            "qvuxEa{atYFBFBBBHHd@l@BDX\\HLVZLNDFB@@??@@?@?@?@?JI\\b@RV~@lA",
            "mmuxEsqatYNREDMNMNKNKJEFQRc@f@MPWVe@h@KLILSVIJSV[^Y\\UZEB?@MNSTIHEDA@K@Y^IHGJMLQTCBGHKNUZMPINOTGHKNS^",
            "c`vxEmz`tY\\\\TVDBTVf@j@d@d@HJJLLL\\\\PR"
            
        ]
        for data in pathArray {
            let path = GMSMutablePath(fromEncodedPath: data)
            // 曲がるところを結んだ線を Map 上に表示する
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 4.0
            polyline.map = mapView
        }
        
        
//        for step in leg.steps {
//            // steps の中には曲がるところの座標が入っているので、
//            // 曲がるところの座標を線で結んでいく
//            path.add(CLLocationCoordinate2D(latitude: step.startLocation.lat,
//                                            longitude: step.startLocation.lng))
//            path.add(CLLocationCoordinate2D(latitude: step.endLocation.lat,
//                                            longitude: step.endLocation.lng))
//
//            print("start.lat: \(step.startLocation.lat) start.lng: \(step.startLocation.lng) end.lat: \(step.endLocation.lat) end.lng: \(step.endLocation.lng)")
//
//            let path = GMSMutablePath(fromEncodedPath: step.polyline.points)
//            // 曲がるところを結んだ線を Map 上に表示する
//            let polyline = GMSPolyline(path: path)
//            polyline.strokeWidth = 4.0
//            polyline.map = mapView
//        }
        
    }
    
    
    
    //理工キャンパスへカメラが移動するボタンの動作
    @IBAction func didTapZoomRikoCampus(_ sender: Any) {
        print("tap button1")
        
        let rikoCampus = GMSCameraPosition.camera(withLatitude: 40.712216, longitude: -74.22655, zoom: 11.0)
        mapView.camera = rikoCampus
    }
    
    //経路検索ボタンの動作
    //Todo:現時点では直線しか引けない(泣)　別のAPIを使う必要がある。
    @IBAction func didTapSearchWay(_ sender: Any) {
        print("tap button2")
        setupLocationManager()
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
            
            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: mylocation.coordinate.latitude, longitude: mylocation.coordinate.longitude))
            path.add(CLLocationCoordinate2D(latitude: 35.706031, longitude: 139.706818))
            
            let line = GMSPolyline(path: path)
            line.map = mapView
            
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
        
        
        
//        //Ground Overlaysで画像を地図上に表示
//        let southWest = CLLocationCoordinate2D(latitude: 35.705432, longitude: 139.704790)
//        let northEast = CLLocationCoordinate2D(latitude: 35.706599, longitude: 139.708722)
//        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
//
//        // Image from https://fukuno.jig.jp/app/printmap/latlngmap.html#18/35.706079/139.706770/&base=std&ls=std&disp=1&vs=c1j0l0u0f1
//        let icon = UIImage(named: "nishi_waseda_campus")
//
//        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
//        overlay.bearing = 0
//        overlay.map = mapView
        
        let southWest = CLLocationCoordinate2D(latitude: 40.712216, longitude: -74.22655)
        let northEast = CLLocationCoordinate2D(latitude: 40.773941, longitude: -74.12544)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)

        // Image from http://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg
        let icon = UIImage(named: "newark_nj_1922")

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
        let latitude =  location.coordinate.latitude
        let longitude = location.coordinate.longitude

        //西早稲田キャンパスの座標
        let startLocation = "35.7057965,139.7068259"
        getDirection(destination: ginzaSixLocation,
                     start: startLocation,
                     completion: { [weak self] direction in
                        DispatchQueue.main.async {
                            self?.showRoute(direction)
                        }
        })
        
        print("latitude: \(latitude)\n longitude: \(longitude)")
    }
    
    
    
}
