//
//  ViewController.swift
//  Camping
//
//  Created by okchuri on 2015. 8. 1..
//  Copyright (c) 2015년 okchuri. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginResult: String?
    
    /*
    // 화면 이동(Segue 호출) 전 특정 조건을 체크하여 결과에 따라 처리하기 위해서는 @IBAction을 이용하지 말고,
    // prepareForSegue 함수에서 조건처리하고 이동시키도록 하자
    
    @IBAction func pressLoginButton(sender: AnyObject) {
    if (idTextField.text.isEmpty || passwordTextField.text.isEmpty) {
    displayMyAlertMessage("All fields are required")
    return
    }
    
    requestPostMessage()
    
    while(loginResult == nil) {
    // Timeout 걸릴 때까지 마냥 기다려야하나? 아니면.... 일정시간 후에는 종료시켜야하나??? 추후 고민해보자...
    usleep(2000)
    println("usleep")
    }
    
    println("loginResult : \(loginResult)")
    
    if (loginResult == "success") {
    //self.dismissViewControllerAnimated(true, completion: nil)
    } else if(loginResult == "fail") {
    displayMyAlertMessage("Invalid ID or Password")
    loginResult = nil  // 꼭 이렇게 해야되나? 다른 방법이 있는지 찾아보자...
    return
    } else if(loginResult!.rangeOfString("error") != nil) {
    displayMyAlertMessage("Network has some problem\n\(loginResult!)")
    loginResult = nil  // 꼭 이렇게 해야되나? 다른 방법이 있는지 찾아보자...
    return
    }
    }
    */
    
    func requestPostMessage() {
        let loginURL = NSURL(string: "http://192.168.15.9:9999/login")
        let request = NSMutableURLRequest(URL: loginURL!)
        request.HTTPMethod = "POST"
        
        let postString = "id=\(idTextField.text)&password=\(passwordTextField.text)" as String
        println("postString : \(postString)")
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println("error = \(error)")
                self.loginResult = "error: " + "\(error.code)" as String
                return
            }
            
            // You can print out response object
            println("************** response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("************** response data = \(responseString)")
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                self.loginResult = parseJSON["loginStatus"] as? String
                println("login Status is \(self.loginResult)")
            }
        }
        task.resume()
    }
    
    func displayMyAlertMessage(userMessage: String) {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToContentTabSegue" {
            if (idTextField.text.isEmpty || passwordTextField.text.isEmpty) {
                displayMyAlertMessage("All fields are required")
                return
            }
            
            requestPostMessage()
            
            while(loginResult == nil) {
                // Timeout 걸릴 때까지 마냥 기다려야하나? 아니면.... 일정시간 후에는 종료시켜야하나??? 추후 고민해보자...
                usleep(2000)
                println("usleep")
            }
            
            println("loginResult : \(loginResult)")
            
            if (loginResult == "success") {
                //self.dismissViewControllerAnimated(true, completion: nil)
            } else if(loginResult == "fail") {
                displayMyAlertMessage("Invalid ID or Password")
                loginResult = nil  // 꼭 이렇게 해야되나? 다른 방법이 있는지 찾아보자...
                return
            } else if(loginResult!.rangeOfString("error") != nil) {
                displayMyAlertMessage("Network has some problem\n\(loginResult!)")
                loginResult = nil  // 꼭 이렇게 해야되나? 다른 방법이 있는지 찾아보자...
                return
            }
            
            
            if let destinationVC = segue.destinationViewController as? UITabBarController{
                destinationVC.selectedIndex = 0
            }
        }
    }
}
