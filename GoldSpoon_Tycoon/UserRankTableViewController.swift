//
//  UserRankTableViewController.swift
//  GoldSpoon_Tycoon
//
//  Created by comusicart on 6/16/16.
//  Copyright © 2016 Mendo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserRankTableViewController: UITableViewController {

    var jsonFromServer: JSON = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchMyProperties()
        
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
        let cellNumber = self.jsonFromServer["userList"].count
        return cellNumber
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        //(셀 넘버 == 제이슨 배열 인덱스)
        cell.textLabel?.text = self.jsonFromServer["userList"][indexPath.row]["lastName"].stringValue + " " + self.jsonFromServer["userList"][indexPath.row]["firstName"].stringValue
        
        return cell
    }
    
    func fetchMyProperties(){
        
        Alamofire.request(.GET, "http://localhost:8080/rank")
            .responseJSON { response in
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                
                self.jsonFromServer = JSON(data: response.data!)
                self.tableView.reloadData()
        }
        
        
    }


}
