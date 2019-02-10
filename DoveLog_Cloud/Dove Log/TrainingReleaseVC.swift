//
//  TrainingReleaseVC.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 10/24/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CloudKit

class TrainingReleaseVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var compasstext: String = ""
    let myLat = UserDefaults.standard.double(forKey: "loftLat")
    let myLong = UserDefaults.standard.double(forKey: "loftLong")
    var compass: Double = 0.0
    var distance: Double = 0.0
    var distanceDB: String! = ""
    var feetmiles: String! = ""
    var releaseLocationManager = CLLocationManager()
    let homeAnno = MKPointAnnotation()
    let relAnno = MKPointAnnotation()
    var values:NSArray = []
    var stuff  = NSMutableArray()
    var chartTeam: String! = "red"
    @IBOutlet var releaseMap: MKMapView!
    @IBOutlet var distanceRelease: UILabel!
    @IBOutlet var teamPicker: UIPickerView!
    var currentlocation:CLLocation?
    @IBOutlet var savedClassButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      getTeamKeys()

        savedClassButton.backgroundColor = UIColor.red
        getWUADLoc()
        releaseLocationManager.startUpdatingLocation()
    }
    
    func getWUADLoc(){
        let homeLocation = CLLocationCoordinate2DMake(myLat, myLong)
        self.releaseLocationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            releaseLocationManager.delegate = self
            releaseLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
        }
        
        let releaseSpan = MKCoordinateSpan.init(latitudeDelta: 0.95, longitudeDelta: 0.95)
        let releaseRegion = MKCoordinateRegion( center: homeLocation, span: releaseSpan)
        releaseMap.setRegion(releaseRegion, animated: true)
        self.releaseMap.setRegion(releaseRegion, animated: true)
        releaseLocationManager.delegate = self
        releaseLocationManager.requestWhenInUseAuthorization()
        homeAnno.coordinate = homeLocation
        homeAnno.title = "WUAD Loft"
        releaseMap.addAnnotation(homeAnno)
        
        releaseLocationManager.stopUpdatingLocation()
    }
    
    func locationManager( _ releaseLocationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(releaseLocationManager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks?.first
                
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        let homeLocationLatLong = CLLocation(latitude: myLat, longitude: myLong)
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            let hereLat = (containsPlacemark.location!.coordinate.latitude.description as NSString).doubleValue
            let hereLong = (containsPlacemark.location!.coordinate.longitude.description as NSString).doubleValue
            let relLocation = CLLocation(latitude: hereLat , longitude: hereLong)
            let annoCoor = CLLocationCoordinate2D(latitude: hereLat, longitude: hereLong)
            relAnno.coordinate = annoCoor
            relAnno.title = "Release Location"
            
            releaseMap.addAnnotation(relAnno)
            //var distance = homeLocationLatLong.distance(from: relLocation)
            distance = homeLocationLatLong.distance(from: relLocation)
                distance = distance * 0.000621371192
            
           //var compass: Double
            compass = getBearingBetweenTwoPoints1(homeLocationLatLong, point2: relLocation)
            compass = compass + 180.00
            if compass > 360.00 {
                compass = compass - 180.00
            }
           // let compasstext = windDirectionFromDegrees(compass)
            compasstext = windDirectionFromDegrees(compass)
            self.distanceRelease.text = "Class=\(chartTeam!) " +  (NSString(format:"%.01f miles to Loft  " as NSString, distance) as String) as String
            self.distanceRelease.text = distanceRelease.text! + " Direction= \(compasstext)"
            distanceDB = String(format:"%.01f", distance) + "miles / " + compasstext
        }
        releaseLocationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    // Mark Direction of release
    func degreesToRadians(_ degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(_ point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(point2.coordinate.latitude);
        let lon2 = degreesToRadians(point2.coordinate.longitude);
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        
        return radiansToDegrees(radiansBearing)
    }
    //mark end
    
    //mark degrees to compass text
    func windDirectionFromDegrees(_ degrees: Double) -> String {
        var hour1WindDirection: String
        if (348.75 <= degrees && degrees <= 360) {
            hour1WindDirection = "North   "
        } else if (0 <= degrees && degrees <= 11.25) {
            hour1WindDirection = "North   ";
        } else if (11.25 < degrees && degrees <= 33.75) {
            hour1WindDirection = "NorthNE ";
        } else if (33.75 < degrees && degrees <= 56.25) {
            hour1WindDirection = "North E ";
        } else if (56.25 < degrees && degrees <= 78.75) {
            hour1WindDirection = "East NE ";
        } else if (78.75 < degrees && degrees <= 101.25) {
            hour1WindDirection = "East    ";
        } else if (101.25 < degrees && degrees <= 123.75) {
            hour1WindDirection = "East SE ";
        } else if (123.75 < degrees && degrees <= 146.25) {
            hour1WindDirection = "South E ";
        } else if (146.25 < degrees && degrees <= 168.75) {
            hour1WindDirection = "SouthSE ";
        } else if (168.75 < degrees && degrees <= 191.25) {
            hour1WindDirection = "South   ";
        } else if (191.25 < degrees && degrees <= 213.75) {
            hour1WindDirection = "SouthSW ";
        } else if (213.75 < degrees && degrees <= 236.25) {
            hour1WindDirection = "SouthW  ";
        } else if (236.25 < degrees && degrees <= 258.75) {
            hour1WindDirection = "WestSW  ";
        } else if (258.75 < degrees && degrees <= 281.25) {
            hour1WindDirection = "West    ";
        } else if (281.25 < degrees && degrees <= 303.75) {
            hour1WindDirection = "WestNW  ";
        } else if (303.75 < degrees && degrees <= 326.25) {
            hour1WindDirection = "NorthW  ";
        } else if (326.25 < degrees && degrees < 348.75) {
            hour1WindDirection = "NorthNW ";
        } else {
            hour1WindDirection = "unknown ";
        }
        return hour1WindDirection
    }
    
//    @IBAction func classCommentPressed(_ sender: AnyObject) {
//        // Mark Get The Class Members and Post Class Train Release Info
//        let dateDB = Date()
//        let dateFormatterDB = DateFormatter()
//        dateFormatterDB.dateFormat = "yyyy-MM-dd" 
//        let dateStringDB = dateFormatterDB.string(from: dateDB)
//       
//        let query = CKQuery(recordType: "NWDRS_Log", predicate: NSPredicate(value: true))
//        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
//        records?.forEach({ (record) in
//        
//
//
//                    self.nwdrs_Private_DB.save(record) { (record, error) in
//                        DispatchQueue.main.async {
//                            self.navigationItem.backBarButtonItem?.isEnabled = true
//                            if let error = error {
//                                print(error)
//                            }else{
//                                HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Congratulations, your comment was saved successfully.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
//                                    if completed == true{
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            })
//        }
//       
//
//        let requestDB = NSMutableURLRequest(url: URL(string: "http://davestucky.com/birdtrainmiles.php")!)
//        requestDB.httpMethod = "POST"
//        let postStringDB = "class=\(chartTeam!)&date=\(dateStringDB)&desc=\(distanceDB!)"
//        requestDB.httpBody = postStringDB.data(using: String.Encoding.utf8)
//        let taskDB = URLSession.shared.dataTask(with: requestDB as URLRequest) {
//            data, response, error in
//            
//            if error != nil {
//                print("error=\(String(describing: error))")
//                return
//            }
//            
//            print("response = \(response!)")
//            
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("responseString = \(responseString!)")
//        }
//        
//        taskDB.resume()
//        savedClassButton.backgroundColor = UIColor.green
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {self.savedClassButton.backgroundColor = UIColor.red})
//        
//    }
    
    //MARK - fill picker view with teamColor
    func getTeamKeys(){
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "NWDRS_Log", predicate: predicate)
        nwdrs_Private_DB.perform(query, inZoneWith: nil,
                                 completionHandler: ({results, error in
                                    
                                    if (error != nil) {
                                        DispatchQueue.main.async() {
                                            HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "(error?.localizedDescription)!", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                                                if completed == true{
                                                }
                                            }
                                        }
                                    } else {
                                        for row in 0...results!.count-1 {
                                            DispatchQueue.main.async() {
                                                
                                                let record = results![row]
                                                currentRecord = record
                                                //print(currentRecord?.object(forKey: "bird_class_band_color")  as? String ?? nil!)
                                                
                                                teamBirdClassBand = currentRecord?.object(forKey: "bird_class_band_color")  as? String
                                                
                                                allTeamColors.add(teamBirdClassBand!)
                                                self.teamPicker.reloadAllComponents()
                                            }
                                        }
                                    }
                                 }))
