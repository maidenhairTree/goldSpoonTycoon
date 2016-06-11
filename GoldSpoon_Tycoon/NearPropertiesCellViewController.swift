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
    
    //받아와서 저장할 변수
    var viaSegue = ""
    var jsonFromServer: JSON = []
    var latitude = ""
    var longitude = ""
    var address = ""
    var cost = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
