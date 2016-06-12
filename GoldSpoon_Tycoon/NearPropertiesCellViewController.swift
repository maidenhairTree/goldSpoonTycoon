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
    @IBOutlet var dailyIncomeLabel: UILabel!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var ownerLabel: UILabel!
    @IBOutlet var buyBottonLabel: UIButton!
    @IBAction func buyBotton() {
        if UserInfo.cashBalance >= self.value {
            //제목, 문구 지정
            let alertController = UIAlertController(title: "Gold Spoon Tycoon", message: "You really wanna buy this?", preferredStyle: UIAlertControllerStyle.Alert)
            
            //버튼 및 버튼을 눌렀을 때 행동 지정
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.buyProperty()
                })
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                })
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
 
    var dailyCost = 0.0
    var dailyRent = 0.0
    var value = 0.0
    
    //Table에서 받아와서 저장할 변수
    var icon = ""
    var latitude = ""
    var longitude = ""
    var name = ""
    var id = ""
    var typeOne = ""
    var typeTwo = ""
    var vincinity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        propertyNameLabel.text = name
        self.categoryImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: icon)!)!)
        
        findIfPropertyIsSold()
        fetchPropertyCost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findIfPropertyIsSold() {
        
        Alamofire.request(.GET, "http://localhost:8080/properties/\(id)")
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("someone bought this property : " + self.name)
                    if let json = response.result.value {
                        print("JSON in findIfPropertyIsSold(): \(json)\n\(self.id)")
                    }
                    
                    var isSoldResultJSON = JSON(data: response.data!)
                    
                    self.buyBottonLabel.hidden=true
                    self.ownerLabel.text = isSoldResultJSON["ownerLastName"].stringValue + " " + isSoldResultJSON["ownerFirstName"].stringValue
                    
                case .Failure(_):
                    print("no one bought this property : " + self.name)
                    self.ownerLabel.hidden=true
                }
        }
    }
    
    func fetchPropertyCost(){
        
        Alamofire.request(.GET, "http://localhost:8080/population", parameters: ["latitude":latitude, "longitude":longitude])
            .responseJSON { response in
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                
                var costInfoFromServer = JSON(data: response.data!)
                if costInfoFromServer["totalPopulation"].stringValue.isEmpty {
                    self.propertyCostLabel.text = "100"
                    self.value = 100
                }
                else
                {
                    self.propertyCostLabel.text = costInfoFromServer["totalPopulation"].stringValue
                    self.value = costInfoFromServer["totalPopulation"].doubleValue
                }
        }
        
        
    }
    
    func buyProperty(){
        print("Yes")

    }

}
