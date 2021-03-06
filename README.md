# GoogleMapTest
参考URL  
https://developers.google.com/maps/documentation/ios-sdk/start?authuser=1

### テストした機能
- 現在地を中心にするボタン
- 理工キャンパスを中心にするボタン
- markerを理工キャンや駅などに立てる
- ルート検索ボタン(現在地から理工キャンパス、高田馬場駅)
- GoogleOverlay
- 座標のクリック処理
- 北を上にするボタン

### 初期設定
1. cocoapodをインストール
2. XCodeでプロジェクトを作る
3. Cocoapod経由でライブラリをダウンロード

~~~
cd GoogleMapTest
pod init
open .
cd GoogleMapTest
pod install
~~~
結構時間かかる(10分くらい)   

4.  API keyの取得     

5. API keyのセット  
https://developers.google.com/maps/documentation/ios-sdk/get-api-key?authuser=1#add_key  

注意：  
Cocoapodを使っているときは、projectname.workspaceから開く！  

### 各機能について

- 現在地を中心にするボタン  
公式ドキュメント(分かりづらい)  
https://developers.google.com/maps/documentation/ios-sdk/current-place-tutorial?authuser=1   
こっちの方が分かりやすかった  
https://qiita.com/powerispower/items/39203e1e908149fead19  

シミュレーターの場合、上のメニューバーの`Features/Location/Custom Location`で現在地を設定  
新宿駅の座標　35.689862,139.700523  

ボタンはライブラリで備わっている  
~~~Swift
//自分の現在地を表示するボタンをonに 
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
~~~

- ルート検索ボタン(現在地から理工キャンパス、高田馬場駅)   
→Directions APIというAPIを使う。https://developers.google.com/maps/documentation/directions/intro


- GoogleOverlay  
以下のURLに書いてある通りにやる。  
https://developers.google.com/maps/documentation/ios-sdk/overlays  


- 座標のクリック処理  
まず、上のextendの欄にGMSMapViewDelegateを追加。  
次に、viewDidLoad内に
~~~Swift
mapView.delegate = self
~~~
を書く。そして、以下の関数を定義する。
~~~Swift
//タップしたときの動作関数を定義
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
         print("Tapped at coordinate: " + String(coordinate.latitude) + " "
                                        + String(coordinate.longitude))
    }
~~~

- 北を上にするボタン
マップの向きを変えると、コンパスボタンが現れる。
他にも、マップの向きは`animate(toBearing: x)`で変更できる。
~~~Swift
//bearingの値が0で北が上、180で南が上
        mapView.animate(toBearing: 0)
~~~
