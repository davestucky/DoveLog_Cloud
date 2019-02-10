//
//  WeddingInfoViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 9/30/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import EventKit
import CloudKit


class WeddingInfoViewController: UIViewController  {
    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var currentRecord: CKRecord?
    var wedBrideKey: String?
    @IBOutlet var bfname: UITextField!
    @IBOutlet var blname: UITextField!
    @IBOutlet var baddress: UITextField!
    @IBOutlet var bcity: UITextField!
    @IBOutlet var bstate: UITextField!
    @IBOutlet var bzip: UITextField!
    @IBOutlet var bphone: UITextField!
    @IBOutlet var bemail: UITextField!
    @IBOutlet var bmom: UITextField!
    @IBOutlet var bdad: UITextField!
    @IBOutlet var gfname: UITextField!
    @IBOutlet var glname: UITextField!
    @IBOutlet var gmom: UITextField!
    @IBOutlet var gdad: UITextField!
    @IBOutlet var weddate: UITextField!
    @IBOutlet var wedtime: UITextField!
    @IBOutlet var wedPhotoName: UITextField!
    @IBOutlet var wedPhotoAddress: UITextField!
    @IBOutlet var wedPhotoCity: UITextField!
    @IBOutlet var wedPhotoPhone: UITextField!
    @IBOutlet var wedPhotoEmail: UITextField!
    @IBOutlet var brideSave: UIButton!
    @IBOutlet var groomSave: UIButton!
    @IBOutlet var photogContacted: UISwitch!
    var savedEventId : String = ""    
    var objects = NSMutableArray()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bfname.becomeFirstResponder()
        
    }
    
    @IBAction func brideSavePressed(_ sender: UIButton?) {

        let record = CKRecord(recordType: "tblBridesInfo")
        
        record.setObject(bfname.text! + blname.text! as CKRecordValue, forKey: "wedbridekey")
        record.setObject(bfname.text! as CKRecordValue, forKey: "bridefname")
        record.setObject(blname.text! as CKRecordValue, forKey: "bridelname")
       record.setObject(baddress.text! as CKRecordValue, forKey: "brideaddress")
        record.setObject(bcity.text! as CKRecordValue, forKey: "bridecity")
        record.setObject(bstate.text! as CKRecordValue, forKey: "bridestate")
        record.setObject(bzip.text! as CKRecordValue, forKey: "bridezip")
       record.setObject(bphone.text! as CKRecordValue, forKey: "bridephone")
        record.setObject(bemail.text! as CKRecordValue, forKey: "brideemail")
        record.setObject(bmom.text! as CKRecordValue, forKey: "bridemom")
        record.setObject(bdad.text! as CKRecordValue, forKey: "bridedad")
        record.setObject(weddate.text! as CKRecordValue, forKey: "weddate")
        record.setObject(wedtime.text! as CKRecordValue, forKey: "wedtime")
        
        self.navigationItem.backBarButtonItem?.isEnabled = false
        nwdrs_Private_DB.save(record) { (record, error) in
            DispatchQueue.main.async {
                self.navigationItem.backBarButtonItem?.isEnabled = true
                if let error = error {
                    print(error)
                }else{
                    print("Record was Saved")
                }
            }
        }
    }
    
    @IBAction func groomSavePressed(_ sender: UIButton?) {
        let record = CKRecord(recordType: "tblgroominfo")
        
        record.setObject(bfname.text! + blname.text! as CKRecordValue, forKey: "wedbridekey")
        record.setObject(gfname.text! as CKRecordValue, forKey: "groomfname")
        record.setObject(glname.text! as CKRecordValue, forKey: "groomlname")
        record.setObject(gmom.text! as CKRecordValue, forKey: "groommom")
        record.setObject(gdad.text! as CKRecordValue, forKey: "groomdad")
        record.setObject(bstate.text! as CKRecordValue, forKey: "bridestate")
        record.setObject(bzip.text! as CKRecordValue, forKey: "bridezip")
        record.setObject(bphone.text! as CKRecordValue, forKey: "bridephone")
        record.setObject(bemail.text! as CKRecordValue, forKey: "brideemail")
        record.setObject(bmom.text! as CKRecordValue, forKey: "bridemom")
        record.setObject(bdad.text! as CKRecordValue, forKey: "bridedad")
        record.setObject(weddate.text! as CKRecordValue, forKey: "weddate")
        record.setObject(wedtime.text! as CKRecordValue, forKey: "wedtime")
        
        self.navigationItem.backBarButtonItem?.isEnabled = false
        nwdrs_Private_DB.save(record) { (record, error) in
            DispatchQueue.main.async {
                self.navigationItem.backBarButtonItem?.isEnabled = true
                if let error = error {
                    print(error)
                }else{
                    print("Record was Saved")
                }
            }
        }
    }

    @IBAction func photoSavePressed(_ sender: Any) {
        
         let record = CKRecord(recordType: "tblPhotoInfo")
        
        record.setObject(bfname.text! + blname.text! as CKRecordValue, forKey: "wedbridekey")
        record.setObject(wedPhotoName.text! as CKRecordValue, forKey: "wedphotographer")
        record.setObject(wedPhotoAddress.text! as CKRecordValue, forKey: "wedPhotoAddress")
        record.setObject(bzip.text! as CKRecordValue, forKey: "photozip")
        record.setObject(wedPhotoPhone.text! as CKRecordValue, forKey: "photophone")
        record.setObject(wedPhotoEmail.text! as CKRecordValue, forKey: "photoemail")
        record.setObject(wedPhotoCity.text! as CKRecordValue, forKey: "photocity")
       
        
        self.navigationItem.backBarButtonItem?.isEnabled = false
        nwdrs_Private_DB.save(record) { (record, error) in
            DispatchQueue.main.async {
                self.navigationItem.backBarButtonItem?.isEnabled = true
                if let error = error {
                    print(error)
                }else{
                    print("Record was Saved")
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editDatePopUp"){
            let popup =  segue.destination as! DatePopupViewController
            popup.showTimePicker = false
            popup.onSave = { (data) in
                self.weddate.text = data
            }
        }
        
        if (segue.identifier == "editTimePopUp"){
            let popup =  segue.destination as! DatePopupViewController
            popup.showTimePicker = true
            popup.onSave = { (Data) in
                self.wedtime.text = Data
            }
        }
    }
    
    
    @IBAction func addEvent(_ sender: UIButton) {
        let eventStore = EKEventStore()
        
        let startDate = "\(self.weddate.text!) \(String(describing: self.wedtime.text!))"
        
        //string to date
        let dateformatter = DateFormatter()
        //dateformatter.locale
        dateformatter.dateFormat = "MM/dd/yy h:mm a"
        let caldate = dateformatter.date(from: startDate)        //done
        let endDate = caldate?.addingTimeInterval(60 * 60) // One hour
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(eventStore, title: "Wedding for \(self.bfname!) \(self.blname!)", startDate: caldate!, endDate: endDate!)
            })
        } else {
            createEvent(eventStore, title: "Wedding for  \(self.bfname.text!) \(String(describing: self.blname.text!))", startDate: caldate!, endDate: endDate!)
        }
    }
    
    
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }


}
