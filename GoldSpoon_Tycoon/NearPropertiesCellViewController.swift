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

    @IBOutlet var spinner: UIActivityIndicatorView!
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
 
    var dailyRent = 0.0
    var value = 0.0
    
    var valueWatcher: Double {
        get {
            return self.value
        }
        set {
            self.value = newValue
            spinner?.stopAnimating()
            spinner?.hidden = true
        }
    }
    
    //Table에서 받아와서 저장할 변수
    var icon = ""
    var latitude = ""
    var longitude = ""
    var name = ""
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ownerLabel.hidden = true
        buyBottonLabel.hidden = true
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "CityInfo.png")!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ownerLabel.hidden = true
        buyBottonLabel.hidden = true
        
        propertyNameLabel.text = name
        self.categoryImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: icon)!)!)
        
        findIfPropertyIsSold()
        
        if value == 0.0 {
            fetchPropertyCost()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findIfPropertyIsSold() {
        
        Alamofire.request(.GET, "https://gold-spoon-tycoon.herokuapp.com/properties/\(id)")
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("someone bought this property : " + self.name)
                    if let json = response.result.value {
                        print("JSON in findIfPropertyIsSold(): \(json)\n\(self.id)")
                    }
                    
                    var isSoldResultJSON = JSON(data: response.data!)
                    
                    self.ownerLabel.text = isSoldResultJSON["ownerLastName"].stringValue + " " + isSoldResultJSON["ownerFirstName"].stringValue
                    self.ownerLabel.hidden=false
                    self.buyBottonLabel.hidden = true
                    
                case .Failure(_):
                    print("no one bought this property : " + self.name)
                    self.buyBottonLabel.hidden=false
                    self.ownerLabel.hidden=true
                }
        }
    }
    
    func fetchPropertyCost(){
        spinner?.startAnimating()
        Alamofire.request(.GET, "https://gold-spoon-tycoon.herokuapp.com/property/\(id)/value", parameters: ["latitude":UserInfo.latitude, "longitude":UserInfo.longitude])
            .responseJSON { response in
                
                if let json = response.result.value {
                    print("fetchPropertyCost JSON: \(json)")
                }
                
                var costInfoFromServer = JSON(data: response.data!)
                if costInfoFromServer["value"].stringValue.isEmpty {
                    self.propertyCostLabel.text = "Error"
                    self.value = 100
                    self.ownerLabel.hidden = true
                    self.buyBottonLabel.hidden = true
                }
                else
                {
                    self.propertyCostLabel.text = self.numberToWon(costInfoFromServer["value"].doubleValue)
                    self.valueWatcher = costInfoFromServer["value"].doubleValue
                    self.dailyIncomeLabel.text = self.numberToWon(Double(String(format: "%.0f", costInfoFromServer["rent"].doubleValue))!)
                    
                    self.dailyRent = Double(String(format: "%.0f", costInfoFromServer["rent"].doubleValue))!
                }
        }
        
        
    }
    
    func buyProperty(){
        print("Yes")
        spinner?.startAnimating()
        Alamofire.request(.GET, "https://gold-spoon-tycoon.herokuapp.com/user/\(UserInfo.email)/buy/\(self.id)", parameters:["latitude":UserInfo.latitude,"longitude":UserInfo.longitude])
            .responseJSON { response in
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                
                var buyResultFromServer = JSON(data: response.data!)
                
                if buyResultFromServer.intValue == 1 {
                    self.spinner?.stopAnimating()
                    print("구매 가능! , 제이슨 값 : \(buyResultFromServer.intValue)")
                    let alertController = UIAlertController(title: "Gold Spoon Tycoon", message: "구매 완료!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default) { UIAlertAction in })
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    self.findIfPropertyIsSold()

                } else if buyResultFromServer.intValue == 0 {
                    self.spinner?.stopAnimating()
                    print("구매 불가! , 제이슨 값 : \(buyResultFromServer.intValue)")
                    let alertController = UIAlertController(title: "Gold Spoon Tycoon", message: "구매 불가! 예산 부족!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default) { UIAlertAction in })
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
        }
    }
    
    func numberToWon(numberToChange: Double) -> String{
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        return numberFormatter.stringFromNumber(numberToChange)!+"원";
    }

}
