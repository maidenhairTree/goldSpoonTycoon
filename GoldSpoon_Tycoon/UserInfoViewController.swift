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

class UserInfoViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton.delegate = self
        
        if FBSDKAccessToken.currentAccessToken() != nil{
            print("current token exist!")
            fetchProfile()
        }

        // Do any additional setup after loading the view.
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

    }
    
    func fetchProfile() {
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
            let userProfilePictureURL: String = (user.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            
            self.userProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: userProfilePictureURL)!)!)
        
        })
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
