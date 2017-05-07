//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Jelena Dowey on 4/21/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var countEmpty: UILabel!
    @IBOutlet weak var countLiving: UILabel!
    @IBOutlet weak var countBorn: UILabel!
    @IBOutlet weak var countDead: UILabel!

    var engine: EngineProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.engine

        countEmpty.text = String(engine.grid.returnPositions(state: .empty).count)
        countLiving.text = String(engine.grid.returnPositions(state: .alive).count)
        countBorn.text = String(engine.grid.returnPositions(state: .born).count)
        countDead.text = String(engine.grid.returnPositions(state: .died).count)

        //observer for the statistics when grid has changed
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "GridUpdate"),
            object: nil,
            queue: nil) { (n) in    
                self.countEmpty.text = String(self.engine.grid.returnPositions(state: .empty).count)
                self.countLiving.text = String(self.engine.grid.returnPositions(state: .alive).count)
                self.countBorn.text = String(self.engine.grid.returnPositions(state: .born).count)
                self.countDead.text = String(self.engine.grid.returnPositions(state: .died).count)
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
