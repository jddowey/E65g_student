//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit




let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
//var jsonArray: NSArray = []

//var sectionHeaders = [String]()
var sectionHeaders = ["Blinker", "Pentadecthlon", "Glider Gun", "Tumbler"]
var data = [
    [
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date"
    ],
    [
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana"
    ],
    [
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry"
    ],
    [
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry"
    ]
]


class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gridSizeTextField: UITextField!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var refreshRate: UISlider!

    @IBOutlet weak var congifurationsView: UITableView!
    
    
    var timer: Timer?
    var variationTimer: Timer?
 //   var sectionHeaders = [String]()
    private var jsonArray: NSArray = []
    
    
    var jsonDictionary : NSDictionary = [:]
    var gridVariationValue : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.isNavigationBarHidden = true
        
        timer = StandardEngine.engine.refreshTimer
        
        
        if gridSizeTextField.text?.isEmpty == true {
            gridSizeTextField.text = "15"
        }
        _ = readGridUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func stepUpOrDown(_ sender: UIStepper) {
        gridSizeTextField.text = String(Int(sender.value))
        _ =  notifyTheChange()
        
    }
    
    @IBAction func refreshChanged(_ sender: UISwitch) {
//        _ = readFromSimulationView()
        _ = notifyTheChange()
        if refreshSwitch.isOn == true {
        StandardEngine.engine.refreshTimer?.invalidate()
        StandardEngine.engine.refreshTimer = nil
        StandardEngine.engine.refreshRate = TimeInterval(refreshRate.value)
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
        StandardEngine.engine.refreshRate = TimeInterval(sender.value)
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
        _ =  notifyTheChange()

    }
    
    @IBAction func fetchButtonPressed(_ sender: UIButton) {
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            print(json)
            self.jsonArray = json as! NSArray
//            let resultString = (json as AnyObject).description
//
//            for i in 0..<jsonArray.count {
//                let jsonDictionary = jsonArray[i] as! NSDictionary
//                let jsonTitle = jsonDictionary["title"] as! String
//                let jsonContents = jsonDictionary["contents"] as! [[Int]]
////                self.sectionHeaders.append(jsonTitle)
//                print ("jsonTitle", jsonTitle, jsonContents)
////                print ("jsonTitle", jsonTitle, jsonContents, self.sectionHeaders)
//            }
            OperationQueue.main.addOperation {
//                self.textView.text = resultString
            }
        }
        
    }
    
    func jsonAsDictionary() -> NSDictionary {
        
        for i in 0..<jsonArray.count {
            jsonDictionary = jsonArray[i] as! NSDictionary
            let jsonTitle = jsonDictionary["title"] as! String
            let jsonContents = jsonDictionary["contents"] as! [[Int]]
            //                self.sectionHeaders.append(jsonTitle)
            print ("jsonTitle", jsonTitle, jsonContents)
            //                print ("jsonTitle", jsonTitle, jsonContents, self.sectionHeaders)
        }
        return jsonDictionary
    }
    
    func variationValue() -> String {
        
        return gridVariationValue
    
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

    func notifyTheChange() {
        let fiNc = NotificationCenter.default
        let fiName = Notification.Name(rawValue: "FieldsUpdate")
        let fiN = Notification(name: fiName,
                               object: nil,
                               userInfo: ["textField" : gridSizeTextField.text!,
                                          "switch" : refreshSwitch!,
                                          "refreshRate": refreshRate!])
        fiNc.post(fiN)
    }
    
    func readFromSimulationView(){
        
//from StandardEngine
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "EngineUpdate"), object: nil, queue: nil) { notification in
//            self.gridSizeTextField.text = String(standardEngineClass.grid.size.rows)
//            self.gridSizeStepper.value = Double(standardEngineClass.grid.size.rows)

        }

//end from StandardEngine

    }
    
    func readGridUpdate(){

                NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "GridSizeUpdate"), object: nil, queue: nil) { notification in
                                let userInfo = notification.userInfo!
                                print("\(String(describing: userInfo["gridSize"] as? String))")
                                self.gridSizeTextField.text = userInfo["gridSize"] as? String
                                let gridSizeToDouble = userInfo["gridSize"] as? String
                                self.gridSizeStepper.value = Double(gridSizeToDouble!)!
                    }
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
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.congifurationsView.indexPathForSelectedRow
            if let indexPath = indexPath {
           gridVariationValue = sectionHeaders[indexPath.row]

                //notification for the gridVariationValue
                let nc = NotificationCenter.default
                let choosenVariation : (Timer) -> Void = { timer in
                    let userInfo = ["selectedVariation": self.gridVariationValue as String] as [String : Any]
                    let notificationVariation = Notification (name: Notification.Name(rawValue: "GridVariationUpdate"), object: nil, userInfo: userInfo)
                    nc.post(notificationVariation)
                }
                
                variationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: choosenVariation)
                
            if let vc = segue.destination as? GridEditorViewController {
                vc.variationValue = gridVariationValue
//                vc.saveClosure = { newValue in
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

