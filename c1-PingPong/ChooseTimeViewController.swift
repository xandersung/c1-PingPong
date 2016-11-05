//
//  ChooseTimeViewController.swift
//  c1-PingPong
//
//  Created by Poudel, Trilochan on 11/5/16.
//  Copyright © 2016 Alexander Sung. All rights reserved.
//

import UIKit

class ChooseTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var label: UILabel!
 
    @IBOutlet weak var tableView: UITableView!
    var dateFrom: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        
        label.text = dateFrom
      
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
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
            var destinationation = segue.destination as! ReserveTableViewController
            print("going from choose view to reserve view")
            // destination.items = [dateLabel.text!]
            dismiss(animated: true, completion: nil)
            
        } else {
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
