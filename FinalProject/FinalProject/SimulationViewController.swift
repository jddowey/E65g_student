//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    
    @IBOutlet weak var gridView: GridView!
    
    var engine: EngineProtocol!
    var timer: Timer?
    
    struct CellCounts {
        var numLiving: Int = 0
        var numEmpty: Int = 0
        var numBorn: Int = 0
        var numDead: Int = 0
    }
    var steppedGrid = CellCounts()

    
    func countCells(state: CellState)->Int{
        var cellNum: Int {
            return engine.reduce2(gridView.size, gridView.size) { total, row, col in
                return engine.grid[row,col] == state ? total+1: total
            }
        }
        print ("The number of cells (state - \(state) ) is \(cellNum)")
        return cellNum
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let size = gridView.size
//        engine = StandardEngine(rows: size, cols: size)
        engine = StandardEngine.engine
        engine.delegate = self
        gridView.gridDataSource = self
//        engine = StandardEngine(rows: gridView.size, cols: gridView.size)
//        engine.rows = gridView.size
//        engine.cols = gridView.size
         gridView.size = engine.grid.size.rows
//        gridView.newGridToUpdate = self
        
        //observer for the EngineUpdate
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "EngineUpdate"),
            object: nil,
            queue: nil) { (n) in
//                self.engine.rows = self.gridView.size
//                self.gridView.size = self.engine.grid.size.rows
                self.gridView.setNeedsDisplay()
        }
        

    
        //notification for the statistics
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "StatisticsUpdate")
        let myCounts : (Timer) -> Void = { timer in
            let userInfo = ["cellCount": self.steppedGrid,
                            "numEmpty": String(self.steppedGrid.numEmpty),
                            "numLiving": String(self.steppedGrid.numLiving),
                            "numBorn": String(self.steppedGrid.numBorn),
                            "numDead": String(self.steppedGrid.numDead)] as [String : Any]
            let notificationStats = Notification (name: name, object: nil, userInfo: userInfo)
            nc.post(notificationStats)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: myCounts)
        
        
    }
    //conforming to Engine Delegate protocol
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
//        engine.rows = self.gridView.size
 //       engine.cols = self.gridView.size
    }
    //conforming to GridViewDataSource protocol
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func stepUp (){
 //       StandardEngine.engine.grid = gridView.gridDataSource as! GridProtocol
        
//        self.grid = self.gridView
//        _ = engine.step()
//        self.gridView.gridDataSource = StandardEngine.engine.grid as! GridViewDataSource
        engine.grid = engine.step()
        gridView.setNeedsDisplay()
        steppedGrid.numEmpty = countCells(state: .empty)
        steppedGrid.numLiving = countCells(state: .alive)
        steppedGrid.numBorn = countCells(state: .born)
        steppedGrid.numDead = countCells(state: .died)
    }

    @IBAction func stepDelegate(_ sender: Any) {
        _ = stepUp()

    }

}

