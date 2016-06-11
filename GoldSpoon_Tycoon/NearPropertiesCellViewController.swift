//
//  NearPropertiesCellViewController.swift
//  GoldSpoon_Tycoon
//
//  Created by comusicart on 6/12/16.
//  Copyright © 2016 Mendo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NearPropertiesCellViewController: UIViewController {

    @IBOutlet var propertyNameLabel: UILabel!
    @IBOutlet var propertyCostLabel: UILabel!
    @IBOutlet var dailyRentIncomeLabel: UILabel!
    @IBOutlet var dailyManagementCostLabel: UILabel!
 
    
    //받아와서 저장할 변수
    var propertyName = ""
    var jsonFromServer: JSON = []
    var latitude = ""
    var longitude = ""
    var address = ""
    var cost = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        propertyNameLabel.text = propertyName
        fetchPropertyCost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPropertyCost(){
        
        Alamofire.request(.GET, "http://localhost:8080/population", parameters: ["latitude":latitude, "longitude":longitude])
            .responseJSON { response in
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                
                var costInfoFromServer = JSON(data: response.data!)
                self.propertyCostLabel.text = costInfoFromServer["totalPopulation"].stringValue
                self.cost = costInfoFromServer["totalPopulation"].doubleValue
        }
        
        
    }

}
