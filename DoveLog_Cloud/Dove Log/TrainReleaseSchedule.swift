//
//  TrainReleaseSchedule.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 10/24/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
var currentRecord: CKRecord?
var allTeamColors = NSMutableArray()
var teamBirdClassBand:String?
var teamDateTrainBand:String?

class TrainingReleaseSchedule: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var cellTrainDate: UILabel!
    @IBOutlet var cellDistance: UILabel!
    @IBOutlet var trschedLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var trainClassPicker: UIPickerView!
    
   var stuff  = [CKRecord]()
    var values:NSArray = []
    var classLookUp:String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getTeamKeys()
         self.trainClassPicker.reloadAllComponents()
        // classLookUp = stuff[0] as! String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = stuff[indexPath.row]
        
        if let itemDate = item.object(forKey: "date_trained") as? String{
        let itemDistance = item.object(forKey:  "distance_direction") as? String
            cell.textLabel!.text = itemDate
            cell.detailTextLabel!.text = itemDistance
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func updateView(){
        let hasRecords = self.stuff.count > 0
        
        self.tableView.isHidden = !hasRecords
        trschedLabel.isHidden = hasRecords
        
    }
    
    @IBAction func classProgressPressed(_ sender: AnyObject) {
        stuff.removeAll()
        tableView.reloadData()
        getTrainSchedule()
        
        
    }
    
    func getTeamKeys(){
        
        let predicate = NSPredicate(value: true)
        
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
                                        for row in 0...results!.count-1 {
                                            DispatchQueue.main.async() {
                                                
                                            let record = results![row]
                                            currentRecord = record
                                            //print(currentRecord?.object(forKey: "bird_class_band_color")  as? String ?? nil!)
                                            
                                                teamBirdClassBand = currentRecord?.object(forKey: "bird_class_band_color")  as? String
                                                
                                                allTeamColors.add(teamBirdClassBand!)
                                                self.trainClassPicker.reloadAllComponents()
                                            }
                                        }
                                    }
                                 }))
        
    }
    //  Team Picker View Stuff
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return allTeamColors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return (allTeamColors[row] as! String)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let itemSelected: String = allTeamColors[row] as! String
        classLookUp = itemSelected
        
    }
    
    
    func getTrainSchedule() {
        let predicate = NSPredicate(format: "classcolor = %@", classLookUp)
        
        let query = CKQuery(recordType: "tbltrainrelease", predicate: predicate )
        
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        nwdrs_Private_DB.perform(query, inZoneWith: nil)  {records, error in records?.forEach({ (record) in
                                    
                                    guard error == nil else {
                                        HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "(error?.localizedDescription)!", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                                            if completed == true{
                                            }
                                        }
                                            return
                                        }
                                        
                                        self.stuff.append(record)
                                            DispatchQueue.main.async() {
                                                self.tableView.reloadData()
                                                self.trschedLabel.text = ""
                                                self.do_table_refresh()
                                                
            }
            })
            }
 }
   
    
        func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.trschedLabel.text = "Training history for \(self.classLookUp) class"
            self.tableView.reloadData()
            return
        })
    }
    
       
}

