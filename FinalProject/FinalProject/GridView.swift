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
    
    
    @IBInspectable var size: Int = 5
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
    var numberEmpty:Int = 0
    


func establishSize (_ modification: [[Int]]) -> Int {
    var calculatedSize: Int {
        var maxNumber: Int = 0
        var numArr: [Int] = [0]
            (0 ..< modification.count).forEach { i in
            maxNumber = modification[i].reduce(0){$0 > $1 ? $0 : $1}
                        numArr.append(maxNumber)
        
                        }
        maxNumber = numArr.max()!
        return (maxNumber + 1) * 2

    }
    return calculatedSize
}
    func setGridDataSource (_ modification: [[Int]]){
        engine.grid = Grid(GridSize(rows: size, cols: size))
        (0 ..< modification.count).forEach { i in
            let varRow = modification[i][0]
            let varCol = modification[i][1]
            gridDataSource?[varRow, varCol] = .alive
        }
        numberEmpty = countCells(state: .empty)
        //to check that the grid is drawing correctly
//                (0 ..< size+1).forEach { i in
//        
//                    (0 ..< size+1).forEach { j in
//                        print("gridDataSource of [\(i), \(j)] is \(gridDataSource?[i,j])")
//                        }
//        }
        
        
    }

//
//
////to check that the grid is drawing correctly
////        (0 ..< size+1).forEach { i in
////
////                (0 ..< size+1).forEach { j in
////                print("gridDataSource of [\(i), \(j)] is \(gridDataSource?[i,j])")
////                }
////        }
//
//            
//

//
    func choosenVariation(_ selectedVariation: String?){

            if let receivedVariation = gridVariations.variationsData[selectedVariation!]?.values {
                let newVariation = receivedVariation.map{$0}.reversed()[0]
                size = establishSize(newVariation)
                _ = setGridDataSource(newVariation)
            }
    }
    
    func countCells(state: CellState)->Int{
        var cellNum: Int {
            return engine.reduce2(size, size) { total, row, col in
                return engine.grid[row,col] == state ? total+1: total
            }
        }
        print ("The number of cells (state - \(state) ) is \(cellNum)")
        return cellNum
    }
    
//
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     */

    
    override func draw(_ rect: CGRect) {
        
        //check that the data source is not empty
        if numberEmpty == 0 {
            numberEmpty = countCells(state: .empty)
            emptyDataSource = "empty grid"
        }
        
        //loading data from the selected Variations of grid
        if numberEmpty ==  size*size {
            if emptyDataSource != "" {
                if let selectedVariation = selectedVariation {
                    _ = choosenVariation(selectedVariation)
                    print("Selected variation \(selectedVariation)")
                    print("SIZE in the draw functuion is : \(size)")
                    
                }
            }
        }
        
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
//            gridDataSource = newGridToUpdate
//            newGridToUpdate?[pos.row, pos.col] = toggledCell!
//            print("state of the grid \(self.gridDataSource?[pos.row, pos.col])")
            setNeedsDisplay()
        }
//print("position \(pos)")
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

    
}
