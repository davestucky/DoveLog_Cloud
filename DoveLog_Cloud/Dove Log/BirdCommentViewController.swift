//
//  BirdCommentViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 10/19/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation


class BirdCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var stuff  = NSMutableArray()
    var currentRecord: CKRecord?
    var findBand: String!
    @IBOutlet var bandNoEdit: UILabel!
    @IBOutlet weak var commentType: UITextField!
    @IBOutlet var commentTabView: UITableView!
    @IBOutlet var dateComment: UITextField!
    @IBOutlet var newComment: UITextView!
    var values : NSArray = []
    var valuesbc:NSArray = []
    var editBandPrefix: String!
    var editBandYear: String!
    var logenter : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.commentTabView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if findBand != "LOFT"{
            getBirdEssentials()
            
        }else{
            bandNoEdit.text = "ALL BIRDS IN LOFT"
        }
        getBirdComments()
        bandNoEdit.textColor = UIColor.green
        bandNoEdit.textAlignment = NSTextAlignment.center
        bandNoEdit.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)
        self.dateComment.text = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
           }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editDatePopUp"){
            let popup =  segue.destination as! DatePopupViewController
            popup.showTimePicker = false
            popup.onSave = { (data) in
                self.dateComment.text = data
            }
        }
        if (segue.identifier == "toCommentTypePopUp"){
            let popup =  segue.destination as! CommentTypePopupViewController
            popup.onSave = { (data) in
                self.commentType.text = data
            }
        }
    }
    
    func onSave(_ data: String) -> () {
        commentType.text = data
    }
    
        func tableView(_ commentTabView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuff.count
    }
    
    func tableView(_ commentTabView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.commentTabView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = stuff[(indexPath as NSIndexPath).row] as? String
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    
    func tableView(_ commentTabView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func getBirdEssentials( ) {
                let predicate = NSPredicate(format: "band_no = %@", findBand)
        
                let query = CKQuery(recordType: "NWDRS_Log", predicate: predicate)
        print(query)
                nwdrs_Private_DB.perform(query, inZoneWith: nil,
                                             completionHandler: ({results, error in
        
                                                if (error != nil) {
                                                    DispatchQueue.main.async() {
                                                        HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "First egg hatched.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                                                            if completed == true{
                                                            }
                                                    }
                                                    }
                                                    
                                                } else {
                                                                if results!.count > 0 {
        
                                                                    let record = results![0]
                                                                    self.currentRecord = record
        
                                                                     DispatchQueue.main.async() {
        
                                                                        let bandNoPrefix =
                                                                            record.object(forKey: "band_prefix") as? String
                                                                        let bandNoYear =
                                                                            record.object(forKey: "band_year") as? String
        
                                                                        self.bandNoEdit.text = "Comments for " + bandNoPrefix! + " - " + self.findBand + " - " + bandNoYear!
                                                                    }
                                                    }
                                                                }
                                                                }))
          }

    func getBirdComments( ){
        let predicate = NSPredicate(format: "band_no = %@", findBand)
        
        let query = CKQuery(recordType: "tblBandComments", predicate: predicate )
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        nwdrs_Private_DB.perform(query, inZoneWith: nil, completionHandler: ({results, error in
            if (error != nil) {
                DispatchQueue.main.async() {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "First egg hatched.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
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
                        
                        let commentDate = record.object(forKey: "datecomment") as? String
                        let comment =  record.object(forKey: "comment") as? String
                        let commentType = record.object(forKey: "typecomment") as? String
                        let longinfo = commentDate! + " - " + commentType! + "  - " + comment!
                        self.stuff.add(longinfo)
                        self.commentTabView.reloadData()
                    }
                    }
                }
                }
            }))
       
     }

    @IBAction func saveCommentPressed(_ sender: AnyObject) {
        let record = CKRecord(recordType: "tblBandComments")
         record.setObject(findBand as CKRecordValue, forKey: "band_no")
        record.setObject(dateComment.text as CKRecordValue?, forKey: "datecomment")
        record.setObject(newComment.text! as CKRecordValue, forKey: "comment")
        record.setObject(commentType.text! as CKRecordValue, forKey: "typecomment")
        
            self.navigationItem.backBarButtonItem?.isEnabled = false
            nwdrs_Private_DB.save(record) { (record, error) in
                DispatchQueue.main.async {
                    self.navigationItem.backBarButtonItem?.isEnabled = true
                    if let error = error {
                        print(error)
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                        HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Comment NOT saved.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                            if completed == true{
                            }
                        }
                 }else{
                        HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Comment saved.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                            if completed == true{
                            }
                        }
                    }
                }
            }
          getBirdComments()
        bandNoEdit.text = ""
        }

}

