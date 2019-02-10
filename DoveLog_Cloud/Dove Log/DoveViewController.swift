//
//  DoveViewController.swift
//  MyDoveLog
//
//  Created by DaveStucky on 9/11/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit

class DoveViewController: UIViewController {
    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase

    @IBOutlet var companyName: UILabel!
    @IBOutlet var cockEggMate: UITextField!
    @IBOutlet var bandnotoedit: UITextField!
    @IBOutlet var quickComment: UITextField!
    var dateString: String!
    var dateHatch:String!
   var values:NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = (UserDefaults.standard.value(forKey: "coName") as? String) {
            companyName.text = name
        }
    }

    //Start Bird Edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "bandNumberGetter"){
            let popup =  segue.destination as! BandNumberPopupViewController
            popup.onSave = { (data) in
                self.bandnotoedit.text = data
                
            }
        }
        
        if segue.identifier == "editBird"  {
            let destinationVC : EditBirdViewController  = segue.destination as! EditBirdViewController
            destinationVC.findBand = bandnotoedit.text
            bandnotoedit.text = ""            }

  // Mark -- segue from Dove Log <Comment On>
                if segue.identifier == "comfromcom" {
            
            let destinationVC : BirdCommentViewController  = segue.destination as! BirdCommentViewController
            destinationVC.findBand = bandnotoedit.text
                   self.bandnotoedit.text = ""
        }
    }
    //End Bird Edit
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "comfromcom" {
            bandnotoedit.rightViewMode = .never
            if bandnotoedit.text == "" {
                let imageView = UIImageView(frame: CGRect (x: 0,  y:0, width: 30, height:20) )
                imageView.image = #imageLiteral(resourceName: "warningtriangle.png")
                imageView.contentMode = .scaleAspectFit
                bandnotoedit.rightView = imageView
                bandnotoedit.rightViewMode = .always
                return false
            }
            else {
                print("*** YEP, segue will occur")
            }
        }
        if identifier == "editBird" {
//                    guard bandnotoedit.hasValue,   let newbandedit = bandnotoedit.text  else {  return true }
            bandnotoedit.rightViewMode = .never
            if bandnotoedit.text == "" {
                let imageView = UIImageView(frame: CGRect (x: 0,  y:0, width: 30, height:20) )
                imageView.image = #imageLiteral(resourceName: "warningtriangle.png")
                imageView.contentMode = .scaleAspectFit
                bandnotoedit.rightView = imageView
                bandnotoedit.rightViewMode = .always
                return false
           }
            else {
                print("*** YEP, segue will occur")
            }
        }
        return true
    }
    
    //Start Lay Eggs
    @IBAction func henLayEggPressed(_ sender: AnyObject) {
        guard bandnotoedit.hasValue,   let newbandedit = bandnotoedit.text  else {  return }
        guard cockEggMate.hasValue,   let newCockMate = cockEggMate.text  else {  return }

        DateConfigurator()
        
        let record = CKRecord(recordType: "tblEggsLaid")
        
        record.setObject(dateString as CKRecordValue, forKey: "datelaid")
        record.setObject(bandnotoedit.text! as CKRecordValue, forKey: "band_no")
        record.setObject(cockEggMate.text! as CKRecordValue, forKey: "cockbandno")
        record.setObject(dateHatch as CKRecordValue, forKey: "estdatehatch")
        record.setObject(0 as CKRecordValue, forKey: "onedidhatch")
        record.setObject(0 as CKRecordValue, forKey: "twodidhatch")
        
        self.navigationItem.backBarButtonItem?.isEnabled = false
        nwdrs_Private_DB.save(record) { (record, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    print(error)
                }else{
                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Band #  \(self.bandnotoedit.text!) has laid an egg", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                        if completed == true{
                        }
                    }
                }
            }
        }
        bandnotoedit.text = ""
        cockEggMate.text = ""
    }
    //End Lay Eggs
  
    //Start Fake Eggs
    @IBAction func birdGivenFakeEggs(_ sender: AnyObject) {
                guard bandnotoedit.hasValue,   let newbandedit = bandnotoedit.text  else {  return }
        
        DateConfigurator()
        
        let record = CKRecord(recordType: "tblBandComments")
        record.setObject(dateString as CKRecordValue, forKey: "datecomment")
        record.setObject(bandnotoedit.text! as CKRecordValue, forKey: "band_no")
        record.setObject("Bird given Fake Eggs" as CKRecordValue, forKey: "comment")
        record.setObject("fakeegg" as CKRecordValue, forKey: "typecomment")
        
        self.navigationItem.backBarButtonItem?.isEnabled = false
        nwdrs_Private_DB.save(record) { (record, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    print(error)
                    
                }else{
                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Band Number \(newbandedit) given Fake Eggs", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                        if completed == true{
                        }
                    }
                }
            }
            
        }
        
        let recordegg = CKRecord(recordType: "tblEggsLaid")
        
        recordegg.setObject(self.dateString as CKRecordValue, forKey: "fakeeggplaced")
        record.setObject(dateHatch as CKRecordValue, forKey: "estdatehatch")
        recordegg.setObject(bandnotoedit.text! as CKRecordValue, forKey: "band_no")
        recordegg.setObject("Bird given Fake Eggs" as CKRecordValue, forKey: "comment")
        recordegg.setObject(1 as CKRecordValue, forKey: "fakeeggs")
        
        
        self.navigationItem.backBarButtonItem?.isEnabled = false
        nwdrs_Private_DB.save(recordegg) { (recordegg, error) in
            DispatchQueue.main.async {
                self.navigationItem.backBarButtonItem?.isEnabled = true
                if let error = error {
                    print(error)
                }else{
                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Band #  \(self.bandnotoedit.text!) given FAKE eggs", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                        if completed == true{
                        }
                    }
                  }
            }
        }
        bandnotoedit.text = ""
        cockEggMate.text = ""
    }
    //End Fake Eggs
    
    //Start Quick Comments
    @IBAction func birdGivenQuickComment(_ sender: AnyObject) {
      
         guard bandnotoedit.hasValue,   let newbandedit = bandnotoedit.text  else {  return }
      
         guard quickComment.hasValue,   let newquickcomment = quickComment.text  else {  return }
        
//        guard quickComment.text! != "" else {
//            HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Quick Comment not supplied", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
//                if completed == true{
//                }
//            }
//            return
//        }
        
        DateConfigurator()
        //hack
        let record = CKRecord(recordType: "tblBandComments")
        
        record.setObject(dateString as CKRecordValue, forKey: "datecomment")
        record.setObject(bandnotoedit.text! as CKRecordValue, forKey: "band_no")
        record.setObject(quickComment.text! as CKRecordValue, forKey: "comment")
        
        
        self.navigationItem.backBarButtonItem?.isEnabled = false
        nwdrs_Private_DB.save(record) { (record, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    print(error)
                }else{
                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Band #  \(newbandedit) Quick Comment Saved", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                        if completed == true{
                        }
                    }
                }
            }
            
        }
        bandnotoedit.text = ""
    }
    //End Quick Comments
   
    func DateConfigurator(){
    let date = Date() //get the time, in this case the time an object was created.
    //format date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" //format style. Browse online to get a format that fits your needs.
    dateString = dateFormatter.string(from: date)
    
    //Add 15 days to today
    let nextDay = (Calendar.current as NSCalendar).date(
        byAdding: .day,
        value: 15,
        to: date,
        options: NSCalendar.Options(rawValue: 0))
    dateHatch = dateFormatter.string(from: nextDay!)
    }
}

