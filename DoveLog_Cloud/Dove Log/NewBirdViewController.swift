//
//  NewBirdViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 10/15/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit

class NewBirdViewController: UIViewController {

    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    //let zone = CKRecordZone(zoneName: "NWDRS")
    @IBOutlet var addBirdSource: UITextField!
    @IBOutlet var addBirdDOB: UITextField!
    @IBOutlet var addBirdSex: UITextField!
    @IBOutlet var addBandSource: UITextField!
    @IBOutlet var addBandYear: UITextField!
    @IBOutlet var addBandPrefix: UITextField!
    @IBOutlet var addBandNumber: UITextField!
    @IBOutlet var addBirthHenBand: UITextField!
    @IBOutlet var addBirthCockBand: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func ClearForm()
    {
        addBirdSource.text = ""
        addBirdDOB.text = ""
        addBirdSex.text = ""
        addBandSource.text = ""
        addBandYear.text = ""
        addBandPrefix.text = ""
        addBandNumber.text = ""
        addBirthHenBand.text = ""
        addBirthCockBand.text = ""
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "datehatchedseque"){
            let popup =  segue.destination as! DatePopupViewController
            popup.showTimePicker = false
            popup.onSave = { (data) in
                self.addBirdDOB.text = data
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        //format date
        let date = Date() //get the time, in this case the time an object was created.
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //format style. Browse online to get a format that fits your needs.
        let dateString = dateFormatter.string(from: date)
        //hack
        
        let record = CKRecord(recordType: "NWDRS_Log")
        
        record.setObject(dateString as CKRecordValue, forKey: "band_date")
        record.setObject(addBandNumber.text! as CKRecordValue, forKey: "band_no")
        record.setObject(addBandPrefix.text! as CKRecordValue, forKey: "band_prefix")
        record.setObject(addBandYear.text! as CKRecordValue, forKey: "band_year")
        record.setObject(addBirdDOB.text! as CKRecordValue, forKey: "bird_hatch_date")
        record.setObject(addBirdSex.text! as CKRecordValue, forKey: "bird_sex")
        record.setObject(addBirdSource.text! as CKRecordValue, forKey: "bird_source")
        record.setObject(addBirthCockBand.text! as CKRecordValue, forKey: "cock_band")
        record.setObject(addBirthHenBand.text! as CKRecordValue, forKey: "hen_band")

        self.navigationItem.backBarButtonItem?.isEnabled = false
        nwdrs_Private_DB.save(record) { (record, error) in
            DispatchQueue.main.async {
                self.navigationItem.backBarButtonItem?.isEnabled = true
                if let error = error {
                    print(error)
                }else{
                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Congratulations, your comment was saved successfully.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                        if completed == true{
                            self.ClearForm()
                        }
                }
            }
            
        }

    }
    
}
}
    

