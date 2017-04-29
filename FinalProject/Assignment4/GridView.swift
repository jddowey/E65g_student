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
    
    
    @IBInspectable var size: Int = 5 {
        didSet {
            gridDataSource = Grid(GridSize(rows: size, cols: size))
        }
    }
    @IBInspectable var livingColor: UIColor = UIColor.red
    @IBInspectable var emptyColor: UIColor = UIColor.gray
    @IBInspectable var bornColor: UIColor = UIColor.green
    @IBInspectable var diedColor: UIColor = UIColor.yellow
    @IBInspectable var gridColor: UIColor = UIColor.darkGray
    @IBInspectable var gridWidth: CGFloat = 3.0
    
    var selectedVariation: String = ""
    var gridDataSource: GridViewDataSource?
    
    var newGridToUpdate: GridViewDataSource?



//    let gridVariations: [String: [[Int]]] = [
//        "Blinker": [[11, 11], [12, 11], [11, 12], [12, 12], [13, 12], [11, 13], [12, 13]],
//        "Pentadecthlon": [[11, 10], [11, 15], [12, 8], [12, 9], [12, 11], [12, 12], [12, 13], [12, 14], [12, 16], [12, 17], [13, 10], [13, 15]],
//        "Glider Gun": [[50, 11], [50, 12], [52, 12], [16, 13], [38, 13], [40, 13], [50, 13], [51, 13], [16, 14], [18, 14], [38, 14], [39, 14], [16, 15], [17, 15], [24, 15], [26, 15], [39, 15], [24, 16], [25, 16], [25, 17], [52, 37], [53, 37], [54, 37], [52, 38], [18, 39], [19, 39], [20, 39], [39, 39], [40, 39], [53, 39], [18, 40], [39, 40], [41, 40], [45, 40], [19, 41], [25, 41], [26, 41], [39, 41], [44, 41], [45, 41], [25, 42], [27, 42], [31, 42], [44, 42], [46, 42], [25, 43], [30, 43], [31, 43], [36, 43], [37, 43], [30, 44], [32, 44], [36, 44], [38, 44], [36, 45], [55, 46], [56, 46], [55, 47], [57, 47], [55, 48], [44, 51], [45, 51], [46, 51], [44, 52], [45, 53]],
//        "Tumbler": [[11, 12], [11, 13], [11, 15], [11, 16], [12, 12], [12, 13], [12, 15], [12, 16], [13, 13], [13, 15], [14, 11], [14, 13], [14, 15], [14, 17], [15, 11], [15, 13], [15, 15], [15, 17], [16, 11], [16, 12], [16, 16], [16, 17]]
//    ]
    //        print("gridVariations\(gridVariations["Blinker"])")
    

    func receivedValues(){
        if gridVariations.variationsData != nil {
                print("RECEIVED VARIATIONS \(String(describing: gridVariations.variationsData))")
        }
    }
    
    func getVariationsGrid(_ newVariation: [[Int]]) {

            var maxNumber: Int = 0
            var numArr: [Int] = [0]
            (0 ..< newVariation.count).forEach { i in
                maxNumber = newVariation[i].reduce(0){$0 > $1 ? $0 : $1}
                numArr.append(maxNumber)
                //                print("\(numArr)")
            
            }
            maxNumber = numArr.max()!
            size = maxNumber + 1
            print("size is \(size)")
//        (0 ..< size).forEach { i in
//            (0 ..< size).forEach { j in
                (0 ..< newVariation.count).forEach { i in
                   let varRow = newVariation[i][0]
                   let varCol = newVariation[i][1]
                   gridDataSource?[varRow, varCol] = .alive
                }
        
           newGridToUpdate = gridDataSource
        
//           }
//        }
//to check that the grid is drawing correctly
//        (0 ..< size+1).forEach { i in
//
//                (0 ..< size+1).forEach { j in
//                print("gridDataSource of [\(i), \(j)] is \(gridDataSource?[i,j])")
//                }
//        }

            

    }

    func choosenVariation(_ selectedVariation: String?){
        
//        _ = receivedValues()
        
        if gridVariations != nil {
        
            if let newVariation = gridVariations.variationsData[selectedVariation!] {
                _ = getVariationsGrid(newVariation)
            }
        
        }

    }
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     */
    
    
    override func draw(_ rect: CGRect) {
        print("\(self.selectedVariation)")
        
        if self.selectedVariation != "" {
            _ = choosenVariation(self.selectedVariation)
            self.selectedVariation = ""
        } else if self.selectedVariation == "" {
            
            //observer for the selectedVariationGrid
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "GridVariationUpdate"), object: nil, queue: nil) { notification in
                let userInfo = notification.userInfo!
                self.selectedVariation = (userInfo["selectedVariation"] as? String)!
                print ("INSIDE the observer \(String(describing: self.selectedVariation))")
            }
            //end observer
            print("CHANGED")
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
            print("toggled cell \(toggledCell)")
            gridDataSource?[pos.row, pos.col] = toggledCell!
            gridDataSource = gridDataSource.map {$0}
//            gridDataSource = newGridToUpdate
//            newGridToUpdate?[pos.row, pos.col] = toggledCell!
            print("state of the grid \(self.gridDataSource?[pos.row, pos.col])")
            if self.gridDataSource?[pos.row, pos.col] == gridDataSource?[pos.row, pos.col]
            {
                print("yes, it's the same")
            }
            setNeedsDisplay()
        }
print("position \(pos)")
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
