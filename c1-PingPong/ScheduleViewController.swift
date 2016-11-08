//
//  ScheduleViewController.swift
//  Reseve Me
//
//  Created by Alexander Sung on 10/30/16.
//  Copyright © 2016 Stars99. All rights reserved.
//

import UIKit
import Parse

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var scheduleTableView: UITableView!
    var currentCell: ScheduleCell!
    var currentCellCenter: CGPoint!
    var names:[String]!
    var initials:[String]!
    var times:[String]!
    var scheduleData:[PFObject]!
    var headerArray:[String]!
    var rowCountArray = [Int]()
    var tableViewIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callScheduleAPI()
        tableViewIndex = 0

        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        scheduleTableView.refreshControl = UIRefreshControl.init()
        scheduleTableView.refreshControl?.addTarget(self, action: #selector(refreshTableView), for: UIControlEvents.valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func callScheduleAPI() {
        headerArray = []
        rowCountArray = []
        let query = PFQuery(className:"Schedule")
        query.order(byAscending: "startingDate")
        query.includeKey("user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) in
            self.scheduleData = objects
            if (objects?.count)! < 1 {
                return
            }
            let firstEvent = objects![0]
            print(firstEvent["startingDate"])
            self.updateRowAndHeaderArrays()
            print(self.rowCountArray)
            self.scheduleTableView.reloadData()
        }
        
    }
    
    func updateRowAndHeaderArrays() {
        headerArray = []
        rowCountArray = []
        var index = 0
        for events in self.scheduleData! {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone!
            dateFormatter.dateFormat = "LLLL d"
            let stringDate = dateFormatter.string(from: events["startingDate"] as! Date)
            print(stringDate)
            if !self.headerArray.contains(stringDate) {
                self.headerArray.append(dateFormatter.string(from: events["startingDate"] as! Date))
                self.rowCountArray.append(1)
                print(self.rowCountArray)
                index += 1
            } else {
                self.rowCountArray[index - 1] = self.rowCountArray[index - 1] + 1
            }
        }

    }
    

    func refreshTableView() {
        let delayInSeconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {

            self.callScheduleAPI()
            
            self.scheduleTableView.reloadData()
            self.scheduleTableView.refreshControl?.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleData == nil ? 0 : rowCountArray[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerArray == nil ? 0 : headerArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  headerArray == nil ? "" : headerArray[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewIndex = 0
        let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "ScheduleCell")! as! ScheduleCell
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
//        panGestureRecognizer.delegate = self
//        cell.addGestureRecognizer(panGestureRecognizer)
        
        //need to account for section later
        
        cell.nameLabel.text = "User 5"
        cell.initialsLabel.text = "AS"
        let hourDateFormatter = DateFormatter()
        hourDateFormatter.dateFormat = "hh:mm a"
//        let dayDateFormatter = DateFormatter()
//        dayDateFormatter.dateFormat = "LLLL d"
//        let sectionDay = dayDateFormatter.date(from: headerArray[indexPath.section])
//        for eventObject in scheduleData! {
//            let dateForEvent = eventObject["startingDate"] as! Date
//            if Calendar.current.isDate(sectionDay!, inSameDayAs: dateForEvent) {
////                let section = index
//            }
//        }
        
        // generate tableViewIndex based on current row and section
        if indexPath.section == 0 {
            tableViewIndex = indexPath.row
        } else {
            for rowCount in 0...indexPath.section - 1{
                tableViewIndex = tableViewIndex + rowCountArray[rowCount]
            }
            tableViewIndex = tableViewIndex + indexPath.row
        }
//        print("section-\(indexPath.section) row-\(indexPath.row)")
//        print(tableViewIndex)
        cell.tag = tableViewIndex
        cell.startingTimeLabel.text = hourDateFormatter.string(from:scheduleData[tableViewIndex]["startingDate"] as! Date)
        cell.endingTimeLabel.text = hourDateFormatter.string(from:scheduleData[tableViewIndex]["endingDate"] as! Date)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        if scheduleData[tableViewIndex]["userID"] as! String == user.ID {
//            cell.cellBar.backgroundColor = UIColor.red
//        } else {
//            cell.cellBar.backgroundColor = UIColor.blue
//        }
        tableViewIndex = 0
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        var eventForDeletion = PFObject(className:"Schedule")
        print(scheduleData[(tableView.cellForRow(at: indexPath)?.tag)!])
//        eventForDeletion["objectID"] = scheduleData[(tableView.cellForRow(at: indexPath)?.tag)!]
        eventForDeletion = scheduleData[(tableView.cellForRow(at: indexPath)?.tag)!]
        eventForDeletion.deleteInBackground { (bool: Bool, error: Error?) in
            if (error != nil) {
                print(error?.localizedDescription ?? "error happened")
            } else {
                self.scheduleData.remove(at: (tableView.cellForRow(at: indexPath)?.tag)!)
                self.updateRowAndHeaderArrays()
                print("deletion was a success")
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            }
        }
        tableView.reloadData()
//        if names[indexPath.row] == "Alexander Sung" {
//            if editingStyle == UITableViewCellEditingStyle.delete {
//                names.remove(at:indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
//                //            tableView.reloadData()
//            }
//        } else {
//            let errorAlert = UIAlertController(title: "Error", message: "You can only delete your own events.", preferredStyle: .alert)
//            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(errorAlert, animated: true, completion: nil)
//        }

        
        
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
        
//        if names[indexPath.row] == "Alexander Sung"  {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let eventVC = storyboard.instantiateViewController(withIdentifier: "reserveVC") as! ReserveTableViewController
//            self.present(eventVC, animated: true, completion: nil)
//        }
//        else {
//            let errorAlert = UIAlertController(title: "Error", message: "You can only edit your own events.", preferredStyle: .alert)
//            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(errorAlert, animated: true, completion: nil)
//        }
//        
    }
    

    @IBAction func panScheduleCell(_ sender: UIPanGestureRecognizer) {
        
        
    }
    
    
    //to actually pan cells
    /*
    func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        print(translation)
        if sender.state == .began {
            currentCell = sender.view as! ScheduleCell
            currentCellCenter = currentCell.center
        } else if sender.state == .changed {
            currentCell.center = CGPoint(x: currentCellCenter.x + translation.x, y: currentCellCenter.y)
            if translation.x < -60 && translation.x > -260 {
                scheduleTableView.backgroundColor = UIColor.yellow
//                rightIcon.center = CGPoint(x: rightIconOriginalCenter.x + translation.x + 60, y: rightIconOriginalCenter.y)
            } else if translation.x < -260 {
                scheduleTableView.backgroundColor = UIColor.red
            }
//                rightIcon.image = UIImage(named:"list_icon")
//                rightIcon.center = CGPoint(x: rightIconOriginalCenter.x + translation.x + 60, y: rightIconOriginalCenter.y)

        } else if sender.state == .ended {
            if translation.x > -60 && translation.x < 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.currentCell.center = self.currentCellCenter
                                self.scheduleTableView.backgroundColor = UIColor.white
//                                self.rightIcon.center = self.rightIconOriginalCenter
                }, completion: nil)
            } else if translation.x < -60 && translation.x > -260 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.currentCell.frame.origin.x = (self.currentCell.frame.size.width * -1)
                                self.scheduleTableView.backgroundColor = UIColor.white
//                                self.rightIcon.frame.origin.x = 15
                }, completion: {(Bool)  in
                    self.scheduleTableView.backgroundColor = UIColor.white
                    self.names.remove(at:self.currentCell.tag)
//                    self.scheduleTableView.deleteRows(at: [NSIndexPath(row: self.currentCell.tag, section: 0) as IndexPath], with: UITableViewRowAnimation.left)
                    
                    self.scheduleTableView.reloadData()
                    
                    //                    self.rescheduleImageView.alpha = 1
                })
            } else if translation.x < -260 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.currentCell.frame.origin.x = (self.currentCell.frame.size.width * -1)
//                                self.rightIcon.frame.origin.x = 15
                }, completion: {(Bool)  in
                    self.scheduleTableView.backgroundColor = UIColor.white
//                    self.listImageView.alpha = 1
                })
            }

            
//            UIView.animate(withDuration:0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,
//                           options: [],
//                           animations: { () -> Void in
//                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }, completion: nil)
//            
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
 */

    
    
}
