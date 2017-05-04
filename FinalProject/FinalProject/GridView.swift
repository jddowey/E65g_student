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

@IBDesignable class GridView: UIView{
    
    
//    @IBInspectable var size: Int = 5 {
//        didSet{
//            engine.grid = Grid(GridSize(rows: size, cols: size))
//        }
//    }
    @IBInspectable var rows: Int = 5
    @IBInspectable var cols: Int = 5
    @IBInspectable var livingColor: UIColor = UIColor.red
    @IBInspectable var emptyColor: UIColor = UIColor.gray
    @IBInspectable var bornColor: UIColor = UIColor.green
    @IBInspectable var diedColor: UIColor = UIColor.yellow
    @IBInspectable var gridColor: UIColor = UIColor.darkGray
    @IBInspectable var gridWidth: CGFloat = 3.0
    
//    var selectedVariation: String?
    var gridDataSource: GridViewDataSource?
    var gridVariations = GridVariation.gridVariationSingleton
    var engine = StandardEngine.engine
    var emptyDataSource:String = ""
    


func establishSize (_ modification: [[Int]]) -> Int {
    var calculatedSize: Int {
        let maxNumber = modification.flatMap{$0}.reduce(0){$0 > $1 ? $0 : $1}
        return (maxNumber + 1) * 2
    }
    return calculatedSize
}
    func setGridDataSource (_ modification: [[Int]]){
        engine.grid = Grid(GridSize(rows: rows, cols: cols))
        (0 ..< modification.count).forEach { i in
            let varRow = modification[i][0]
            let varCol = modification[i][1]
            gridDataSource?[varRow, varCol] = .alive
        }
 //       numberEmpty = engine.grid.returnPositions(state: .empty).count
        //to check that the grid is drawing correctly
//                (0 ..< size+1).forEach { i in
//        
//                    (0 ..< size+1).forEach { j in
//                        print("gridDataSource of [\(i), \(j)] is \(gridDataSource?[i,j])")
//                        }
//        }
        
        
    }

    func choosenVariation(_ selectedVariation: String?){

            if let receivedVariation = gridVariations.variationsData[selectedVariation!]?.values {
                print("\(receivedVariation)")
                let newVariation = receivedVariation.map{$0}.reversed()[0]
                rows = establishSize(newVariation)
                cols = establishSize(newVariation)
                _ = setGridDataSource(newVariation)
            }
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     */

    
    override func draw(_ rect: CGRect) {
        
        //check that the data source is not empty
        let numberEmpty = engine.grid.returnPositions(state: .empty).count
        rows = self.engine.grid.size.rows
        cols = self.engine.grid.size.cols

        
        if numberEmpty == rows * cols {
            emptyDataSource = "empty grid"
        }
        if let selectedVariation = gridVariations.selectedVariation {
                    _ = choosenVariation(gridVariations.selectedVariation)
                    gridVariations.selectedVariation = nil
            
        }

//        
        // Drawing code
        //base
        let base = rect.origin
        //gridSize
        let gridSize = CGSize(
            width: rect.size.width / CGFloat(cols),
            height: rect.size.height / CGFloat(rows)
        )
        //draw grid
        (0 ..< cols+1).forEach { i in
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
        
        (0 ..< cols+1).forEach { i in
            
            (0 ..< rows+1).forEach { j in
                
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
        
        //notify that grid has been updated
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["grid" : self])
        nc.post(n)
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
        
        if gridDataSource != nil {
            
            let toggledCell = gridDataSource?[pos.row, pos.col].toggle(value: (gridDataSource?[pos.row, pos.col])!)
//            print("toggled cell \(toggledCell)")
            gridDataSource?[pos.row, pos.col] = toggledCell!
            gridDataSource = gridDataSource.map {$0}
//            print("state of the grid \(self.gridDataSource?[pos.row, pos.col])")
            setNeedsDisplay()
        }
//print("position \(pos)")
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(rows)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(cols)
        let position = GridPosition(row: Int(row), col: Int(col))
        return position
    }

    
}
