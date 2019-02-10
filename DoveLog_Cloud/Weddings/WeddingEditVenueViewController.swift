//
//  WeddingEditVenueViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 10/10/
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit

class WeddingEditVenueViewController: UIViewController {
    
    @IBOutlet weak var venueWeddingEdit: UIButtonX!
    @IBOutlet var vname: UITextField!
    @IBOutlet var vaddress: UITextField!
    @IBOutlet var vcity: UITextField!
    @IBOutlet var vstate: UITextField!
    @IBOutlet var vzip: UITextField!
    @IBOutlet var vphone: UITextField!
    @IBOutlet var vemail: UITextField!
    @IBOutlet var vinout: UITextField!
    @IBOutlet var wedMainColor: UITextField!
    @IBOutlet var wedSecColor: UITextField!
    @IBOutlet var wedTertColor: UITextField!
    @IBOutlet var wedNumberDoves: UITextField!
    @IBOutlet var wedReleaseHold: UITextField!
    @IBOutlet var wedSpecInst: UITextView!
    @IBOutlet weak var venueEditPressed: UIButtonX!
    @IBOutlet weak var editVenueInfoSave: UIButtonX!
    @IBOutlet var wedVenueVC: UIView!
    
    
    var valuesv: NSArray = []
    var getWedBrideKey: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allTextFieldsDisabled()
        getVenueDetails()
        
    }
    
    
        func getVenueDetails(){
            let urlv = URL(string: "http://davestucky.com/venueEdit.php")
            let datav = try? Data(contentsOf: urlv!)
            valuesv = try! JSONSerialization.jsonObject(with: datav!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            for row in (valuesv as? [[String:Any]])! {
            
            let bridekey = row["wedBrideKey"] as? String
            let longname = bridekey
            
            if longname == getWedBrideKey{
            self.vname.text = row["wedVenue"] as? String
            self.vinout.text = row["wedVenueInOut"] as? String
            self.vaddress.text = row["wedVenueAddress"] as? String
            self.vcity.text = row["wedVenueCity"] as? String
            self.vstate.text = row["wedVenueState"] as? String
            self.vzip.text = row["wedVenueZip"] as? String
            self.vphone.text = row["wedVenuePhone"] as? String
            self.vemail.text = row["wedVenueEmail"] as? String
            self.wedMainColor.text  = row["wedMainColor"] as? String
            self.wedSecColor.text  = row["wedSecColor"] as? String
            self.wedTertColor.text  = row["wedTerColor"] as? String
            self.wedNumberDoves.text  = row["wedNumDoves"] as? String
            self.wedReleaseHold.text  = row["wedHoldRelease"] as? String
            self.wedSpecInst.text  = row["wedSpecialInstructions"] as? String
            }
        }
        }
    
    @IBAction func venueSavePressed(_ sender: AnyObject) {
        let url = URL(string: "http://davestucky.com/weddingAdd.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "task=venue&wedBrideKey=\(getWedBrideKey)&wedVenue=\(vname.text!)&wedVenueAddress=\(vaddress.text!)&wedVenueCity=\(vcity.text!)&wedVenueState=\(vstate.text!)&wedVenueZip=\(vzip.text!)&wedVenuePhone=\(vphone.text!)&wedVenueEmail=\(vemail.text!)&wedVenueInOut=\(vinout.text!)&wedMainColor=\(wedMainColor.text!)&wedSecColor=\(wedSecColor.text!)&wedTerColor=\(wedTertColor.text!)&wedSpecialInstructions=\(wedSpecInst.text!)&wedHoldRelease=\(wedReleaseHold.text!)&wedNumDoves=\(wedNumberDoves.text!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
       wedVenueVC.backgroundColor = UIColor(red:0.29, green:0.60, blue:0.85, alpha:1.0)
        allTextFieldsDisabled()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func editVenueInfo(_ sender: Any) {
        allTextFieldsEnabled()
        
    }
    
    //MARK Disable All Textfields   :
    func allTextFieldsDisabled(){
        self.vname.isUserInteractionEnabled = false
        self.vaddress.isUserInteractionEnabled = false
        self.vcity.isUserInteractionEnabled = false
        self.vstate.isUserInteractionEnabled = false
        self.vzip.isUserInteractionEnabled = false
        self.vphone.isUserInteractionEnabled = false
        self.vemail.isUserInteractionEnabled = false
        self.vinout.isUserInteractionEnabled = false
        self.wedMainColor.isUserInteractionEnabled = false
        self.wedSecColor.isUserInteractionEnabled = false
        self.wedTertColor.isUserInteractionEnabled = false
        self.wedNumberDoves.isUserInteractionEnabled = false
        self.wedReleaseHold.isUserInteractionEnabled = false
        self.wedSpecInst.isUserInteractionEnabled = false
        editVenueInfoSave.isHidden = true
        venueEditPressed.isHidden = false
        venueEditPressed.backgroundColor = UIColor.red
        
    }
    
    //MARK Enable All Textfields   :
    func allTextFieldsEnabled(){
        self.vname.isUserInteractionEnabled = true
        self.vaddress.isUserInteractionEnabled = true
        self.vcity.isUserInteractionEnabled = true
        self.vstate.isUserInteractionEnabled = true
        self.vzip.isUserInteractionEnabled = true
        self.vphone.isUserInteractionEnabled = true
        self.vemail.isUserInteractionEnabled = true
        self.vinout.isUserInteractionEnabled = true
        self.wedMainColor.isUserInteractionEnabled = true
        self.wedSecColor.isUserInteractionEnabled = true
        self.wedTertColor.isUserInteractionEnabled = true
        self.wedNumberDoves.isUserInteractionEnabled = true
        self.wedReleaseHold.isUserInteractionEnabled = true
        self.wedSpecInst.isUserInteractionEnabled = true
        venueEditPressed.isHidden = true
        wedVenueVC.backgroundColor = UIColor.green
        editVenueInfoSave.isHidden = false
        
    }
}
