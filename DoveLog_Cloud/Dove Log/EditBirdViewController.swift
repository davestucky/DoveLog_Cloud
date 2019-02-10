//
//  EditBirdViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 10/15/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit

class EditBirdViewController: UIViewController {

     let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var currentRecord: CKRecord?
  
    var findBand: String! = ""
    var editband_source: String!
    var bandNoEdit: String!
    @IBOutlet var editbirdsource: UITextField!
    @IBOutlet var editBirdDOB: UITextField!
    @IBOutlet var editBirdSex: UITextField!
    @IBOutlet var editView: UIView!
   @IBOutlet var editBirthHenBand: UITextField!
    @IBOutlet var editBirthCockBand: UITextField!
    @IBOutlet var editBirdClassBand: UITextField!
    @IBOutlet var editBandInfo: UILabel!
    var editBandYear: String!
    var editBandPrefix: String!
    var idRecordNo: CKRecord.ID!

    let datePicker = UIDatePicker()
    
    var values:NSArray = []
    var valuesbc:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        getBirdEssentials()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "birdcomments"{
            let destinationVC : BirdCommentViewController  = segue.destination as! BirdCommentViewController
            destinationVC.findBand = findBand
            destinationVC.editBandPrefix = editBandPrefix
            destinationVC.editBandYear = editBandYear
        }
    }

        func getBirdEssentials( ) {
            let predicate = NSPredicate(format: "band_no = %@", findBand)
            
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
                                            if results!.count > 0 {
                                                
                                                let record = results![0]
                                                self.currentRecord = record
                                                
                                                DispatchQueue.main.async() {
                                                    
                                                    self.editBandPrefix = record.object(forKey: "band_prefix") as? String
                                                    self.editBandYear =  record.object(forKey: "band_year") as? String
                                                    self.editbirdsource.text = record.object(forKey: "bird_source")  as? String
                                                    self.editBirdSex.text = record.object(forKey: "bird_sex")  as? String
                                                    self.editBirdDOB.text = record.object(forKey: "bird_hatch_date")  as? String
                                                    self.editBirthHenBand.text = record.object(forKey: "hen_band")  as? String
                                                    self.editBirthCockBand.text = record.object(forKey: "cock_band")  as? String
                                                    self.editBirdClassBand.text = record.object(forKey: "bird_class_band_color")  as? String
                                                    self.idRecordNo = record.recordID
                                                    self.editBandInfo.text = "Comments for " + self.editBandPrefix! + " - " + self.findBand + " - " + self.editBandYear!
                                                }
                                            }
                                        }
                                     }))
        }

    
    @IBAction func saveEditPressed(_ sender: AnyObject) {
        
        nwdrs_Private_DB.fetch(withRecordID: self.idRecordNo!) { [unowned self] record, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Challenge with function : \(error)")
                }
            } else {
                if let record = record {
                    record.setObject(self.editBandPrefix  as CKRecordValue, forKey: "band_date")
                    record.setObject(self.editBandPrefix! as CKRecordValue, forKey: "band_prefix")
                    record.setObject(self.editBandYear! as CKRecordValue, forKey: "band_year")
                    record.setObject(self.editBirdDOB.text! as CKRecordValue, forKey: "bird_hatch_date")
                    record.setObject(self.editBirdSex.text! as CKRecordValue, forKey: "bird_sex")
                    record.setObject( self.editbirdsource.text! as CKRecordValue, forKey: "bird_source")
                    record.setObject(self.editBirthCockBand.text! as CKRecordValue, forKey: "cock_band")
                    record.setObject(self.editBirthHenBand.text! as CKRecordValue, forKey: "hen_band")
                     record.setObject(self.editBirdClassBand.text! as CKRecordValue,forKey: "bird_class_band_color")
                    self.nwdrs_Private_DB.save(record) { (record, error) in
                        DispatchQueue.main.async {
                            self.navigationItem.backBarButtonItem?.isEnabled = true
                            if let error = error {
                                print(error)
                            }else{
                                HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Bird was edited successfully.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                                    if completed == true{
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
    }

    @IBAction func hatchDateSelected(_ sender: Any) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        editBirdDOB.inputView = datePicker
        datePicker.addTarget(self, action: #selector(EditBirdViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
    }

    @objc func datePickerValueChanged(sender: UIDatePicker) {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            editBirdDOB.text = dateFormatter.string(from: sender.date)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   }



