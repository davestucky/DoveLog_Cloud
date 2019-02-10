//
//  EventLandViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 8/27/17.
//  Copyright © 2017 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit
class EventLandViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var currentRecord: CKRecord?
    var values = [String]()
    @IBOutlet var eventPickerText: UITextField!
    @IBOutlet var eventAddress: UITextField!
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewDidLoad()
        let eventPicker = UIPickerView()
        eventPicker.delegate = self
        eventPickerText.inputView = eventPicker
        getEventKeys()
    }
    
    func getEventKeys()
    {
         self.values.removeAll()
        
        let predicate = NSPredicate(value:  true)
        
        let query = CKQuery(recordType: "tblEvents", predicate: predicate )
        //query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        nwdrs_Private_DB.perform(query, inZoneWith: nil, completionHandler: ({results, error in
            if (error != nil) {
                DispatchQueue.main.async() {
                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "(error?.localizedDescription)!", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
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
                            let eventPickerText = record.object(forKey: "eventkey") as? String
                            
                            self.values.append(eventPickerText! )
                            //self.commentTabView.reloadData()
                        }
                    }
                }
            }
        }))
    }
    
    
    func numberOfComponents(in eventPicker: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ eventPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
        
    }
    
    func pickerView(_ bridePicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventPickerText.text = values[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editEventInfo"){
            
            let destinationVC : EventInfoEditViewController  = segue.destination as! EventInfoEditViewController
            destinationVC.findEventKey = eventPickerText.text!
            self.eventPickerText.text = ""
            
        }
        
        /* if (segue.identifier == "mapVenue"){
         let destinationVC : venueMapViewController  = segue.destination as! venueMapViewController
         destinationVC.locationVenue = venAddress.text!
         //destinationVC.venueName = venue.text!
         }*/
    }
    
}
