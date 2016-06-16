//
//  UserInfoViewController.swift
//  GoldSpoon_Tycoon
//
//  Created by comusicart on 6/12/16.
//  Copyright © 2016 Mendo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import SwiftyJSON

class UserInfoViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    

    @IBOutlet var userTotalValueLabel: UILabel!
    @IBOutlet var userCashBalanceLabel: UILabel!
    @IBOutlet var userDailyProfitLabel: UILabel!
    @IBOutlet var userPropertyValueLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    //for manipulate spinner
    private var totalValue: Double {
        get {
            return self.totalValue
        }
        set {
            spinner?.stopAnimating()
            spinner?.hidden = true
        }
    }

    //처음 어플리케이션을 실행하였을 떄
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton.delegate = self
        
        if FBSDKAccessToken.currentAccessToken() != nil{
            print("current token exist!")
            fetchProfile()
        }
        
        //여기를 실시간으로 받아야함
        UserInfo.latitude = "35.811844"
        UserInfo.longitude = "128.5228247"
    
    }
    
    //페이지 뷰 컨트롤러를 이용해서 페이지를 넘길 때. 위의 viewDidLoad랑 작동을 다르게 해서 효율적으로 만들어야 함
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if FBSDKAccessToken.currentAccessToken() != nil{
            print("current token exist!")
            fetchProfile()
        }

    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        fetchProfile()
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        userProfileImage.image = UIImage(named: "Unknown_user")
        userNameLabel.text = "로그인 하세요"
        userTotalValueLabel.text = "총 재산"
        userCashBalanceLabel.text = "통장 잔고"
        userDailyProfitLabel.text = "일일 수익"
        userPropertyValueLabel.text = "건물 규모"
    }
    
    func fetchProfile() {
        spinner?.startAnimating()
        //Facebook Request
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
            let userProfilePictureURL: String = (user.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            let userFirstName: String = (user.objectForKey("first_name") as? String)!
            let userLastName: String = (user.objectForKey("last_name") as? String)!
            
            //Static structure에 email 저장
            UserInfo.email = (user.objectForKey("email") as? String)!
            
            self.userProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: userProfilePictureURL)!)!)
            self.userNameLabel.text = "\(userLastName) \(userFirstName)"
            
            //Server Request
            Alamofire.request(.GET, "https://gold-spoon-tycoon.herokuapp.com/user/"+UserInfo.email, parameters: ["firstName":userFirstName, "lastName":userLastName])
                .responseJSON { response in
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                    }
                    
                    let jsonFromServer = JSON(data: response.data!)
                    
                    self.userTotalValueLabel.text = self.numberToWon(jsonFromServer["totalValue"].doubleValue)
                    self.userCashBalanceLabel.text = self.numberToWon(jsonFromServer["cashBalance"].doubleValue)
                    self.userDailyProfitLabel.text = self.numberToWon(jsonFromServer["dailyProfit"].doubleValue)
                    self.userPropertyValueLabel.text = self.numberToWon(jsonFromServer["propertyValue"].doubleValue)
                    
                    UserInfo.cashBalance = jsonFromServer["cashBalance"].doubleValue
                    
                    self.totalValue = jsonFromServer["totalValue"].doubleValue
            }
        })
        

    }
    
    func numberToWon(numberToChange: Double) -> String{
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        return numberFormatter.stringFromNumber(numberToChange)!+"원";
    }
    
    
}
