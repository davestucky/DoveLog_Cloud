//
//  WeddingLandViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 4/25/17.
//  Copyright © 2017 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit


class WeddingLandViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var currentRecord: CKRecord?
    var values = [String]()
    @IBOutlet var weddingPickerText: UITextField!
    @IBOutlet var venAddress: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let bridePicker = UIPickerView()
        bridePicker.delegate = self
        weddingPickerText.inputView = bridePicker
        getBrideKeys()
        
}

    func getBrideKeys()
    {
         self.values.removeAll()
        
        let predicate = NSPredicate(value:  true)
        
        let query = CKQuery(recordType: "tblBridesInfo", predicate: predicate )
        //query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        nwdrs_Private_DB.perform(query, inZoneWith: nil, completionHandler: ({results, error in
            if (error != nil) {
                DispatchQueue.main.async() {
                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "(error?.localizedDescription)!.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                        if completed == true{
                        }
                    }
                }
            } else {
                
                if results == []{
                    return
                }else{
                    
                    for row in 0...results!.count-1 {
                        let record = results![row]
                        self.currentRecord = record
                        
                        DispatchQueue.main.async() {
                            
                            let bridePicker = record.object(forKey: "wedbridekey") as! String
                           
                            self.values.append(bridePicker)
                            //self.commentTabView.reloadData()
                        }
                    }
                }
            }
        }))
        
        
        
        
        
        
//        let url = URL(string: "http://davestucky.com/service.php?task=getkeys")
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            if error != nil {
//                print("didn't work, \(String(describing: error))")
//                DispatchQueue.main.asyncAfter(deadline: .now() ) {
//                    // todo
//                }
//            } else {
//                do {
//                    self.values = try JSONDecoder().decode([WeddingKey].self, from: data!)
//                }catch {
//                    print("JSON Error")
//                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
//                        // todo
//                    }
//                }
//            }
//            }.resume()
    }
    
    func numberOfComponents(in bridePicker: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ bridePicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
        
    }
    
    func pickerView(_ bridePicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
        
        }
    
    func pickerView(_ bridePicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weddingPickerText.text = values[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditWedInfo"){
            
            let destinationVC : WeddingEditViewController  = segue.destination as! WeddingEditViewController
            destinationVC.findWedBrideKey = weddingPickerText.text!
            
        }
        
        if (segue.identifier == "mapVenue"){
            let destinationVC : venueMapViewController  = segue.destination as! venueMapViewController
            destinationVC.locationVenue = venAddress.text!
            //destinationVC.venueName = venue.text!
        }

    }

}
