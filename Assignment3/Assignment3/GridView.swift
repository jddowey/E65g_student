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
    var myGrid = Grid(5, 5)
    @IBInspectable  var livingColor: UIColor = UIColor.red
    @IBInspectable  var emptyColor: UIColor = UIColor.gray
    @IBInspectable  var bornColor: UIColor = UIColor.green
    @IBInspectable  var diedColor: UIColor = UIColor.yellow
    @IBInspectable  var gridColor: UIColor = UIColor.darkGray
    @IBInspectable  var gridWidth: CGFloat = 3.0
    
    
    //end of problem 2

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    
    //problem 4
    override func draw(_ rect: CGRect) {
        // Drawing code
        //base
        let base = rect.origin
        //gridSize
        let gridSize = CGSize(
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )
        //draw grid
        (0 ..< size+1).forEach { i in
            //draw vertical lines
            drawLine(
                start: CGPoint(
                    x: base.x + (CGFloat(i) * gridSize.width),
                    y: base.y
                ),
                end: CGPoint(
                    x: base.x + (CGFloat(i) * gridSize.width),
                    y: base.y + rect.size.height
                )
            )
            //draw horizontal lines
            drawLine(
                start: CGPoint(
                    x: base.x,
                    y: base.y + (CGFloat(i) * gridSize.height)
                ),
                end: CGPoint(
                    x: base.x + rect.size.width,
                    y: base.y + (CGFloat(i) * gridSize.height)
                )
            )
            
        }
        //make circles
        
        (0 ..< size+1).forEach { i in
            
            (0 ..< size+1).forEach { j in
                
                let circle = UIBezierPath(ovalIn: CGRect(
                    origin: CGPoint (
                        x: base.x + (CGFloat(j) * gridSize.width),
                        y: base.y + (CGFloat(i) * gridSize.height)
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
    
    func drawLine(start: CGPoint, end: CGPoint) {
        let linePath = UIBezierPath()
        //set the path's line width to the width of the stroke
        linePath.lineWidth = gridWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        linePath.move(to: start)
        
        //add a point to the path at the end of the stroke
        linePath.addLine(to: end)
        
        //draw the stroke
        gridColor.setStroke()
        linePath.stroke()
    }
    //end of problem 4
    
    // problem 5
    // touch events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        let toggledCell = myGrid[pos].toggle(value: myGrid[pos])
        myGrid[pos] = toggledCell
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(size)
        let position = (row: Int(row), col: Int(col))
        return position
    }
    //end of problem 5
    //problem 6
    //nextStage
    func nextStage(){
        myGrid = myGrid.next()
        setNeedsDisplay()
    }
    //end of problem 6

}
