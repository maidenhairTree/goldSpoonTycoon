//
//  MyPropertiesCellViewController.swift
//  GoldSpoon_Tycoon
//
//  Created by comusicart on 6/13/16.
//  Copyright © 2016 Mendo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyPropertiesCellViewController: UIViewController {

    @IBOutlet var propertyNameLabel: UILabel!
    @IBOutlet var propertyCostLabel: UILabel!
    @IBOutlet var dailyIncomeLabel: UILabel!
    @IBOutlet var categoryImageView: UIImageView!
    
    var dailyCost = 0.0
    var dailyRent = 0.0
    var value = 0.0
    
    //Table에서 받아와서 저장할 변수
    var icon = ""
    var latitude = ""
    var longitude = ""
    var name = ""
    var id = ""
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        propertyNameLabel.text = name
//        self.categoryImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: icon)!)!)
//        propertyCostLabel.hidden = false
//        print(name)
//        
//        if value == 0.0 {
//            fetchPropertyCost()
//        }
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
                
        propertyNameLabel.text = name
        self.categoryImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: icon)!)!)
        self.propertyCostLabel.text = self.numberToWon(value)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberToWon(numberToChange: Double) -> String{
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        return numberFormatter.stringFromNumber(numberToChange)!+"원";
    }

}
