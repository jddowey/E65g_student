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
    var gridVariations:GridVariation!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridVariations = GridVariation.gridVariationSingleton
        engine = StandardEngine.engine
        engine.delegate = self
        gridView.gridDataSource = self
      
        //load from defaults if exists, e.g. user saved in the SimulationView
        if UserDefaults.standard.object(forKey: "lastVariation") != nil {
            
            let recoveredVariation = UserDefaults.standard.object(forKey: "lastVariation")
            gridVariations.variationsData.updateValue(recoveredVariation as! [String : [[Int]]], forKey: "lastVariation")
            gridVariations.selectedVariation = "lastVariation"
            guard let recoveredConfiguration = gridVariations?.createVariationGrid() else {return}
            engine.grid = recoveredConfiguration
            
            //delete from defaults, so next time when application is launched, user doesn't get the same object
            UserDefaults.standard.removeObject(forKey: "lastVariation")

            //check if anything has been saved by pressing save button in the GridEditor
        } else if gridVariations.savedVariation == false {
            
            engine.grid = Grid(GridSize(rows: gridView.rows, cols: gridView.cols))
            gridVariations.savedVariation = true
        }
        
        //watch for the notification from GridEditor
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "GridEditorEngineUpdate"),
            object: nil,
            queue: nil) { n in
                guard let receivedN:GridProtocol = n.userInfo!["lastGrid"] as? GridProtocol else {return}
                self.engine.grid = receivedN
        }


        
    }
    override func viewWillAppear(_ animated: Bool) {

        //observer for the EngineUpdate
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "EngineUpdate"),
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
//        //observer for the GridUpdate in GridView
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "GridUpdate"),
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "GridEditorEngineUpdate"),
            object: nil,
            queue: nil) { notification in
                let userInfo = notification.userInfo!
                self.engine.grid = notification.userInfo?["lastGrid"] as! GridProtocol
        }
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
                //store the key value
                configuration.removeAll()
                _ = self.engine.grid.setConfiguration()
                self.gridVariations?.variationsData.updateValue(configuration, forKey: field.text!)
                UserDefaults.standard.set(configuration, forKey: "lastVariation")
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

        _ = showAlert()
        
        // store the data in json format
        //I implemented this due to me misinterpretating the project requirements
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject:configuration, options: [])
//                let theJSONText = String(data: jsonData,
//                                         encoding: .ascii)
//                print("JSON data = \(jsonData)")
//                print("JSON string = \(theJSONText!)")
//                UserDefaults.standard.set(jsonData, forKey: "lastVariation")
//                UserDefaults.standard.synchronize()
//            }
//            catch   {
//                print(error.localizedDescription)
//            }
        
    }
    
    @IBAction func resetGrid(_ sender: Any) {
        engine.grid = Grid(GridSize(rows: gridView.rows, cols: gridView.cols))
    }
    
    //conforming to Engine Delegate protocol
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    //conforming to GridViewDataSource protocol
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }
    

}

