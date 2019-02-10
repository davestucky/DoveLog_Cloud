//
//  DoveInventoryTable.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 11/1/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit


class DoveInventoryTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    @IBOutlet var tableView: UITableView!
    var stuff  = [CKRecord]()
    var values:NSArray = []
    var birdlist = [Birdies]()
    var selectedBirds: [Int:String] = [:]
    var birdHere: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getAllBirdsList()
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stuff.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WUADCustomCellAll
        
        let item = stuff[(indexPath as NSIndexPath).row]
        
        cell.bandNumber!.text =  item.object(forKey: "band_no") as? String
        cell.bandyear!.text = (item.object(forKey: "band_year") as? String) 
        cell.bandPre!.text = item.object(forKey: "sex") as? String
        cell.bandClass.text = item.object(forKey: "bird_class_band_color") as? String
        cell.idRecordNo = item.recordID 
        if item.object(forKey: "bird_inven_here") as? Int == 0 {
            cell.bandInven?.setOn(false, animated: true)
        }else{
            cell.bandInven?.setOn(true, animated: true)
        }

        if item.object(forKey: "bird_inven_last") as? Int == 0 {
                cell.lastInven?.setOn(false, animated: true)
        }else{
                cell.lastInven?.setOn(true, animated: true)
        }
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stuff.removeAll()
        print(stuff)
        getAllBirdsList()
       tableView.reloadData()
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        

        
    }
    
    func getAllBirdsList(){
        stuff.removeAll()
         let query = CKQuery(recordType: "NWDRS_Log", predicate: NSPredicate(value: true))
        
        query.sortDescriptors = [NSSortDescriptor(key: "band_no", ascending: true)]
        
        nwdrs_Private_DB.perform(query, inZoneWith: nil)  {records, error in records?.forEach({ (record) in
            
            guard error == nil else {
            self.notifyUser("Cloud Access Error",
                                message: (error?.localizedDescription)!)
                return
            }
          self.stuff.append(record)
            print(self.stuff)
            DispatchQueue.main.sync {
                self.tableView.reloadData()
//                self.messageLabel.text = ""
//                updateView()
            }
            })
        }
    }
    
//    func do_table_refresh()
//    {
//            self.stuff.removeAll()
//            self.getAllBirdsList()
            //self.tableView.reloadData()
//            return

//    }
 
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
