//
//  LocationVC.swift
//  Community
//
//  Created by Hatshit on 21/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import CoreLocation


class LocationVC: UIViewController , UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate , CLLocationManagerDelegate{
    
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet weak var txt_Field: UITextField!
    @IBOutlet weak var lbl_CurrentAddr: UILabel!
    
    
    var locationManager: CLLocationManager!
    var isLocation : Bool!
    var arrOfShowData = [Any]()
    var currnt_Lat : Double!
    var currnt_Long : Double!
    var ctrObjOFLocation : CountryList!

    var sltCity_Lat : Double!
    var sltCity_Long : Double!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if(!APP_Delegate().reqType){
            let width = self.view.frame.size.width/5
            let label = UILabel(frame: CGRect(x: 0, y: 63, width: width*3, height: 5))
            label.text = ""
            label.clipsToBounds = true;
            label.backgroundColor = progressBarColor()
            self.view.addSubview(label)
        }
        
        
        var sltcity : String = UserDefaults.standard.value(forKey: "SltCityNm") as! String
        if (sltcity == "Greater Boston Region, USA") {
            sltcity = "Boston, MA, United States"
        }
        
        
        getCoordinateFrom(address: sltcity ) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            // don't forget to update the UI from the main thread
            DispatchQueue.main.async {
                //print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                self.sltCity_Lat = coordinate.latitude
                self.sltCity_Long = coordinate.longitude
            }
        }

    }
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate:
        CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
         self.determineMyCurrentLocation()
       
    }
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    
    
    @IBAction func btnActionMethod(_ sender: Any) {
        
        if(lbl_CurrentAddr.text != ""){
        
            let coordinate₀ = CLLocation(latitude: self.sltCity_Lat, longitude: self.sltCity_Long)
            
            let coordinate₁ = CLLocation(latitude: self.currnt_Lat!, longitude:self.currnt_Long!)
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            // result is in meters
            
            if(distanceInMeters > 48280.3){
                showToast(message: "Please select place upto 30 miles around.", width: 300)
                return
            }
            
             setDataInUserDefalt(key: "Location_Lat", userData: String(self.currnt_Lat ))
             setDataInUserDefalt(key: "Location_Long", userData: String(self.currnt_Long ))
             setDataInUserDefalt(key: "Location_Addrs", userData:  lbl_CurrentAddr.text ?? "")
            
            let selectDateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SELECTEDDATE") as! SelectDateVC
            
            selectDateVC.ctrObjOFSltDate = ctrObjOFLocation

            self.navigationController?.pushViewController(selectDateVC, animated: true)
        }else{
            
            self.determineMyCurrentLocation()
        }
    }
  
    
    func determineMyCurrentLocation() {
        locationPermissionEnable()
        
        let firstLocation =  UserDefaults.standard.bool(forKey: "FirstLocation")
        
        
        if firstLocation == false {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                    
                case .notDetermined, .restricted, .denied:
                    //self.showAlertOfLocation()
                    break
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.startUpdatingLocation()
                    break
                }
            } else {
                //self.showAlertOfLocation()
            }
        }
        
        
         UserDefaults.standard.set(false, forKey: "FirstLocation")
     
    }
    
    
    func locationPermissionEnable(){
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        showLoader(view: self.view)
   
        let userLocation:CLLocation = locations[0] as CLLocation
   
        manager.stopUpdatingLocation()
        
        //print("user latitude = \(userLocation.coordinate.latitude)")
        //print("user longitude = \(userLocation.coordinate.longitude)")
        self.currnt_Lat = userLocation.coordinate.latitude
        self.currnt_Long = userLocation.coordinate.longitude

        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) //changed!!!
        //print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
           // print(location)
            
            if error != nil {
                //print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                //print(pm?.locality! ?? "")
                self.displayLocationInfo(pm)
            }
            else {
                //print("Problem with the data received from geocoder")
            }
        })
        
      
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            
            //print("your location is:-",containsPlacemark)
            
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            lbl_CurrentAddr.text = String(format: "%@,%@,%@ ", locality! , administrativeArea! , country!)
            
            killLoader()
     
          }
        }
    
    
    /*
    func showAlertOfLocation(){
        
        
        let alertController = UIAlertController (title: "Turn On Location Service to Allow 'Communiti' to Determine Your Location", message:"" , preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            if !CLLocationManager.locationServicesEnabled() {
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                    // If general location settings are disabled then open general location settings
                    UIApplication.shared.openURL(url)
                }
            } else {
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    // If general location settings are enabled then open location settings for the app
                    UIApplication.shared.openURL(url)
                }
            }
            
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    */
//======================================
// MARK:-Table View Delegate Methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfShowData.count
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LocationCell"
        var cell: LocationCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LocationCell
        if cell == nil {
            tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? LocationCell
        }
        
        let response =  arrOfShowData[indexPath.row] as! [String : Any]
        cell.lbl_Country.text = response["name"] as? String
        if(response["formatted_address"] as? String != ""){
           // print("response == ",response)
        let fullStr: String = (response["formatted_address"] as? String) ?? ""
            cell.lbl_Address.text = fullStr != "" ? fullStr : response["name"] as? String
        }


        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.txt_Field.resignFirstResponder()// Click on table view dissmiss keybord

        let response =  arrOfShowData[indexPath.row] as? [String : Any]
        let lat =  ((response?["geometry"] as? [String : Any])?["location"] as? [String : Any])?["lat"]
        
        let long =  ((response?["geometry"] as? [String : Any])?["location"] as? [String : Any])?["lng"]
        
         //let coordinate₀ = CLLocation(latitude: self.currnt_Lat, longitude: self.currnt_Long)
        let coordinate₀ = CLLocation(latitude: self.sltCity_Lat, longitude: self.sltCity_Long)

         let coordinate₁ = CLLocation(latitude: lat as! CLLocationDegrees, longitude:long as! CLLocationDegrees)
        
         let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        // result is in meters
        
        if(distanceInMeters > 48280.3){
            showToast(message: "Please select place upto 30 miles around.", width: 300)
            return
        }
        
        setDataInUserDefalt(key: "Location_Lat", userData: lat ?? "")
        setDataInUserDefalt(key: "Location_Long", userData: long ?? "")
        setDataInUserDefalt(key: "Location_Addrs", userData: response?["formatted_address"] ?? "")

        
        let selectDateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SELECTEDDATE") as! SelectDateVC
        selectDateVC.ctrObjOFSltDate = ctrObjOFLocation

        self.navigationController?.pushViewController(selectDateVC, animated: true)
  
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    
//======================================
// MARK:-Text Field Delegate Methods
//======================================
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       // print("While entering the characters this method gets called")
        
        
    if(lbl_CurrentAddr.text != ""){ // if currnet location is not selected
        
          DispatchQueue.main.async {
            
               if((textField.text?.characters.count)! >= 3){
                self.callSerViceToGetPlaceList(textField)
                 }
            
                 }
        
               return true
            }
        
        //  self.showAlertOfLocation()
          return false
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("TextField should returnmethod called")
        textField.resignFirstResponder();
        return true;
    }

    
    func callSerViceToGetPlaceList(_ textField : UITextField){
        let urlPath = String(format: "https://maps.googleapis.com/maps/api/place/textsearch/json?key=%@&query=%@", "AIzaSyBCskeOBd72sFZjvK1LSHBfQb2DzcQrGdY",textField.text!)
  
        doRequestGet(str: urlPath)
   
    }
    func doRequestGet(str:String){
       // showNetworkActivity()

        let urlString = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
         let url = NSURL(string: urlString!)
        
        let request = NSURLRequest(url: url! as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            _ = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
            let _: NSError?
            let jsonResult: AnyObject = try! JSONSerialization.jsonObject(with: data!, options:    JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            
            //print(jsonResult)
            
            DispatchQueue.main.async {
            self.arrOfShowData.removeAll()

            let resultArray  = jsonResult["results"] as! [[String : Any]]
              if resultArray.count>0{
    
                for obj in resultArray {
                   // print(obj)
                //let address  =  obj["formatted_address"] as! String
                    
                //let lat =   ((obj["geometry"] as? [String : Any])?["location"] as? [String : Any])?["lat"]
               // let long =   ((obj["geometry"] as? [String : Any])?["location"] as? [String : Any])?["lng"]
                    
               // let coordinate₀ = CLLocation(latitude: self.currnt_Lat, longitude: self.currnt_Long)
               // let coordinate₁ = CLLocation(latitude: lat as! CLLocationDegrees, longitude:long as! CLLocationDegrees)
                    
               // let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
                   // if(distanceInMeters <= 48280.3)
                    //{
                        // under 30 mile
                        self.arrOfShowData.append(obj)

                   // }
 
               // print(address)
                }
                self.table_View.reloadData()

              } else{
                  DispatchQueue.main.async {
                    self.table_View.reloadData()
                  }
                }
            }
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }

}
