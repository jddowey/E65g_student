//
//  GridView.swift
//  Assignment4
//
//  Created by Jelena Dowey on 4/20/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//
//import Foundation
import UIKit

public protocol GridViewDataSource {
    subscript (row: Int, col: Int) -> CellState { get set }
}

@IBDesignable class GridView: UIView {
    
    //problem 2
    
//    @IBInspectable  var size: Int = 20 {
//        didSet {
//           myGrid = Grid(GridSize(rows: size,cols: size))
//
//        }
//    }
//    var myGrid = Grid(GridSize(rows: 5,cols: 5))
    
    @IBInspectable var size: Int = 5
    @IBInspectable var livingColor: UIColor = UIColor.red
    @IBInspectable var emptyColor: UIColor = UIColor.gray
    @IBInspectable var bornColor: UIColor = UIColor.green
    @IBInspectable var diedColor: UIColor = UIColor.yellow
    @IBInspectable var gridColor: UIColor = UIColor.darkGray
    @IBInspectable var gridWidth: CGFloat = 3.0
    
    var gridDataSource: GridViewDataSource?
    
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
                if (gridDataSource?[(i,j)] == .empty) {
                    colorToBe = emptyColor
                } else if (gridDataSource?[(i,j)] == .born) {
                    colorToBe = bornColor
                } else if (gridDataSource?[(i,j)] == .died) {
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
    
    var lastTouchedPosition: GridPosition?
    
    func process(touches: Set<UITouch>) -> GridPosition? {
        let touchY = touches.first!.location(in: self.superview).y
        let touchX = touches.first!.location(in: self.superview).x
        guard touchX > frame.origin.x && touchX < (frame.origin.x + frame.size.width) else { return nil }
        guard touchY > frame.origin.y && touchY < (frame.origin.y + frame.size.height) else { return nil }
        
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
//        let toggledCell = myGrid[pos].toggle(value: myGrid[pos])

//        let toggledCell = myGrid[pos.row, pos.col].toggle(value: myGrid[pos.row, pos.col])
//        myGrid[pos.row, pos.col] = toggledCell

//
//        let toggledCell = gridDataSource[pos.row, pos.col].toggle(value: gridDataSourcee[pos.row, pos.col])
//        gridDataSource[pos.row, pos.col] = toggledCell
        if gridDataSource != nil {
            
            let toggledCell = gridDataSource?[pos.row, pos.col].toggle(value: (gridDataSource?[pos.row, pos.col])!)
            gridDataSource?[pos.row, pos.col] = toggledCell!
            
            setNeedsDisplay()
        }
        
//        if gridDataSource != nil {
//            gridDataSource![pos.row, pos.col] = gridDataSource![pos.row, pos.col].isAlive ? .empty : .alive
//          setNeedsDisplay()
//       }
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(size)
        let position = GridPosition(row: Int(row), col: Int(col))
        return position
    }
    //end of problem 5
    
    
}

//@IBDesignable class GridView: UIView {
//    
//    @IBInspectable var fillColor = UIColor.darkGray
//    @IBInspectable var gridSize: Int = 3
//    // Updated since class
//    var gridDataSource: GridViewDataSource?
//    
//    var xColor = UIColor.black
//    var xProportion = CGFloat(1.0)
//    var widthProportion = CGFloat(0.05)
//    
//    override func draw(_ rect: CGRect) {
//        drawOvals(rect)
//        drawLines(rect)
//    }
//    
//    func drawOvals(_ rect: CGRect) {
//        let size = CGSize(
//            width: rect.size.width / CGFloat(gridSize),
//            height: rect.size.height / CGFloat(gridSize)
//        )
//        let base = rect.origin
//        (0 ..< gridSize).forEach { i in
//            (0 ..< gridSize).forEach { j in
//                // Inset the oval 2 points from the left and top edges
//                let ovalOrigin = CGPoint(
//                    x: base.x + (CGFloat(j) * size.width) + 2.0,
//                    y: base.y + (CGFloat(i) * size.height + 2.0)
//                )
//                // Make the oval draw 2 points short of the right and bottom edges
//                let ovalSize = CGSize(
//                    width: size.width - 4.0,
//                    height: size.height - 4.0
//                )
//                let ovalRect = CGRect( origin: ovalOrigin, size: ovalSize )
//                if let grid = gridDataSource, grid[i,j].isAlive {
//                    drawOval(ovalRect)
//                }
//            }
//        }
//    }
//    
//    func drawOval(_ ovalRect: CGRect) {
//        let path = UIBezierPath(ovalIn: ovalRect)
//        fillColor.setFill()
//        path.fill()
//    }
//    
//    func drawLines(_ rect: CGRect) {
//        //create the path
//        (0 ..< (gridSize + 1)).forEach {
//            drawLine(
//                start: CGPoint(x: CGFloat($0)/CGFloat(gridSize) * rect.size.width, y: 0.0),
//                end:   CGPoint(x: CGFloat($0)/CGFloat(gridSize) * rect.size.width, y: rect.size.height)
//            )
//            
//            drawLine(
//                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(gridSize) * rect.size.height ),
//                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(gridSize) * rect.size.height)
//            )
//        }
//    }
//    
//    func drawLine(start:CGPoint, end: CGPoint) {
//        let path = UIBezierPath()
//        
//        //set the path's line width to the height of the stroke
//        path.lineWidth = 2.0
//        
//        //move the initial point of the path
//        //to the start of the horizontal stroke
//        path.move(to: start)
//        
//        //add a point to the path at the end of the stroke
//        path.addLine(to: end)
//        
//        //draw the stroke
//        UIColor.cyan.setStroke()
//        path.stroke()
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        lastTouchedPosition = process(touches: touches)
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        lastTouchedPosition = process(touches: touches)
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        lastTouchedPosition = nil
//    }
//    
//    // Updated since class
//    var lastTouchedPosition: GridPosition?
//    
//    func process(touches: Set<UITouch>) -> GridPosition? {
//        let touchY = touches.first!.location(in: self.superview).y
//        let touchX = touches.first!.location(in: self.superview).x
//        guard touchX > frame.origin.x && touchX < (frame.origin.x + frame.size.width) else { return nil }
//        guard touchY > frame.origin.y && touchY < (frame.origin.y + frame.size.height) else { return nil }
//        
//        guard touches.count == 1 else { return nil }
//        let pos = convert(touch: touches.first!)
//        
//        //************* IMPORTANT ****************
//        guard lastTouchedPosition?.row != pos.row
//            || lastTouchedPosition?.col != pos.col
//            else { return pos }
//        //****************************************
//        
//        if gridDataSource != nil {
//            gridDataSource![pos.row, pos.col] = gridDataSource![pos.row, pos.col].isAlive ? .empty : .alive
//            setNeedsDisplay()
//        }
//        return pos
//    }
//    
//    func convert(touch: UITouch) -> GridPosition {
//        let touchY = touch.location(in: self).y
//        let gridHeight = frame.size.height
//        let row = touchY / gridHeight * CGFloat(gridSize)
//        
//        let touchX = touch.location(in: self).x
//        let gridWidth = frame.size.width
//        let col = touchX / gridWidth * CGFloat(gridSize)
//        
//        return GridPosition(row: Int(row), col: Int(col))
//    }
//}
//
//
