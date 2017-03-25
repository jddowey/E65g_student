//
//  GridView.swift
//  Assignment3
//
//  Created by Jelena Dowey on 3/25/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    
    //problem 2
    
    @IBInspectable  var size: Int = 20 {
        didSet {
            myGrid = Grid(size, size)
        }
    }
    @IBInspectable  var livingColor: UIColor = UIColor.red
    @IBInspectable  var emptyColor: UIColor = UIColor.gray
    @IBInspectable  var bornColor: UIColor = UIColor.green
    @IBInspectable  var diedColor: UIColor = UIColor.yellow
    @IBInspectable  var gridColor: UIColor = UIColor.darkGray
    @IBInspectable  var gridWidth: CGFloat = 3.0
    
    
    var myGrid = Grid(5, 5)
    
    //end of problem 2

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
