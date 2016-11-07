//
//  ReserveTableViewController.swift
//  Reseve Me
//
//  Created by Poudel, Trilochan on 10/27/16.
//  Copyright © 2016 Stars99. All rights reserved.
//

import UIKit
import Parse
import AFMActionSheet
struct PFDate {
    var startingDate: Date
    var endingDate: Date
}

class ReserveTableViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var reserveTableBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reserveBtn: UIButton!
    
    var added30Minutes: Date!
    
    
    
    var myDateLabel = [String]()
    var datesArray = [PFDate]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reserveTableBtn.isEnabled = false
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "EEEE"
        dateLabel.text = formatter.string(from: datePicker.date)
        
        formatter.dateFormat = "hh:mm a"
        timeLabel.text = formatter.string(from: datePicker.date)
        
        
        UIView.animate(withDuration:0.8, delay: 0.0,
                       // Autoreverse runs the animation backwards and Repeat cycles the animation indefinitely.
            options: [.autoreverse,.repeat], animations: { () -> Void in
                // self.exploreLabel.transform = CGAffineTransform(translationX: 0, y: 10)
            }, completion: nil)
        
        
        
        
        
    }
    @IBAction func pickerValueChanged(_ sender: AnyObject) {
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "EEEE"
        dateLabel.text = formatter.string(from: datePicker.date)
        
        formatter.dateFormat = "hh:mm a"
        timeLabel.text = formatter.string(from: datePicker.date)
        
        
        //Only allow to reserve for a future date and not past date
        datePicker.minimumDate = Date()
        
        
        //Only allow user to reserve for till next week
        let secondsInMonth: TimeInterval = 7 * 24 * 60 * 60
        datePicker.maximumDate = NSDate(timeInterval: secondsInMonth, since: NSDate() as Date) as Date
        
        
        UIView.animate(withDuration:0.8, delay: 0.0,
                       options: [.autoreverse,.repeat], animations: { () -> Void in
                        //  self.exploreLabel.transform = CGAffineTransform(translationX: 0, y: 10)
            }, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPressReserveBtn(_ sender: UIButton) {
        var reservation = PFObject(className:"Schedule")
        reservation["startingDate"] = datePicker.date
        
        
        //should get from user vc
        reservation["userID"] = 5
        
        
        //This will get the user anme from user
        //--------------  reservation["user"] = PFUser.current()
        
        
        
        //adding 30 minutes to the current date
      //  reservation["endingDate"] =  datePicker.date+(timeIntervalSinceNow: 60 * 30)
        
        
        reservation["endingDate"] =   added30Minutes
        
        
        
        reservation.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("reservation saved")
            } else {
                
            }
        }
        
        dismiss(animated: true, completion: nil)
        
        
        
        
                        let alertController = UIAlertController(title: "Success!", message: nil, preferredStyle: .alert)
        
                      //  let alertController = UIAlertController(title: "Success!", message: nil, preferredStyle: .alert)
        
                      //  let successMessage = UIAlertAction(title: "Reserved", style: .default) { (action) in
                          
                      //  }
        
        
                        // add the logout action to the alert controller
                      //  alertController.addAction(successMessage)
                        let cancelAction = UIAlertAction(title: "Go to Schedule", style: .cancel) { (action) in
        
        
                            // handle case of user canceling. Doing nothing will dismiss the view.
                        }
        
        
                        // add the cancel action to the alert controller
        
                         alertController.addAction(cancelAction)
                        let subview = alertController.view.subviews.first! as UIView
                        let alertContentView = subview.subviews.first! as UIView
        
                        // alertContentView.alpha = 0.50
                        alertContentView.backgroundColor = UIColor.clear
        
        
                        present(alertController, animated: true) {
                            // optional code for what happens after the alert controller has finished presenting
        
                            alertContentView.alpha = 0.9
                            self.reserveTableBtn.isEnabled = false

                        }
        
        
        
    }
    

    @IBAction func didPress30(_ sender: AnyObject) {
        //Enables reserve button
        reserveTableBtn.isEnabled = true
        let actionSheet = AFMActionSheetController(style: .actionSheet)
        let action0 = AFMAction(title: "30 minutes", enabled: true, handler: { (action: AFMAction) -> Void in
            // Do something in handler
             self.added30Minutes =  self.datePicker.date+(timeIntervalSinceNow: 60 * 30)
        })
        
        
        let action1 = AFMAction(title: "60 minutes", enabled: true, handler: { (action: AFMAction) -> Void in
            // Do something in handler
             self.added30Minutes  =  self.datePicker.date+(timeIntervalSinceNow: 60 * 60)
        })
        
        
        let action2 = AFMAction(title: "75 minutes", enabled: true, handler: { (action: AFMAction) -> Void in
            // Do something in handler
             self.added30Minutes  =  self.datePicker.date+(timeIntervalSinceNow: 60 * 75)
        })
        
    
        let action3 = AFMAction(title: "90 minutes", enabled: true, handler: { (action: AFMAction) -> Void in
            // Do something in handler
            //adds 90 minutes
             self.added30Minutes  =  self.datePicker.date+(timeIntervalSinceNow: 60 * 90)
        })
        
        let action = AFMAction(title: "Cancel", enabled: true, handler: { (action: AFMAction) -> Void in
            // Do something in handler
            self.reserveTableBtn.isEnabled = false
            actionSheet.add(cancelling: action)
        })
        
        
        actionSheet.add(titleLabelWith: "LENGTH OF PLAY!")
        actionSheet.add(action0)
        actionSheet.add(action1)
        actionSheet.add(action2)
        actionSheet.add(action3)
        actionSheet.add(action)
        
        let subview = actionSheet.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        
        // actionSheet.backgroundColor = UIColor.lightGray
        
      //  actionSheet.view.backgroundColor = UIColor.lightGray
        
        self.present(actionSheet, animated: true, completion: {
            // Do something after completion
            alertContentView.backgroundColor = UIColor.groupTableViewBackground
        })
        
        let query = PFQuery(className: "Schedule")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if let returnedobjects = objects {
                    for object in returnedobjects {
                        


                      //  print(object["startingDate"] as! Date)
                      //  print(object["endingDate"] as! Date)
                        // Get starting date
                        let startingDate = (object["startingDate"] as! Date)
                        
                        
                        // Get a later date
                        let endingDate = (object["endingDate"] as! Date)
                        let pfDate = PFDate(startingDate: startingDate, endingDate: endingDate)
                        
                        self.datesArray += [pfDate]
                    }
                }
            }
            print(self.datesArray)
        }
        
        

        
        
//        
//        // Compare them
//        switch startingDate.compare(endingDate) {
//        case .OrderedAscending     :   print("Date A is earlier than date B")
//        case .OrderedDescending    :   print("Date A is later than date B")
//        case .OrderedSame          :   print("The two dates are the same")
//        }
//        
   }
}
    
    
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lengthOfPlaySegue" {
            
            let destination = segue.destination as! ChooseTimeViewController
            
            // let destinationController = segue.destination as! LengthOfPlayViewController
            
            destination.dateFrom = String(describing: datePicker.date)
            
            
            // destination.dateFrom = [String(describing: datePicker.date)]
            
            
        } else {
            
            //let destinationController = segue.destination as! SuccessViewController
            
        }
        
        
        
    }
}

*/


