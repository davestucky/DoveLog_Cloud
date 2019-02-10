//
// WeddingEditViewController.swift
//  MyDoveLog
//
//  Created by Dave Stucky on 10/10/16.
//  Copyright © 2016 DaveStucky. All rights reserved.
//

import UIKit
import CloudKit


class WeddingEditViewController: UIViewController {
    
    let nwdrs_Private_DB = CKContainer.default().privateCloudDatabase
    var currentRecord: CKRecord?
    
    var findWedBrideKey: String!
    var find: String!
    var resultSet = NSArray()
    var relhold: String!
    var veninout: String!
    var dbInfo: NSDictionary!
    
    @IBOutlet var wedVC: UIView!
    
    @IBOutlet weak var wedEditPressed: UIButtonX!
    @IBOutlet weak var wedTime: UITextField!
    @IBOutlet weak var wedDate: UITextField!
    @IBOutlet var bfname: UITextField!
    @IBOutlet var blname: UITextField!
    @IBOutlet var baddress: UITextField!
    @IBOutlet var bcity: UITextField!
    @IBOutlet var bstate: UITextField!
    @IBOutlet var bzip: UITextField!
    @IBOutlet var bphone: UITextField!
    @IBOutlet var bemail: UITextField!
    @IBOutlet var bmom: UITextField!
    @IBOutlet var bdad: UITextField!
    @IBOutlet var gfname: UITextField!
    @IBOutlet var glname: UITextField!
    @IBOutlet var gmom: UITextField!
    @IBOutlet var gdad: UITextField!
    @IBOutlet var wedPhotoContact: UISwitch!
    @IBOutlet var wedPhotoName: UITextField!
    @IBOutlet var wedPhotoAddress: UITextField!
    @IBOutlet var wedPhotoCity: UITextField!
    @IBOutlet var wedPhotoPhone: UITextField!
    @IBOutlet var wedPhotoEmail: UITextField!
    @IBOutlet weak var WedEdit: UIImageView!
    @IBOutlet weak var editSave: UIButtonX!
    var bridekey:String! = ""
    var values:NSArray = []
    var valuesg:NSArray = []
    var valuesp:NSArray = []
    var valuesv:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allTextFieldsDisabled()
        GetBrideInfo()
        GetGroomStuff()
        GetPhotoStuff ()
    }
        
        func GetBrideInfo(){
            
            let predicate = NSPredicate(format: "wedbridekey = %@", findWedBrideKey)
            
            let query = CKQuery(recordType: "tblBridesInfo", predicate: predicate)
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
                                                    
                                                    self.bfname.text = record.object(forKey: "bridefname") as? String
                                                    self.blname.text = record.object(forKey: "bridelname") as? String
                                                    self.baddress.text = record.object(forKey: "brideaddress")  as? String
                                                    self.bcity.text =  record.object(forKey: "bridecity")  as? String
                                                    self.bstate.text  = record.object(forKey: "bridestate")  as? String
                                                    self.bzip.text =  record.object(forKey: "bridezip")  as? String
                                                    self.bphone.text = record.object(forKey: "bridephone")  as? String
                                                    self.bemail.text = record.object(forKey: "brideemail")  as? String
                                                    self.bmom.text = record.object(forKey: "bridemom")  as? String
                                                    self.bdad.text  = record.object(forKey: "bridedad")  as? String
                                                    self.wedDate.text = record.object(forKey: "weddate")  as? String
                                                    self.wedTime.text = record.object(forKey: "wedtime")  as? String
                                                }
                                            }
                                        }
                                     }))
        }

    func GetGroomStuff(){
        let predicate = NSPredicate(format: "wedbridekey = %@", findWedBrideKey)
        
        let query = CKQuery(recordType: "tblgroominfo", predicate: predicate)
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
                                                
                                                self.gfname.text = record.object(forKey: "groomfname") as? String
                                                self.glname.text = record.object(forKey: "groomlname") as? String
                                                self.gmom.text = record.object(forKey: "groommom")  as? String
                                                self.gdad.text  = record.object(forKey: "groomdad")  as? String
                                                
                                            }
                                        }
                                    }
                                 }))
    }
        
    func GetPhotoStuff () {
        let predicate = NSPredicate(format: "wedbridekey = %@", findWedBrideKey)
        
        let query = CKQuery(recordType: "tblPhotoInfo", predicate: predicate)
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
                                                
                                                self.wedPhotoName.text = record.object(forKey: "wedphotographer") as? String
                                                self.wedPhotoAddress.text  = record.object(forKey: "photoaddress") as? String
                                                self.wedPhotoCity.text  = record.object(forKey: "photocity")  as? String
                                                self.wedPhotoPhone.text  = record.object(forKey: "photophone")  as? String
                                                self.wedPhotoEmail.text  = record.object(forKey: "photoemail")  as? String
                                            }
                                        }
                                    }
                                 }))
    }
    
    @IBAction func editWedInfoPressed(_ sender: Any) {
        wedVC.backgroundColor = UIColor.green
        allTextFieldsEnabled()
    }
    
    @IBAction func saveWedEditPressed(_ sender: Any) {
        editBrideSavePressed()
        editGroomSavePressed()
        editPhotoSavePressed()
        allTextFieldsDisabled()
        wedVC.backgroundColor = UIColor(red:0.29, green:0.60, blue:0.85, alpha:1.0)
        
    }
    
    func editBrideSavePressed() {
        //Save Bride
        
         let url = URL(string: "http://davestucky.com/weddingAdd.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "task=brideedit&wedBrideKey=\(bridekey!)&brideFName=\(bfname.text!)&brideLName=\(blname.text!)&brideAddress=\(baddress.text!)&brideCity=\(bcity.text!)&brideState=\(bstate.text!)&brideZip=\(bzip.text!)&bridePhone=\(bphone.text!)&brideEmail=\(bemail.text!)&brideMom=\(bmom.text!)&brideDad=\(bdad.text!)&weddate=\(wedDate.text!)&wedtime=\(wedTime.text!)"
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
        
    }
    
    func editGroomSavePressed() {
        ////Save Groom
        let url = URL(string: "http://davestucky.com/weddingAdd.php")
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        let postString = "task=groom&groomFName=\(gfname.text!)&groomLName=\(glname.text!)&groomMom=\(gmom.text!)&groomDad=\(gdad.text!)&wedBrideKey=\(bridekey!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
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
    }
    
    func editPhotoSavePressed() {
        //Save Photographer
        var request = URLRequest(url: URL(string: "http://davestucky.com/weddingAdd.php")!)
        request.httpMethod = "POST"
        let postString = "task=photo&wedPhotographer=\(wedPhotoName.text!)&wedPhotographerAddress=\(wedPhotoAddress.text!)&wedPhotographerCity=\(wedPhotoCity.text!)&wedPhotographerPhone=\(wedPhotoPhone.text!)&wedPhotographerEmail=\(wedPhotoEmail.text!)&wedBrideKey=\(bridekey!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if (segue.identifier == "editDatePopUp"){
            let popup =  segue.destination as! DatePopupViewController
            popup.showTimePicker = false
            popup.onSave = { (data) in
                self.wedDate.text = data
            }
        }
        
        if (segue.identifier == "editTimePopUp"){
            let popup =  segue.destination as! DatePopupViewController
            popup.showTimePicker = true
            popup.onSave = { (Data) in
                self.wedTime.text = Data
            }
        }
        
        if (segue.identifier == "editVenue"){
            
            let destinationVC : WeddingEditVenueViewController  = segue.destination as! WeddingEditVenueViewController
            destinationVC.getWedBrideKey = findWedBrideKey
            
        }
        
        /*if (segue.identifier == "mapVenue"){
            let destinationVC : venueMapViewController  = segue.destination as! venueMapViewController
            destinationVC.locationVenue = venAddress.text!
            //destinationVC.venueName = venue.text!
        }*/
        
    }
    
    //MARK Disable All Textfields   :
    func allTextFieldsDisabled(){
        self.wedTime.isUserInteractionEnabled = false
        self.wedDate.isUserInteractionEnabled = false
        self.bfname.isUserInteractionEnabled = false
        self.blname.isUserInteractionEnabled = false
        self.baddress.isUserInteractionEnabled = false
        self.bcity.isUserInteractionEnabled = false
        self.bstate.isUserInteractionEnabled = false
        self.bzip.isUserInteractionEnabled = false
        self.bphone.isUserInteractionEnabled = false
        self.gfname.isUserInteractionEnabled = false
        self.glname.isUserInteractionEnabled = false
        self.gmom.isUserInteractionEnabled = false
        self.gdad.isUserInteractionEnabled = false
        self.wedPhotoContact.isUserInteractionEnabled = false
        self.wedPhotoName.isUserInteractionEnabled = false
        self.wedPhotoAddress.isUserInteractionEnabled = false
        self.wedPhotoCity.isUserInteractionEnabled = false
        self.wedPhotoPhone.isUserInteractionEnabled = false
        self.wedPhotoEmail.isUserInteractionEnabled = false
        self.WedEdit.isUserInteractionEnabled = false
        editSave.isHidden = true
        wedEditPressed.isHidden = false
        wedEditPressed.backgroundColor = UIColor.red
        
    }
    
    //MARK Enable All Textfields   :
    func allTextFieldsEnabled(){
        self.wedTime.isUserInteractionEnabled = true
        self.wedDate.isUserInteractionEnabled = true
        self.bfname.isUserInteractionEnabled = true
        self.blname.isUserInteractionEnabled = true
        self.baddress.isUserInteractionEnabled = true
        self.bcity.isUserInteractionEnabled = true
        self.bstate.isUserInteractionEnabled = true
        self.bzip.isUserInteractionEnabled = true
        self.bphone.isUserInteractionEnabled = true
        self.gfname.isUserInteractionEnabled = true
        self.glname.isUserInteractionEnabled = true
        self.gmom.isUserInteractionEnabled = true
        self.gdad.isUserInteractionEnabled = true
        self.wedPhotoContact.isUserInteractionEnabled = true
        self.wedPhotoName.isUserInteractionEnabled = true
        self.wedPhotoAddress.isUserInteractionEnabled = true
        self.wedPhotoCity.isUserInteractionEnabled = true
        self.wedPhotoPhone.isUserInteractionEnabled = true
        self.wedPhotoEmail.isUserInteractionEnabled = true
        self.WedEdit.isUserInteractionEnabled = true
        editSave.isHidden = false
        wedEditPressed.backgroundColor = UIColor.green
        
        
    }

}
