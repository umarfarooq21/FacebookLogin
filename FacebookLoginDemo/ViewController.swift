//
//  ViewController.swift
//  FacebookLoginDemo
//
//  Created by Muhammad Umair Qureshi on 1/10/20.
//  Copyright © 2020 Umar Farooq. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func loginFbTapped(_ sender: Any) {
        fbLogin()
    }
    
    //MARK:- Facebook Login
    
    func fbLogin() {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions:[ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            
            switch loginResult {
            
            case .failed(let error):
                //HUD.hide()
                print(error)
            
            case .cancelled:
                //HUD.hide()
                print("User cancelled login process.")
            
            case .success( _, _, _):
                print("Logged in!")
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData() {
        //which if my function to get facebook user details
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict = result as! [String : AnyObject]
                    print(result!)
                    print(dict)
                    let picutreDic = dict as NSDictionary
                    let tmpURL1 = picutreDic.object(forKey: "picture") as! NSDictionary
                    let tmpURL2 = tmpURL1.object(forKey: "data") as! NSDictionary
                    let finalURL = tmpURL2.object(forKey: "url") as! String
                    
                    let nameOfUser = picutreDic.object(forKey: "name") as! String
                    self.lblUserName.text = nameOfUser
                    
                    var tmpEmailAdd = ""
                    if let emailAddress = picutreDic.object(forKey: "email") {
                        tmpEmailAdd = emailAddress as! String
                        self.lblUserEmail.text = tmpEmailAdd
                    }
                    else {
                        var usrName = nameOfUser
                        usrName = usrName.replacingOccurrences(of: " ", with: "")
                        tmpEmailAdd = usrName+"@facebook.com"
                    }
                    
                    // PLEASE SUBSCRIBE MY CHANNEL IT WILL MOTIVATE ME KEEP UPLOAD VIDEOS ;)
                    
                   
                }
                
                print(error?.localizedDescription as Any)
            })
        }
    }

}

