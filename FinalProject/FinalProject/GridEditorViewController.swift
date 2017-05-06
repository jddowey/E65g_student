//
//  GridEditorViewController.swift
//  Assignment4
//
//  Created by Jelena Dowey on 4/28/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource {
    
    var engine: EngineProtocol!
    
    var variationValue: String?
    
    var saveClosure: ((String) -> Void)?
    
    var gridVariationInstance: GridVariation!
    
    var timer: Timer?



    @IBOutlet weak var variationValueTextField: UITextField!

    @IBOutlet weak var gridViewEditor: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //access to StandardEngine instance
        engine = StandardEngine.engine
        //access to the GridVariations (json and user saved data) instance
        gridVariationInstance = GridVariation.gridVariationSingleton
        //gridDataSource delegate
        gridViewEditor.gridDataSource = self

        navigationController?.isNavigationBarHidden = false

        if let variationValue = variationValue {
            variationValueTextField.text = variationValue
            gridVariationInstance?.selectedVariation = variationValue
            guard let newConfiguration = gridVariationInstance?.createVariationGrid() else {return}
            engine.grid = newConfiguration

        }
        //end if
    }
    
    //conforming to GridViewDataSource protocol
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }
    override func viewDidDisappear(_ animated: Bool) {
        //redraw an empty grid
        engine.grid = Grid(GridSize(rows: gridViewEditor.rows, cols: gridViewEditor.cols))
        print("GridEditor: viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveToJsonFile() {
        // Get the url of userGridVariation.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("userGridVariation.json")
        print("fileUrl \(fileUrl)")
        // Create the .json file in document directory if necessary
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            _ = FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        // Create a write-only stream
        guard let stream = OutputStream(toFileAtPath: fileUrl.path, append: false) else { return }
        stream.open()
        defer {
            stream.close()
        }
        
        // Transform array into data and save it into file
        var error: NSError?
        JSONSerialization.writeJSONObject(gridVariationInstance?.variationsData ?? [], to: stream, options: [], error: &error)
        
        // Handle error
        if let error = error {
            print(error)
        }
    }
    
    @IBAction func saveUserGridVariation(_ sender: Any) {
        let lastGrid: GridProtocol = engine.grid
        print("LAST GRID in the GRID EDITOR \(lastGrid)")
        
//        guard let lastGrid = gridVariationInstance?.createVariationGrid() else {return}
//        print("LAST GRID in the GRID EDITOR \(lastGrid)")
        //post notification GridEditorEngineUpdate
        let nge = NotificationCenter.default
//        let lastVariation :(Timer) -> Void = { timer in
//            let userInfo = ["lastGrid" : lastGrid]
//            let notificationGE = Notification(name: Notification.Name(rawValue: "GridEditorEngineUpdate"),
//                                   object: nil,
//                                   userInfo: userInfo)
//            nge.post(notificationGE)
//        }
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: lastVariation)

            let notificationGE = Notification(name: Notification.Name(rawValue: "GridEditorEngineUpdate"),
                        object: nil,
                        userInfo: ["lastGrid" : lastGrid])
            nge.post(notificationGE)


        //create a name
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy h:mm a Z"
        let now = dateformatter.string(from: NSDate() as Date)
        let newName = variationValueTextField.text! + " " + now
        
        configuration.removeAll()
        
        _ = engine.grid.setConfiguration()


        gridVariationInstance?.variationsData.updateValue([configuration.keys.first!: configuration["alive"]!], forKey: newName)


 //       _ = saveToJsonFile()
        
        OperationQueue.main.addOperation {

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.gridVariationInstance?.variationsData ?? ["initial row": ["alive": [[0, 0]]]], options: [])
                let theJSONText = String(data: jsonData,
                                     encoding: .ascii)
 //               print("JSON string = \(theJSONText!)")
            }
            catch   {
 //               print(error.localizedDescription)
            }
        }
        //figure out the condition
//        let newValue = newName
//        if newValue != nil,
//            let saveClosure = saveClosure {
//            saveClosure(newValue)
//            self.navigationController?.popViewController(animated: true)
//        }
        gridVariationInstance.saveClicked = true
        navigationController?.popViewController(animated: true)

//        if let newValue = variationValueTextField.text,
//            let saveClosure = saveClosure {
//            saveClosure(newValue)
//            self.navigationController?.popViewController(animated: true)
//        }
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
