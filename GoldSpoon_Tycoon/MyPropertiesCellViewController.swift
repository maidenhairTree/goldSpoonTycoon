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
    
    //Table에서 받아와서 저장할 변수
    var dailyRent = 0.0
    var value = 0.0
    var icon = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "MyCityinfo.png")!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        propertyNameLabel.text = name
        self.categoryImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: icon)!)!)
        self.propertyCostLabel.text = self.numberToWon(value)
        self.dailyIncomeLabel.text = self.numberToWon(Double(String(format: "%.0f", dailyRent))!)
        
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
