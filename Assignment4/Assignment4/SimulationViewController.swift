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
    var timer:Timer?
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
                return self.engine.grid[row,col] == state ? total+1: total
            }
        }
        print ("number of cells of the state \(state) is \(cellNum)")
        return cellNum
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let size = gridView.size
//       let size = StandardEngine.engine.size
        engine = StandardEngine(rows: size, cols: size)
//        engine = StandardEngine.engine
        engine.delegate = self
        engine.updateClosure = { (grid) in
            self.gridView.setNeedsDisplay()
        }
        gridView.gridDataSource = self

        //not needed
        //sizeStepper.value = Double(engine.grid.size.rows)
        
//        let nc = NotificationCenter.default
//        let name = Notification.Name(rawValue: "EngineUpdate")
//        nc.addObserver(
//            forName: name,
//            object: nil,
//            queue: nil) { (n) in
//                self.gridView.setNeedsDisplay()
//        }
        
        var numEmpty: Int {
            return engine.reduce2(gridView.size, gridView.size) { total, row, col in
                return self.engine.grid[row,col] == .empty ? total+1: total
            }
        }
        print ("numEmpty\(numEmpty)")
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let myBlock : (Timer) -> Void = { timer in

            
//            //iterating through the singleton
//            (0 ..< size).forEach { i in
//                (0 ..< size).forEach { j in
//                    if (self.engine.grid[i,j] == .empty) {
//                        intCount += 1
//                        print ("i, j is \(i) \(j) and total \(count)")
//                    } //
////                    //                    else if (engine.grid[(i,j)] == .born) {
////                    //                    colorToBe = bornColor
////                    //                } else if (engine.grid[(i,j)] == .died) {
////                    //                    colorToBe = diedColor
////                    //                }
//                }
//                count = intCount
//            }
//            m = count
//            count = 0
//            var numEmpty: Int {
//                return self.engine.reduce2(self.engine.rows, self.engine.cols) { total, row, col in
//                    return self.engine.grid[row,col] == .empty ? total+1: total
//                }
//            }
//            print ("numEmpty\(numEmpty)")
            let userInfo = ["cellCount": self.steppedGrid,
                            "numEmpty": String(self.steppedGrid.numEmpty),
                            "numLiving": String(self.steppedGrid.numLiving),
                            "numBorn": String(self.steppedGrid.numBorn),
                            "numDead": String(self.steppedGrid.numDead)] as [String : Any]
            let notification = Notification (name: name, object: nil, userInfo: userInfo)
            nc.post(notification)
            
        }
        //end of iterating through the singleton
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: myBlock)
        
        
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func stepDelegate(_ sender: Any) {
//        StandardEngine.engine.grid = StandardEngine.engine.grid.next()
//        gridView.setNeedsDisplay()
//        engine.grid = engine.grid.next()
        engine.grid = self.engine.step()
        //        self.gridView.gridDataSource = engine.step()
        gridView.setNeedsDisplay()

        steppedGrid.numEmpty = countCells(state: .empty)
        steppedGrid.numLiving = countCells(state: .alive)
        steppedGrid.numBorn = countCells(state: .born)
        steppedGrid.numDead = countCells(state: .died)
    }

}

