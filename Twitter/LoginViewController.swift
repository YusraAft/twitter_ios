//
//  LoginViewController.swift
//  Twitter
//
//  Created by Mac User on 3/4/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    } //once your page shows up what you want to do: we want to check the note from below to see if useis logged in
    
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: myUrl, success: {
            //login as successful
        UserDefaults.standard.set(true, forKey: "userLoggedIn") //everytime user logs in, the userloggedin is set to true
            //these notes from prev logins is memory which is called user default
        self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: {(Error) in
                print("Could not log in!")})
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
