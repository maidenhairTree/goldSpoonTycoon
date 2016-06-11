//
//  NearPropertiesTableViewController.swift
//  GoldSpoon_Tycoon
//
//  Created by comusicart on 6/12/16.
//  Copyright © 2016 Mendo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NearPropertiesTableViewController: UITableViewController {

    var jsonFromServer: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNearProperties()
        
        print("in near property first table view :" + UserInfo.email)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //얘를 다이나믹하게 하면 될 듯.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellNumber = self.jsonFromServer["propertyList"].count
        return cellNumber
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        
        cell.textLabel?.text = self.jsonFromServer["propertyList"][indexPath.row]["name"].string
        //cell.textLabel?.text = "Hello from cell #\(indexPath.row)"
        //셀 넘버에 따라서 제이슨 건물 목록 배열에 있는거 넘겨주면 될 듯 (셀 넘버 == 제이슨 배열 인덱스)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NearPropertyTableToCell" {
            if let destination = segue.destinationViewController as? NearPropertiesCellViewController {
                
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(path!)
                
                destination.viaSegue = (cell?.textLabel?.text!)!
                destination.jsonFromServer = jsonFromServer
                destination.latitude = jsonFromServer["propertyList"][(path?.row)!]["latitude"].string!
                destination.longitude = jsonFromServer["propertyList"][(path?.row)!]["longitude"].string!
                destination.address = jsonFromServer["propertyList"][(path?.row)!]["address"].string!
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("NearPropertyTableToCell", sender: self)
        }
        
    }
    
    func fetchNearProperties(){
        
        Alamofire.request(.GET, "http://localhost:8080/nearProperties", parameters: ["latitude":"35.811844", "longitude":"128.5228247"])
            .responseJSON { response in
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                
//                UserInfo.latitude = "35.811844"
//                UserInfo.longitude = "128.5228247"
                
                self.jsonFromServer = JSON(data: response.data!)
                self.tableView.reloadData()
        }
        
        
    }

}
