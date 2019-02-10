//
//  DoveEggsViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 11/7/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit 

class DoveEggsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
     let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    @IBOutlet var tableView: UITableView!
    var stuff  =  [CKRecord]()
    var values = [CKRecord]()
    var birdListReal = [BirdsWithEggs]()
    var birdListFake = [BirdsWithEggs]()
    var seqID = 0
    var seqHenBand: String = ""
    var seqCockBand: String  = ""
    var seqHatchDate: String  = ""
    let today = Date() as Date
    //let fallsBetween: Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        getAllBirdsWithEggs()
        getAllBirdsWithFakeEggs()

        
    }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let eggLabel = UILabel()
        if section == 0 {
           eggLabel.text = "Birds with Real Eggs"
            eggLabel.backgroundColor = UIColor.lightGray
        } else {
            eggLabel.text = "Birds with Fake Eggs"
            eggLabel.backgroundColor = UIColor.lightGray
        }
        return eggLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            
        return stuff.count
        }
        return values.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let startEggDate = Calendar.current.date(byAdding: .day, value: +18, to: today)! as Date
        let blueEggDate = Calendar.current.date(byAdding: .day, value: +12, to: today)! as Date
        let yellowEggDate = Calendar.current.date(byAdding: .day, value: +6, to: today)! as Date
        let greenEggDate = Calendar.current.date(byAdding: .day, value: +5, to: today)! as Date
        let redEggDate = Calendar.current.date(byAdding: .day, value: -1, to: today)! as Date
        let outEggDate = Calendar.current.date(byAdding: .day, value: -6, to: today)! as Date
        let myEggDate = Calendar.current.date(byAdding: .day, value: -1, to: today)! as Date

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WUADCouplesEggs
        let item = indexPath.section == 0 ? stuff[(indexPath as NSIndexPath).row] : values[(indexPath as NSIndexPath).row]
        if indexPath.section == 0 {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let curHatchDate = dateFormat.date(from: (item.object(forKey: "estdatehatch") as? String)!)!
        var fallsBetween = (blueEggDate...startEggDate).contains(curHatchDate)
            if fallsBetween{
                cell.henBand?.textColor = UIColor.blue
                cell.cockBand?.textColor = UIColor.blue
                cell.estdatehatch?.textColor = UIColor.blue
                }
            else if curHatchDate == blueEggDate{
                cell.henBand?.textColor = UIColor.blue
                cell.cockBand?.textColor = UIColor.blue
                cell.estdatehatch?.textColor = UIColor.blue
                }
            else if curHatchDate == startEggDate{
                cell.henBand?.textColor = UIColor.blue
                cell.cockBand?.textColor = UIColor.blue
                cell.estdatehatch?.textColor = UIColor.blue
        }
            fallsBetween = (yellowEggDate...blueEggDate).contains(curHatchDate)
            if fallsBetween{
                cell.henBand?.textColor = UIColor.orange
                cell.cockBand?.textColor = UIColor.orange
                cell.estdatehatch?.textColor = UIColor.orange
            }
            else if curHatchDate == yellowEggDate{
                cell.henBand?.textColor = UIColor.orange
                cell.cockBand?.textColor = UIColor.orange
                cell.estdatehatch?.textColor = UIColor.orange
            }
            else if curHatchDate == blueEggDate{
                cell.henBand?.textColor = UIColor.orange
                cell.cockBand?.textColor = UIColor.orange
                cell.estdatehatch?.textColor = UIColor.orange
        }
            fallsBetween = (myEggDate...greenEggDate).contains(curHatchDate)
            if fallsBetween{
                cell.henBand?.textColor = UIColor.green
                cell.cockBand?.textColor = UIColor.green
                cell.estdatehatch?.textColor = UIColor.green
            }
            else if curHatchDate == myEggDate{
                cell.henBand?.textColor = UIColor.green
                cell.cockBand?.textColor = UIColor.green
                cell.estdatehatch?.textColor = UIColor.green
            }
            else if curHatchDate == greenEggDate{
                cell.henBand?.textColor = UIColor.green
                cell.cockBand?.textColor = UIColor.green
                cell.estdatehatch?.textColor = UIColor.green
        }
            fallsBetween = (outEggDate...redEggDate).contains(curHatchDate)
            if fallsBetween{
                cell.henBand?.textColor = UIColor.red
                cell.cockBand?.textColor = UIColor.red
                cell.estdatehatch?.textColor = UIColor.red
            }
            else if curHatchDate == outEggDate{
                cell.henBand?.textColor = UIColor.red
                cell.cockBand?.textColor = UIColor.red
                cell.estdatehatch?.textColor = UIColor.red
            }
            else if curHatchDate == redEggDate{
                cell.henBand?.textColor = UIColor.red
                cell.cockBand?.textColor = UIColor.red
                cell.estdatehatch?.textColor = UIColor.red
        }
            
        }
            cell.henBand!.text = item.object(forKey: "band_no") as? String
            cell.cockBand!.text = item.object(forKey: "cockbandno") as? String
            cell.estdatehatch!.text = item.object(forKey: "estdatehatch") as? String
