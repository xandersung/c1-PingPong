//
//  ReserveTableViewController.swift
//  Reseve Me
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
    @IBOutlet weak var bubleIcon: UIImageView!
    @IBOutlet weak var selectTimeLength: UIButton!
    var minutes: Date!
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
                self.bubleIcon.transform = CGAffineTransform(translationX: 0, y: 10)
                //  self.selectTimeLength.transform = CGAffineTransform(translationX: 0, y: 10)
                
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
    
    
    
    
    //Press length of the play button to select a time
    @IBAction func didPress30(_ sender: AnyObject) {
        //Enables reserve button
        reserveTableBtn.isEnabled = true
        
        let actionSheet = AFMActionSheetController(style: .actionSheet)
        let action0 = AFMAction(title: "30 minutes", enabled: true, handler: { (action: AFMAction) -> Void in
            self.minutes =  self.datePicker.date+(timeIntervalSinceNow: 60 * 30)
            
        })
        
        
        let action1 = AFMAction(title: "60 minutes", enabled: true, handler: { (action: AFMAction) -> Void in
            self.minutes  =  self.datePicker.date+(timeIntervalSinceNow: 60 * 60)
        })
        
        
        let action2 = AFMAction(title: "75 minutes", enabled: true, handler: { (action: AFMAction) -> Void in
            self.minutes  =  self.datePicker.date+(timeIntervalSinceNow: 60 * 75)
        })
        
        
        let action3 = AFMAction(title: "90 minutes", enabled: true, handler: { (action: AFMAction) -> Void in
            self.minutes  =  self.datePicker.date+(timeIntervalSinceNow: 60 * 90)
        })
        
        let action = AFMAction(title: "Cancel", enabled: true, handler: { (action: AFMAction) -> Void in
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
        _ = subview.subviews.first! as UIView
        
        //  actionSheet.backgroundColor = UIColor.lightGray
        //  actionSheet.view.backgroundColor = UIColor.lightGray
        
        self.present(actionSheet, animated: true, completion: {
            //Disable wheel after user chooses the time
            // self.datePicker.isEnabled = false
            
        })
        
    }
    
    
    
    
    
    
    
    
    //This querys the ending and starting date from parse
    func queryEndingAndStartDateAndCompare() {
        //Get starting and ending dates
        let query = PFQuery(className: "Schedule")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                //  print(objects)
                
                if let returnedobjects = objects {
                    for object in returnedobjects {
                        
                        // print(object["startingDate"] as! Date)
                        // print(object["endingDate"] as! Date)
                        
                        
                        let startingDate = (object["startingDate"] as! Date)
                        let endingDate = (object["endingDate"] as! Date)
                        
                        
                        
                        //
                        //
                        //                        if datePicker.date > startingDate && datePicker.date < endingDate {
                        //
                        //                            //invalid
                        //
                        //                        }
                        //
                        //                        if datePicker.date > startingDate && minutes < endingDate {
                        //
                        //
                        //                        }
                        //
                        
//                        if (startingDate...endingDate).contains(self.datePicker.date) ||  (startingDate...endingDate).contains(self.minutes) {
//                            print("error already reseved")
//                            
//                        } else if (self.datePicker.date...self.minutes).contains(startingDate) &&  (self.datePicker.date...self.minutes).contains(endingDate)  {
//                            
//                            
//                        } else {
//                            print("Sucess!!!")
//                        }
                    }
                    
                }
                
                
            }
        }
    }
    
    
    
    
    
    
    //Press Reserve button to send the servation request
    @IBAction func didPressReserveBtn(_ sender: UIButton) {
        
        let startingDate = self.datePicker.date
        let endingDate = self.minutes!
        
        let invalidStartingDateQuery = PFQuery(className: "Schedule")
        invalidStartingDateQuery.whereKey("startingDate", lessThan: startingDate)
        invalidStartingDateQuery.whereKey("endingDate", greaterThan: startingDate)
        invalidStartingDateQuery.whereKey("startingDate", equalTo: startingDate)  // added later
        
        
        let invalidEndingDateQuery = PFQuery(className: "Schedule")
        invalidEndingDateQuery.whereKey("startingDate", lessThan: endingDate)
        invalidEndingDateQuery.whereKey("endingDate", greaterThan: endingDate)
        invalidEndingDateQuery.whereKey("endingDate", equalTo: endingDate) // added later
        
        
        
        let query = PFQuery.orQuery(withSubqueries: [invalidStartingDateQuery, invalidEndingDateQuery])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if objects?.count ?? 0 > 0 {
                // There is a conflicting reservation
                
                print("There is a conflicting reservation")
                let alertController = UIAlertController(title: "Failure!!!", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Schedule", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true) {
                    self.reserveTableBtn.isEnabled = false
                    
                }
                
                
                
            } else {
                // No conflicting reservation
                self.saveReservation(startingDate: startingDate, endingDate: endingDate)
                let alertController = UIAlertController(title: "Success!!", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Schedule", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true) {
                    self.reserveTableBtn.isEnabled = false
                }
            }
        }
        
    }
    
    func saveReservation(startingDate: Date, endingDate: Date) {
        let reservation = PFObject(className:"Schedule")
        reservation["startingDate"] = startingDate
        //Uncomment when login plugin
        //---reservation["user"] = PFUser.current()
        reservation["endingDate"] = endingDate
        
        
        // self.datePicker.isEnabled = true
        
        //should get from user vc
        reservation["userID"] = 5
        
        
        reservation.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("reservation saved")
            } else {
                print("error")
                let alertController = UIAlertController(title: "Network error", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Dissmis", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true) {
                    self.reserveTableBtn.isEnabled = false
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
