//
//  ChooseTimeViewController.swift
//  c1-PingPong
//
//  Created by Poudel, Trilochan on 11/5/16.
//  Copyright © 2016 Alexander Sung. All rights reserved.
//

import UIKit
import Parse
class ChooseTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var label: UILabel!
 
    @IBOutlet weak var tableView: UITableView!
    var dateFrom: String = ""
    
    var dates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        label.text = dateFrom
        
        
        /*
        
     let query = PFQuery(className: "Schedule")
        query.getObjectInBackground(withId: "03uPERpDK9") { (object, error) in
            
            if object != nil && error == nil {
                print(object?["endingDate"] as! Date)
                print(object?["startingDate"] as! Date)
            }
            else {
                //
            }
            
        }
 */
        
         let query = PFQuery(className: "Schedule")
         query.findObjectsInBackground { (objects, error) in
            if error == nil {
            if let returnedobjects = objects {
                for object in returnedobjects {
                 
                    print(object["endingDate"] as! Date)
                    print(object["startingDate"] as! Date)
                    

                }
            }
            }
        }
        
        
           }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        return cell
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneButtonSegue" {
            let destinationation = segue.destination as! ReserveTableViewController
            print("going from choose view to reserve view")
            // destination.items = [dateLabel.text!]
            dismiss(animated: true, completion: nil)
            
        } else {
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
