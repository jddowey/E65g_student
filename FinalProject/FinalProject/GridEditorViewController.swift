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
    
    var updatedGridVariations: GridVariation?
    


    @IBOutlet weak var variationValueTextField: UITextField!
    @IBOutlet weak var gridEditorView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = StandardEngine.engine
       gridEditorView.gridDataSource = self
//        gridView.size = engine.grid.size.rows

        navigationController?.isNavigationBarHidden = false
        if let variationValue = variationValue {
            variationValueTextField.text = variationValue
            
        }
        

    }
    
    //conforming to GridViewDataSource protocol
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveUserGridVariation(_ sender: Any) {
        //for the name
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy h:mm a Z"
        
        let now = dateformatter.string(from: NSDate() as Date)
        let newName = variationValueTextField.text! + " " + now
        print("newName \(newName)")
        let size = engine.grid.size.rows
        print("size in the GridEditorViewController \(size)")
//            .reduce(0){$0 > $1 ? $0 : $1}
//        print("save button works")
        var myArr: [[Int]] = []
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                if  (gridEditorView.gridDataSource?[i,j] == .alive){
                myArr.append([i,j])
                }
            }
        }

        print("myArr \(myArr)")
        //access to the GridVariations (json and user saved data) singleton
        updatedGridVariations = GridVariation.gridVariationSingleton
        updatedGridVariations?.variationsData.updateValue(["alive" : myArr], forKey: newName)
        
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
            JSONSerialization.writeJSONObject(updatedGridVariations?.variationsData ?? [], to: stream, options: [], error: &error)
            
            // Handle error
            if let error = error {
                print(error)
            }
        }
 //       _ = saveToJsonFile()
        
        OperationQueue.main.addOperation {

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.updatedGridVariations?.variationsData ?? ["initial row": ["alive": [[0, 0]]]], options: [])
                let theJSONText = String(data: jsonData,
                                     encoding: .ascii)
                print("JSON string = \(theJSONText!)")
            }
            catch   {
                print(error.localizedDescription)
            }
        }
//        print("updatedGridVariations?.variationsData[newName] \(updatedGridVariations?.variationsData.updateValue(["alive" : myArr], forKey: newName))")
//        
//        if let updatedGridVariations = updatedGridVariations {
//        print(Array(updatedGridVariations.variationsData.keys))
//        }
 
//         let alivePositions = self.engine.grid.returnPositions()
//        print("alivePositions \(alivePositions)")
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
