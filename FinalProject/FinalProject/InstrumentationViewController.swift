//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

var selectedVariation: String?


class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gridSizeTextField: UITextField!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var refreshRate: UISlider!

    @IBOutlet weak var congifurationsView: UITableView!
    
    var engine: EngineProtocol!
    var timer: Timer?
    var variationTimer: Timer?

    
    var gridVariations: GridVariation!
    var sectionHeaders: [String] = []
    var gridVariationValue : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        //access to StandardEngine singleton
        engine = StandardEngine.engine
        gridSizeTextField.text = String(engine.grid.size.rows)
        gridSizeStepper.value = Double(engine.grid.size.rows)
        
        //access to the GridVariations (json and user saved data) singleton
        gridVariations = GridVariation.gridVariationSingleton
        if (sectionHeaders.count == 0) {
            gridVariations.titlesUpdateClosure = { (gridTitles) in
                self.sectionHeaders = gridTitles
                self.congifurationsView.reloadData()
            }
        }
        
        
        timer = StandardEngine.engine.refreshTimer
        
    }
    //end of viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func stepUpOrDown(_ sender: UIStepper) {
        gridSizeTextField.text = String(Int(sender.value))
        gridSizeStepper.value = Double(sender.value)
        engine.grid = Grid(GridSize(rows: Int(sender.value), cols: Int(sender.value)))
    }
    @IBAction func editingDidEndOnExit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let val = Int(text) else {
            showErrorAlert(withMessage: "Invalid value: \(text), please try again.") {
                sender.text = self.gridSizeTextField.text
            }
            return
        }
        gridSizeTextField.text = String(val)
        gridSizeStepper.value = Double(val)
        engine.grid = Grid(GridSize(rows: Int(val), cols: Int(val)))
        
    }
    
    @IBAction func refreshChanged(_ sender: UISwitch) {
//        _ = readFromSimulationView()
//        _ = notifyTheChange()
        if refreshSwitch.isOn == true {
        engine.refreshTimer?.invalidate()
        engine.refreshTimer = nil
        engine.refreshRate = TimeInterval(refreshRate.value)
            print ("switch is on")
        } else {
            StandardEngine.engine.refreshRate = TimeInterval(0.0)
//            StandardEngine.engine.refreshTimer?.invalidate()
//            StandardEngine.engine.refreshTimer = nil
            print ("switch is off")
        }
    }
    
    @IBAction func refreshRateChanged(_ sender: UISlider) {
//        StandardEngine.engine.refreshTimer?.invalidate()
//        StandardEngine.engine.refreshTimer = nil
          engine.refreshRate = TimeInterval(sender.value)
    }
    
    


    
    //MARK: AlertController Handling
    func showErrorAlert(withMessage msg:String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }


    

    

    
     // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = sectionHeaders[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
            gridVariationValue = sectionHeaders[indexPath.row]
            selectedVariation = sectionHeaders[indexPath.row]
        
                        //notification for the gridVariationValue
                        let nc = NotificationCenter.default
                        let choosenVariation : (Timer) -> Void = { timer in
                            let userInfo = ["selectedVariation": self.gridVariationValue as String] as [String : Any]
                            let notificationVariation = Notification (name: Notification.Name(rawValue: "GridVariationUpdate"), object: nil, userInfo: userInfo)
                            nc.post(notificationVariation)
                        }
        
                        variationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: choosenVariation)

//        self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.congifurationsView.indexPathForSelectedRow
            if let indexPath = indexPath {
           gridVariationValue = sectionHeaders[indexPath.row]

//
//                //notification for the gridVariationValue
//                let nc = NotificationCenter.default
//                let choosenVariation : (Timer) -> Void = { timer in
//                    let userInfo = ["selectedVariation": self.gridVariationValue as String] as [String : Any]
//                    let notificationVariation = Notification (name: Notification.Name(rawValue: "GridVariationUpdate"), object: nil, userInfo: userInfo)
//                    nc.post(notificationVariation)
//                }
//
//                variationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: choosenVariation)
                
            if let vc = segue.destination as? GridEditorViewController {
                vc.variationValue = gridVariationValue
   
                print (gridVariationValue)
                print(vc.gridEditorView)
//                if vc.gridEditorView != nil {

//                vc.gridEditorView.selectedVariation = gridVariationValue
//                    print(vc.gridEditorView.selectedVariation)
//                }
//                vc.gridEditorView.selectedVariation = sectionHeaders[indexPath.row]
//               vc.saveClosure = { newValue in
//                    sectionHeaders[indexPath.row] = newValue
//                    self.tableView.reloadData()
//                }
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

