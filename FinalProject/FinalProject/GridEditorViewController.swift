//
//  GridEditorViewController.swift
//  Assignment4
//
//  Created by Jelena Dowey on 4/28/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource {
    
    @IBOutlet weak var variationValueName: UILabel!
    @IBOutlet weak var gridViewEditor: GridView!
    
    var variationValue: String?
    var engine: EngineProtocol!
    var gridVariations: GridVariation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //access to StandardEngine instance
        engine = StandardEngine.engine
        
        //access to the GridVariations (json and user saved data) instance
        gridVariations = GridVariation.gridVariationSingleton
        
        //gridDataSource delegate
        gridViewEditor.gridDataSource = self
        
        //navigation controller bar
        navigationController?.isNavigationBarHidden = false

        //assign grid to the selected variation, if there is any
        if let variationValue = variationValue {
            variationValueName.text = variationValue
            gridVariations?.selectedVariation = variationValue
            guard let newConfiguration = gridVariations?.createVariationGrid() else {return}
            engine.grid = newConfiguration
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this function was created because I misinterpreted project requirements and thought that we need to save to a json file on the hard drive
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
        JSONSerialization.writeJSONObject(gridVariations?.variationsData ?? [], to: stream, options: [], error: &error)
        
        // Handle error
        if let error = error {
            print(error)
        }
    }
    
    @IBAction func saveUserGridVariation(_ sender: Any) {
        let lastGrid: GridProtocol = engine.grid
        
        //post notification GridEditorEngineUpdate
        let nge = NotificationCenter.default
        let notificationGE = Notification(name: Notification.Name(rawValue: "GridEditorEngineUpdate"),
                        object: nil,
                        userInfo: ["lastGrid" : lastGrid])
        nge.post(notificationGE)


        //create a name
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy h:mm a Z"
        let now = dateformatter.string(from: NSDate() as Date)
        let newName = variationValueName.text! + " " + now
        
        //createa configuration
        configuration.removeAll()
        _ = engine.grid.setConfiguration()
        
        //update gridVariations instance
        gridVariations?.variationsData.updateValue([configuration.keys.first!: configuration["alive"]!], forKey: newName)

        //if we were to save in json format to the hard drive
 //       _ = saveToJsonFile()
        
        //make a mark that the instance has been saved
        gridVariations?.savedVariation = true
        
        //return to the InstrumenatationViewController
        navigationController?.popViewController(animated: true)
    }
    
    //conforming to GridViewDataSource protocol
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
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