//        self.idRecordNo = record.recordID
            cell.IDNumber = item.recordID
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = birdListReal[(indexPath as NSIndexPath).row]
        seqID = item.ID
        seqHenBand = item.henband
        seqCockBand = item.cockband
        seqHatchDate = item.estdatehatch
        self.performSegue(withIdentifier: "updateegginfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "updateegginfo" {
            let destinationVC : EditEggViewController  = segue.destination as! EditEggViewController
            destinationVC.IDNumber = seqID
            destinationVC.henbandlabel = seqHenBand
            destinationVC.cockbandlabel = seqCockBand
            destinationVC.datehatchlabel = seqHatchDate

            }
        }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let firsthatchdate = dateformatter.string(from: NSDate() as Date)
        let secondhatchdate = dateformatter.string(from: NSDate() as Date)
        
        let eggOneHatch = UITableViewRowAction(style: .normal, title: "1st Hatch") { (action, indexPath) in
            // MARK
            let currentCell = tableView.cellForRow(at: indexPath)! as! WUADCouplesEggs
            let finder = currentCell.IDNumber
            self.nwdrs_Private_DB.fetch(withRecordID: finder!) { [unowned self] record, error in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Challenge with function : \(error)")
                    }
                } else {
                    if let record = record {
                        
                        record.setObject(1  as CKRecordValue, forKey: "onedidhatch")
                        record.setObject( firsthatchdate as CKRecordValue, forKey: "onehatched")
                        
                        self.nwdrs_Private_DB.save(record) { (record, error) in
                            DispatchQueue.main.async {
                                self.navigationItem.backBarButtonItem?.isEnabled = true
                                if let error = error {
                                    print(error)
                                }else{
                                    HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "First egg hatched.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
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
        
            eggOneHatch.backgroundColor = UIColor.green
        
        
            let eggTwoHatch = UITableViewRowAction(style: .normal, title: "2nd Hatch") { (action, indexPath) in
            // MARK
                let currentCell = tableView.cellForRow(at: indexPath)! as! WUADCouplesEggs
                let finder = currentCell.IDNumber
                self.nwdrs_Private_DB.fetch(withRecordID: finder!) { [unowned self] record, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            print("Challenge with function : \(error)")
                        }
                    } else {
                        if let record = record {
                            record.setObject(1  as CKRecordValue, forKey: "twodidhatch")
                            record.setObject( secondhatchdate as CKRecordValue, forKey: "twohatched")
                            
                            self.nwdrs_Private_DB.save(record) { (record, error) in
                                DispatchQueue.main.async {
                                    self.navigationItem.backBarButtonItem?.isEnabled = true
                                    if let error = error {
                                        print(error)
                                    }else{
                                        HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "First egg hatched.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
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
        eggTwoHatch.backgroundColor = UIColor.green

        return [eggTwoHatch, eggOneHatch]
    }

    func getAllBirdsWithEggs(){
        
       let predicate = NSPredicate(format: "twodidhatch = 0 AND fakeeggs = 0" )
        
        let query = CKQuery(recordType: "tblEggsLaid", predicate: predicate)

        query.sortDescriptors = [NSSortDescriptor(key: "estdatehatch", ascending: false)]

        nwdrs_Private_DB.perform(query, inZoneWith: nil)  {records, error in records?.forEach({ (record) in

            guard error == nil else {
                HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Comment NOT saved.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                    if completed == true{
                    }
                }
                return
            }

            self.stuff.append(record)
//            if self.stuff.count == 0 {
//
//            }
            
            DispatchQueue.main.sync {
                self.tableView.reloadData()
                //                self.messageLabel.text = ""
                //                updateView()
            }
        })
        }
    }
   
    func getAllBirdsWithFakeEggs(){
    let fakepredicate = NSPredicate(format: "fakeeggs = 1")
    let query = CKQuery(recordType: "tblEggsLaid", predicate: fakepredicate)
    
    query.sortDescriptors = [NSSortDescriptor(key: "estdatehatch", ascending: false)]
    
    nwdrs_Private_DB.perform(query, inZoneWith: nil)  {records, error in records?.forEach({ (record) in
    
    guard error == nil else {
        HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Cloud Access Error.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
            if completed == true{
            }
        }
    
    return
    }
    self.values.append(record)
        //print(self.values)
    
    DispatchQueue.main.sync {
    self.tableView.reloadData()
    //                self.messageLabel.text = ""
    //                updateView()
    }
    })
    }
}

}

