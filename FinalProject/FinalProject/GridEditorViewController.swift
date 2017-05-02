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
        print("save button works")
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
