//
//  BandNumberViewController.swift
//  DoveLog_Cloud
//
//  Created by Dave Stucky on 12/17/18.
//  Copyright © 2018 Dave Stucky. All rights reserved.
//
import UIKit
import CloudKit

class BandNumberPopupViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bandPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    var selectedBand: String?
    var onSave: (( _ data: String) -> ())?
    //Mark Cloudkit Stuff
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var currentRecord: CKRecord?
    var values = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetBandNumbers()
        
    }
    
    func createBandNumberPicker() {
        let bandPicker = UIPickerView()
        bandPicker.delegate = self
    }
    
    @IBAction func saveDate_TouchUpInside(_ sender: UIButton) {
        onSave?(selectedBand!)
        dismiss(animated: true)
    }
    
    func GetBandNumbers(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "NWDRS_Log", predicate: predicate)
        nwdrs_Private_DB.perform(query, inZoneWith: nil, completionHandler: ({results, error in
            
            if (error != nil) {
                DispatchQueue.main.async() {
                    self.notifyUser("Cloud Access Error",
                                    message: error!.localizedDescription)
                }
            } else {
                for row in 0...results!.count-1 {
                    
                    let record = results![row]
                    self.currentRecord = record
                    
                    DispatchQueue.main.async() {
                        
                        let bandNumber = record.object(forKey: "band_no") as? String
                        let longinfo = bandNumber
                        self.values.add(longinfo!)
                        self.bandPicker.reloadAllComponents()
                        self.selectedBand = (self.values[0] as! String)
                    }
                }
            }
        }))
    }
}

extension  BandNumberPopupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBand = values[row] as? String
    }
    
    func notifyUser(_ title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true,
                     completion: nil)
    }
}

