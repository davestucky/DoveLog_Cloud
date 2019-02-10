//
//  EventInfoViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 8/24/17.
//  Copyright © 2017 DaveStucky. All rights reserved.
//

import UIKit
import EventKit
import CloudKit


class EventInfoViewController: UIViewController {
    
    @IBOutlet var eventName: UITextField!
    @IBOutlet var eventLocName: UITextField!
    @IBOutlet var eventLocAddress: UITextField!
    @IBOutlet var eventLocCity: UITextField!
    @IBOutlet var eventLocState: UITextField!
    @IBOutlet var eventDate: UITextField!
    @IBOutlet var eventTime: UITextField!
    @IBOutlet var eventComments: UITextView!
    @IBOutlet var eventLocDirector: UITextField!
    var savedEventId = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editDatePopUp"){
            let popup =  segue.destination as! DatePopupViewController
            popup.showTimePicker = false
            popup.onSave = { (data) in
                self.eventDate.text = data
            }
            }
        
        if (segue.identifier == "editTimePopUp"){
            let popup =  segue.destination as! DatePopupViewController
            popup.showTimePicker = true
            popup.onSave = { (Data) in
                self.eventTime.text = Data
            }
        }
    }
    
    
    @IBAction func eventInfoSave(_ sender: AnyObject) {
        
        let record = CKRecord(recordType: "tblEvents")
        
        record.setObject(eventLocAddress.text! as CKRecordValue, forKey: "locaddress")
        record.setObject(eventName.text! as CKRecordValue, forKey: "eventname")
        record.setObject(eventDate.text! as CKRecordValue, forKey: "eventdate")
        record.setObject(eventTime.text! as CKRecordValue, forKey: "eventtime")
        record.setObject(eventLocName.text! as CKRecordValue, forKey: "locname")
        record.setObject(eventLocCity.text! as CKRecordValue, forKey: "loccity")
        record.setObject(eventLocState.text! as CKRecordValue, forKey: "locstate")
        record.setObject(eventLocDirector.text! as CKRecordValue, forKey: "eventcontactname")
        record.setObject(savedEventId as CKRecordValue, forKey: "eventcalID")
        record.setObject(eventComments.text! as CKRecordValue, forKey: "specialinstructions")
        record.setObject(eventName.text! as CKRecordValue, forKey: "eventkey")
        
        
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
    
    @IBAction func addEvent(_ sender: UIButton) {
        let eventStore = EKEventStore()
        let startDate = "\(self.eventDate.text!) \(String(describing: self.eventTime.text!))"
        //string to date
        let dateformatter = DateFormatter()
        //dateformatter.locale
        dateformatter.dateFormat = "MM/dd/yy h:mm a"
        let caldate = dateformatter.date(from: startDate)        //done
        let endDate = caldate?.addingTimeInterval(60 * 60) // One hour
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(eventStore, title: "Dove release for \(self.eventName.text!)", startDate: caldate!, endDate: endDate!)
            })
        } else {
            createEvent(eventStore, title: "Dove release for \(self.eventName.text!)", startDate: caldate!, endDate: endDate!)
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

