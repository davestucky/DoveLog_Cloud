//
//  WUADCustomCellAll.swift
//  WUAD Wedding App
//
//  Created by Dave Stucky on 7/20/16.
//  Copyright © 2016 Dave Stuckenschneider. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class WUADCustomCellAll: UITableViewCell {
    
     let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    @IBOutlet var bandNumber:UILabel?
    @IBOutlet var bandPre:UILabel?
    @IBOutlet var bandyear:UILabel?
    @IBOutlet var bandInven:UISwitch?
    @IBOutlet var lastInven:UISwitch?
    @IBOutlet weak var bandClass: UILabel!
     @IBOutlet weak var  idRecordNo: CKRecord.ID!
    var currentInven: Int?
    
    
    @IBAction func bandInvenPressed(_ sender: UISwitch)
    {
        if (bandInven?.isOn)!
        {
            currentInven = 1
        }else{
            currentInven = 0
        }
        nwdrs_Private_DB.fetch(withRecordID: self.idRecordNo!) { [unowned self] record, error in
                if let error = error {
                    DispatchQueue.main.sync {
                        print("Challenge with function : \(error)")
                    }
                } else {
                    if let record = record {
                        record.setObject(self.currentInven!  as CKRecordValue, forKey: "bird_inven_here")
                        record.setObject(self.currentInven! as CKRecordValue, forKey: "bird_inven_last")
                        self.nwdrs_Private_DB.save(record) { (record, error) in
                            DispatchQueue.main.sync {
                                
                                if let error = error {
                                    print(error)
                                }else{
                                    //DoveInventoryTable().getAllBirdsList()
                                }
                                    }
                                }
                            }
                        }
                    }
        }
        }
