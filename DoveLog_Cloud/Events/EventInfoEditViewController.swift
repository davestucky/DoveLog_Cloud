//
//  EventInfoEditViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 8/26/17.
//  Copyright © 2017 DaveStucky. All rights reserved.
//

import UIKit
import EventKit
import CloudKit

class EventInfoEditViewController: UIViewController {
    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var currentRecord: CKRecord?
    var findEventKey: String!
    var find: String!
    var resultSet = NSArray()
     var values:NSArray = []
    @IBOutlet var editViewEvent: UIView!
    @IBOutlet var eventName: UITextField!
    @IBOutlet var eventLocName: UITextField!
    @IBOutlet var eventLocAddress: UITextField!
    @IBOutlet var eventLocCity: UITextField!
    @IBOutlet var eventLocState: UITextField!
    @IBOutlet var eventDate: UITextField!
    @IBOutlet var eventTime: UITextField!
    @IBOutlet var eventComments: UITextView!
    @IBOutlet var eventLocDirector: UITextField!
    @IBOutlet var eventEdit: UIButtonX!
    @IBOutlet var eventInfoSave: UIButtonX!
    @IBOutlet var reSched: UIButtonX!
    var savedEventId : String = ""
     var idRecordNo: CKRecord.ID!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getEventRequested()
        allTextFieldsDisabled()
        eventInfoSave.isHidden = true
        reSched.isHidden = true
       
    }
    
    func getEventRequested(){
        
        let predicate = NSPredicate(format: "eventkey = %@", findEventKey)
        
        let query = CKQuery(recordType: "tblEvents", predicate: predicate)
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
                                                
                                                self.eventName.text = record.object(forKey: "eventname") as? String
                                                self.eventLocName.text = record.object(forKey: "locname") as? String
                                                self.eventLocAddress.text = record.object(forKey: "locaddress")  as? String
                                                self.eventLocCity.text =  record.object(forKey: "loccity")  as? String
                                                self.eventLocState.text  = record.object(forKey: "locstate")  as? String
                                                self.eventDate.text =  record.object(forKey: "eventdate")  as? String
                                                self.eventTime.text = record.object(forKey: "eventtime")  as? String
                                                self.eventComments.text = record.object(forKey: "specialinstructions")  as? String
                                                self.eventLocDirector.text = record.object(forKey: "eventcontactname")  as? String
                                                self.savedEventId = (record.object(forKey: "eventcalID")  as? String)!
                                                self.idRecordNo = record.recordID
                                            }
                                        }
                                    }
                                 }))
        }
    
    //MARK Disable All Textfields   :
    func allTextFieldsDisabled(){
        self.eventName.isUserInteractionEnabled = false
        self.eventLocName.isUserInteractionEnabled = false
        self.eventLocAddress.isUserInteractionEnabled = false
        self.eventLocCity.isUserInteractionEnabled = false
        self.eventLocState.isUserInteractionEnabled = false
        self.eventDate.isUserInteractionEnabled = false
        self.eventTime.isUserInteractionEnabled = false
        self.eventComments.isUserInteractionEnabled = false
        self.eventLocDirector.isUserInteractionEnabled = false
        
    }
    
    //MARK Enable All Textfields   :
    func allTextFieldsEnabled(){
        self.eventName.isUserInteractionEnabled = true
        self.eventLocName.isUserInteractionEnabled = true
        self.eventLocAddress.isUserInteractionEnabled = true
        self.eventLocCity.isUserInteractionEnabled = true
        self.eventLocState.isUserInteractionEnabled = true
        self.eventDate.isUserInteractionEnabled = true
        self.eventTime.isUserInteractionEnabled = true
        self.eventComments.isUserInteractionEnabled = true
        self.eventLocDirector.isUserInteractionEnabled = true
    }
    
    @IBAction func eventInfoSave(_ sender: AnyObject) {
        
        nwdrs_Private_DB.fetch(withRecordID: self.idRecordNo!) { [unowned self] record, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Challenge with function : \(error)")
                }
            } else {
                if let record = record {
                    record.setObject(self.eventName.text! as CKRecordValue, forKey: "eventname")
                    record.setObject(self.eventLocName.text! as CKRecordValue, forKey: "locname")
                    record.setObject(self.eventLocAddress.text! as CKRecordValue, forKey: "locaddress")
                    record.setObject(self.eventLocCity.text! as CKRecordValue, forKey: "loccity")
                    record.setObject(self.eventLocState.text! as CKRecordValue, forKey: "locstate")
                    record.setObject( self.eventDate.text! as CKRecordValue, forKey: "eventdate")
                    record.setObject(self.eventTime.text! as CKRecordValue, forKey: "eventtime")
                    record.setObject(self.eventComments.text! as CKRecordValue, forKey: "specialinstructions")
                    record.setObject(self.eventLocDirector.text! as CKRecordValue, forKey: "eventcontactname")
                    record.setObject(self.savedEventId as CKRecordValue,forKey: "eventcalID")
                    self.nwdrs_Private_DB.save(record) { (record, error) in
                        DispatchQueue.main.async {
                            self.navigationItem.backBarButtonItem?.isEnabled = true
                            if let error = error {
                                print(error)
                            }else{
                                HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Congratulations, your comment was saved successfully.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
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
        
        
    @IBAction func eventEditPressed(_ sender: Any) {
        allTextFieldsEnabled()
        self.editViewEvent.backgroundColor = UIColor.green
        self.eventEdit.backgroundColor = UIColor.green
        self.eventInfoSave.backgroundColor = UIColor.green
        self.eventInfoSave.isHidden = false
        
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

