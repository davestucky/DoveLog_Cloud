//
// CommentTypePopupViewController.swift
//  DoveEventLog
//
//  Created by Dave Stucky on 12/4/17.
//  Copyright © 2017 Dave Stucky. All rights reserved.
//
import UIKit
import CloudKit

class CommentTypePopupViewController: UIViewController {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    var selectedType: String?
    var onSave: (( _ data: String) -> ())?
    //Mark Cloudkit Stuff
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var currentRecord: CKRecord?
   var values = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       GetCommentTypes()
        typePicker.selectRow(0, inComponent: 0, animated: true)
      }
    
    func createCmtTypePicker() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
    }
    
    @IBAction func saveDate_TouchUpInside(_ sender: UIButton) {
        onSave?(selectedType!)
        dismiss(animated: true)
    }
    
    func GetCommentTypes(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "tblTypeComments", predicate: predicate)
        nwdrs_Private_DB.perform(query, inZoneWith: nil, completionHandler: ({results, error in
            
            if (error != nil) {
                DispatchQueue.main.async()
                    {
                        HPAlertShow.sharedInstance.showStatusView(state: true, time: 5, addToView: self, text: "Cloud Access Error.", textFontColor: UIColor.white, textFontSize: 25, position: .Center, viewBackgroundColor: UIColor.black, viewOpacity: 0.5, viewCornerRadius: 10.0, viewBorderWidth: 2.0, viewBorderColor: UIColor.white) { (completed) in
                            if completed == true{
                            }
                }
                }
                
            }else {
                for row in 0...results!.count-1 {
                    
                    let record = results![row]
                    self.currentRecord = record
                    
                    DispatchQueue.main.async() {
                        
                        let commentType = record.object(forKey: "typeComments") as? String
                        let longinfo = commentType
                        self.values.add(longinfo!)
                        self.typePicker.reloadAllComponents()
                        self.selectedType = (self.values[0] as! String)
                    }
                }
            }
        }))
}
}

extension  CommentTypePopupViewController: UIPickerViewDataSource, UIPickerViewDelegate {

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return values.count
}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = values[row] as? String
    }
    

}

