//
//  WUADBirdsWithEggs.swift
//  WUAD Wedding App
//
//  Created by Dave Stucky on 7/24/16.
//  Copyright © 2016 Dave Stuckenschneider. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


class WUADCouplesEggs: UITableViewCell {
    
    @IBOutlet var henBand:UITextField?
    @IBOutlet var cockBand:UITextField?
    @IBOutlet weak var estdatehatch: UITextField!
    //@IBOutlet var estdatehatch:UITextField?
    @IBOutlet var IDNumber:CKRecord.ID!
    @IBOutlet var updateButton: UIButton!
}



