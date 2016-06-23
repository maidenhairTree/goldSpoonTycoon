//
//  MyPropertiesTableViewController.swift
//  GoldSpoon_Tycoon
//
//  Created by comusicart on 6/13/16.
//  Copyright © 2016 Mendo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyPropertiesTableViewController: UITableViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var jsonFromServer: JSON = []
    
    var count = 0
    var countWatcher: Int {
        get {
            return self.count
        }
        set {
            self.count = newValue
            spinner?.stopAnimating()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchMyProperties()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "MyCity.png")!)
        
        print("in near property first table view viewDidAppear:" + UserInfo.email)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "MyCity.png")!)
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
        
        //(셀 넘버 == 제이슨 배열 인덱스)
        cell.textLabel?.text = self.jsonFromServer["placeList"][indexPath.row]["name"].string
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MyPropertyTableToCell" {
            if let destination = segue.destinationViewController as? MyPropertiesCellViewController {
                
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(path!)
                
                destination.name = (cell?.textLabel?.text!)!
                destination.icon = jsonFromServer["placeList"][(path?.row)!]["icon"].stringValue
                destination.value = jsonFromServer["placeList"][(path?.row)!]["value"].doubleValue
                destination.dailyRent = jsonFromServer["placeList"][(path?.row)!]["dailyRent"].doubleValue
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("MyPropertyTableToCell", sender: self)
        }
        
    }
    
    func fetchMyProperties(){
        spinner?.startAnimating()
        Alamofire.request(.GET, "https://gold-spoon-tycoon.herokuapp.com/user/\(UserInfo.email)/properties")
            .responseJSON { response in
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                
                self.jsonFromServer = JSON(data: response.data!)
                self.countWatcher = self.jsonFromServer.count
                self.tableView.reloadData()
        }
        
        
    }

}
