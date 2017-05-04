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
//    var configuration: [String: [[Int]]] = [:]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DispatchQueue.main.async(){
            self.engine = StandardEngine.engine
            self.engine.delegate = self
            self.gridView.gridDataSource = self
        }

        
    }
    override func viewDidAppear(_ animated: Bool) {
        //        observer for the SizeUpdate
        //        NotificationCenter.default.addObserver(
        //            forName: Notification.Name(rawValue: "SizeUpdate"),
        //            object: nil,
        //            queue: nil) { (n) in
        //                print(n.userInfo?["size"] as! Int)
        //                let updatedSize = n.userInfo?["size"] as! Int
        //                self.engine.grid = Grid(GridSize(rows: updatedSize, cols: updatedSize))
        //                self.gridView.setNeedsDisplay()
        //        }
        
        //observer for the EngineUpdate
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "EngineUpdate"),
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
        //observer for the GridUpdate in GridView
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "GridUpdate"),
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }

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
        engine.grid = engine.step()
        gridView.setNeedsDisplay()
    }
    func showAlert() {
        let alertController = UIAlertController(title: "Would you like to save the grid?", message: "Please enter the name of the grid configuration:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store the data
                configuration.removeAll()
                
                _ = self.engine.grid.setConfiguration()
                print("configuration \(configuration)")
                UserDefaults.standard.set(field.text, forKey: field.text!)
                UserDefaults.standard.synchronize()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Configuration Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }


    @IBAction func stepDelegate(_ sender: Any) {
        _ = stepUp()

    }
    
    @IBAction func saveGrid(_ sender: Any) {

            configuration.removeAll()

                _ = engine.grid.setConfiguration()
            print("configuration \(configuration)")

        
    }
    
    @IBAction func resetGrid(_ sender: Any) {
        engine.grid = Grid(GridSize(rows: gridView.rows, cols: gridView.cols))
    }
    

}