//        let predicate = NSPredicate(value: true)
//
//        let query = CKQuery(recordType: "NWDRS_Log", predicate: predicate)
//        nwdrs_Private_DB.perform(query, inZoneWith: nil,
//                                 completionHandler: ({results, error in
//
//                                    if (error != nil) {
//                                        DispatchQueue.main.async() {
//                                            self.notifyUser("Cloud Access Error",
//                                                            message: (error?.localizedDescription)!)
//                                        }
//                                    } else {
//                                        if results!.count > 0 {
//
//                                            let record = results![0]
//                                            currentRecord = record
//
//                                            DispatchQueue.main.async() {
//                                                let teamBirdClassBand = record.object(forKey: "bird_class_band_color")  as? String
//
//                                                self.stuff.add(teamBirdClassBand!)
//                                            }
//                                        }
//                                    }
//                                 }))
//        let stuffs = Array(Set(stuff))

        
    }
    
    //MARK - Team Picker View Stuff
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return allTeamColors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return (allTeamColors[row] as! String)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let itemSelected: String = allTeamColors[row] as! String
        chartTeam = itemSelected
        
        self.distanceRelease.text = "Class  \(chartTeam!) " +  (NSString(format:"%.01f miles to Loft  " as NSString, distance) as String) as String
        self.distanceRelease.text = distanceRelease.text! + "  Direction = \(compasstext)"
        distanceDB = String(format:"%.01f", distance) + "miles / " + compasstext
        
        
    }
    
    //TPV end
    
    
}


