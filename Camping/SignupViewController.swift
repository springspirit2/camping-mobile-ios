//
//  SignupViewController.swift
//  Camping
//
//  Created by okchuri on 2015. 8. 1..
//  Copyright (c) 2015년 okchuri. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    
    @IBAction func pressCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    var signupResult: String?
    
    @IBAction func pressSignupButton(sender: AnyObject) {
        if (idTextField.text.isEmpty || passwordTextField.text.isEmpty || confirmTextField.text.isEmpty) {
            displayMyAlertMessage("All fields are required")
            return
        }
        if (passwordTextField.text != confirmTextField.text) {
            displayMyAlertMessage("Password is mismatched")
            return
        }
        
        requestPostMessage()
        
        while(signupResult == nil) {
            // Timeout 걸릴 때까지 마냥 기다려야하나? 아니면.... 일정시간 후에는 종료시켜야하나??? 추후 고민해보자...
            sleep(1)
            println("sleep")
        }
        
        println("signupResult : \(signupResult)")
        
        if (signupResult == "success") {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if(signupResult == "already") {
            displayMyAlertMessage("This ID is already used")
            signupResult = nil  // 꼭 이렇게 해야되나? 다른 방법이 있는지 찾아보자...
            return
        } else if(signupResult!.rangeOfString("error") != nil) {
            displayMyAlertMessage("Network has some problem\n\(signupResult!)")
            signupResult = nil  // 꼭 이렇게 해야되나? 다른 방법이 있는지 찾아보자...
            return
        }
    }
    
    func requestPostMessage() {
        //        let signupURL = NSURL(string: "http://www.swiftdeveloperblog.com/http-post-example-script/")
        let signupURL = NSURL(string: "http://192.168.15.9:9999/register")
        let request = NSMutableURLRequest(URL: signupURL!)
        request.HTTPMethod = "POST"
        
        let postString = "id=\(idTextField.text)&password=\(passwordTextField.text)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println("error = \(error)")
                self.signupResult = "error: " + "\(error.code)" as String
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
                self.signupResult = parseJSON["registerStatus"] as? String
                println("signup Status is \(self.signupResult)")
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

}
