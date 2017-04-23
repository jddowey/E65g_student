//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Jelena Dowey on 4/21/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var countEmpty: UITextField!
    @IBOutlet weak var countLiving: UITextField!
    @IBOutlet weak var countBorn: UITextField!
    @IBOutlet weak var countDead: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        //observer for the statistics
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "StatisticsUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { notification in
            let userInfo = notification.userInfo!
            self.countEmpty.text = userInfo["numEmpty"] as? String
            self.countLiving.text = userInfo["numLiving"] as? String
            self.countBorn.text = userInfo["numBorn"] as? String
            self.countDead.text = userInfo["numDead"] as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
