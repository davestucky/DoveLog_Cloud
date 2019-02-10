//
//  ViewController.swift
//  DoveLog_Cloud
//
//  Created by Dave Stucky on 7/11/18.
//  Copyright © 2018 Dave Stucky. All rights reserved.
//

import UIKit
import CloudKit


class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    let database = CKContainer.default().privateCloudDatabase
    
    var nwdrs = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl  
        queryDatabase()
    }
    
    @IBAction func onPlusTapped(){
        let alert = UIAlertController(title: "Type Band Number", message: "Please enter band number!", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "Type band number Here"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Post", style: .default) {(_) in
            guard let text = alert.textFields?.first?.text else { return }
            self.saveToCloud(band_no: text)
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
        
        }
    
    func saveToCloud(band_no: String){
        let newBandNumber = CKRecord(recordType: "NWDRS_Log")
        newBandNumber.setValue(band_no, forKey: "band_no")
        
        database.save(newBandNumber) { (record, _ ) in
            
            guard  record != nil else { return }
            print("saved record")
//            self.queryDatabase()
        }
        
    }
    
    @objc func queryDatabase() {
        let query = CKQuery(recordType: "NWDRS_Log", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, _) in
        guard let records = records else { return }
            self.nwdrs = records
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
    }
    
}
    
    
    
} //end class

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nwdrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let nwdr = nwdrs[indexPath.row].value(forKey: "band_no") as! String
        cell.textLabel?.text = nwdr
        return cell
    }

}
