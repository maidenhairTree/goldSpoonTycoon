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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchNearProperties()
        
         print("in near property first table view viewDidAppear:" + UserInfo.email)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //주변 건물의 수를 바탕으로 Cell 개수를 파악함
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellNumber = self.jsonFromServer["placeList"].count
        return cellNumber
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        
        cell.textLabel?.text = self.jsonFromServer["placeList"][indexPath.row]["name"].string
        //cell.textLabel?.text = "Hello from cell #\(indexPath.row)"
        //셀 넘버에 따라서 제이슨 건물 목록 배열에 있는거 넘겨주면 될 듯 (셀 넘버 == 제이슨 배열 인덱스)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NearPropertyTableToCell" {
            if let destination = segue.destinationViewController as? NearPropertiesCellViewController {
                
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(path!)
                
                destination.propertyName = (cell?.textLabel?.text!)!
                destination.jsonFromServer = jsonFromServer
                destination.latitude = jsonFromServer["placeList"][(path?.row)!]["latitude"].stringValue
                destination.longitude = jsonFromServer["placeList"][(path?.row)!]["longitude"].stringValue
                destination.address = jsonFromServer["placeList"][(path?.row)!]["address"].stringValue
                destination.imageURL = jsonFromServer["placeList"][(path?.row)!]["icon"].stringValue
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
