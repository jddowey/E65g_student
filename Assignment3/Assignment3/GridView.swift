//
//  GridView.swift
//  Assignment3
//
//  Created by Jelena Dowey on 3/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    
    var newSize: Int = 0
    
    @IBInspectable  var size: Int = 20 {
                        //didSet {
                        //    print("size was \(oldValue)")
                        //}
                        willSet {
                            newSize = newValue
                        }

                    }
    @IBInspectable  var livingColor: UIColor = UIColor.red
    @IBInspectable  var emptyColor: UIColor = UIColor.gray
    @IBInspectable  var bornColor: UIColor = UIColor.green
    @IBInspectable  var diedColor: UIColor = UIColor.white
    @IBInspectable  var gridColor: UIColor = UIColor.darkGray
    @IBInspectable  var gridWidth: CGFloat = 3.0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //var myGrid = Grid(size, size, cellInitializer: gliderInitializer)
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        
        var myGrid = Grid(size, size, cellInitializer: gliderInitializer)
        
        //for debugging
        //print("my Grid variable \(myGrid)")
        //print("my positions \(myGrid[(0,0)])")
        //print("my positions \(myGrid.positions)")
        
        //myGrid[(18,7)] = .died
        //myGrid[(19,7)] = .alive
        //myGrid[(19,19)] = .born
        
        let base = rect.origin
        //gridSize
        let gridSize = CGSize(
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )
        
        
        (0 ..< size+1).forEach { i in
            
            
            //create the path
            let verticalPath = UIBezierPath()
            var start = CGPoint(
                x: base.x + (CGFloat(i) * gridSize.width),
                y: base.y
            )
            var end = CGPoint(
                x: base.x + (CGFloat(i) * gridSize.width),
                y: base.y + rect.size.height
            )
            //set the path's line width to the width of the stroke
            verticalPath.lineWidth = gridWidth
            
            //move the initial point of the path
            //to the start of the horizontal stroke
            verticalPath.move(to: start)
            
            //add a point to the path at the end of the stroke
            verticalPath.addLine(to: end)
            
            //draw the stroke
            gridColor.setStroke()
            verticalPath.stroke()
            //end of vertical lines
            
            let horizontalPath = UIBezierPath()
            
            start = CGPoint(
                x: base.x,
                y: base.y + (CGFloat(i) * gridSize.height)
            )
            end = CGPoint(
                x: base.x + rect.size.width,
                y: base.y + (CGFloat(i) * gridSize.height)
            )
            
            
            //set the path's line width to the width of the stroke
            horizontalPath.lineWidth = gridWidth
            
            //move the initial point of the path
            //to the start of the horizontal stroke
            horizontalPath.move(to: start)
            
            //add a point to the path at the end of the stroke
            horizontalPath.addLine(to: end)
            
            //draw the stroke
            gridColor.setStroke()
            horizontalPath.stroke()
            //end of horizontal lines
            
        }
        
        (0 ..< size+1).forEach { i in
            
            (0 ..< size+1).forEach { j in

                let circle = UIBezierPath(ovalIn: CGRect(
                    origin: CGPoint (
                        x: base.x + (CGFloat(i) * gridSize.width),
                        y: base.y + (CGFloat(j) * gridSize.height)
                    ),
                    size: gridSize
                    )
                )
                var colorToBe = livingColor
                if (myGrid[(i,j)] == .empty) {
                    colorToBe = emptyColor
                } else if (myGrid[(i,j)] == .born) {
                    colorToBe = bornColor
                } else if (myGrid[(i,j)] == .died) {
                    colorToBe = diedColor
                }
                
                colorToBe.setFill()
                circle.fill()
                
            }
        }
        
        
        
    }

    
}
