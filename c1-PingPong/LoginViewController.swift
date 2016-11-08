//
//  LoginViewController.swift
//  Reseve Me
//
//  Created by Belay, Betelhem on 10/30/16.
//  Copyright © 2016 Stars99. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var signinScrollView: UIScrollView!
    @IBOutlet weak var fieldParentView: UIView!
    @IBOutlet weak var buttonParentView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signinSpinner: UIActivityIndicatorView!
    
    
    var initialY: CGFloat!
    var offset: CGFloat!
    var buttonInitialY: CGFloat!
    var buttonOffset: CGFloat!
    var textFieldInitialY: CGFloat!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signinScrollView.delegate = self
        signinScrollView.contentSize = signinScrollView.frame.size
        signinScrollView.contentInset.bottom = 100
        
        textFieldInitialY = fieldParentView.frame.origin.y
        buttonInitialY = buttonParentView.frame.origin.y
        offset = -150
        
        self.signinSpinner.isHidden = true
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.fieldParentView.frame.origin.y = self.textFieldInitialY + self.offset
            self.buttonParentView.frame.origin.y = self.buttonInitialY - 250
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.fieldParentView.frame.origin.y = self.textFieldInitialY
            self.buttonParentView.frame.origin.y = self.buttonInitialY
        }
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//        fieldParentView.transform = transform
//        fieldParentView.alpha = 0
//        
   // }
    
    override func viewDidAppear(_ animated: Bool) {
        //Animate the code within over 0.3 seconds...
        UIView.animate(withDuration: 0.3) { () -> Void in
            // Return the views transform properties to their default states.
            self.fieldParentView.transform = CGAffineTransform.identity
            // self.loginNavBar.transform = CGAffineTransform.identity
            // Set the alpha properties of the views to fully opaque
            self.fieldParentView.alpha = 1
            // self.loginNavBar.alpha = 1
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        signinSpinner.isHidden = false
        signinSpinner.startAnimating()
        let username = emailField.text
        let password = passwordField.text
        PFUser.logInWithUsername(inBackground: username!, password: password!) { (user: PFUser?, error: Error?) in
            if error == nil {
                let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
                let eventVC = storyboard.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleViewController
                self.present(eventVC, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
        
        if emailField.text!.isEmpty || passwordField.text!.isEmpty{
            showValidationAlert()
        }else{
            self.signinSpinner.startAnimating()
            delay(2){
                self.signinSpinner.stopAnimating()
                if self.emailField.text == "betty@gmail.com" && self.passwordField.text == "password"{
                    // self.performSegue(withIdentifier: "signinUserSegue", sender: nil)
                    let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
                    let eventVC = storyboard.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleViewController
                    self.present(eventVC, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Incorrect Credentials", message: "Please try again", preferredStyle: .alert)
                    
                    // create a cancel action
                    let cancelAction = UIAlertAction(title: "OK", style:.default) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alertController
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // If the scrollView has been scrolled down by 50px or more...
        if scrollView.contentOffset.y <= -50 {
            // Hide the keyboard
            view.endEditing(true)
        }
    }
    
    // The keyboard is about to be hidden...
    func keyboardWillHide(notification: NSNotification) {
        // Move the buttons back down to it's original position
        buttonParentView.frame.origin.y = buttonInitialY
    }
    
    func showValidationAlert(){
        //login error
        let alertController = UIAlertController(title: "Email & Password Required", message: "Please enter both your email and password", preferredStyle: .alert)
        
        // create a cancel action
        let cancelAction = UIAlertAction(title: "OK", style:.default) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
}


