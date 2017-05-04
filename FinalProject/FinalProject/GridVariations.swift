//
//  GridVariations.swift
//  Assignment4
//
//  Created by Jelena Dowey on 4/29/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

class GridVariation {
    
    static var gridVariationSingleton: GridVariation = GridVariation(data: ["initial row": ["alive": [[0, 0]]]])
    var variationsData: [String : [String : [[Int]]]] {
        didSet {
            variationsUpdateClosure?(self.variationsData)
        }
    }
    var selectedVariation: String?
    var variationsUpdateClosure: (([String : [String : [[Int]]]]) -> Void)?
    
    init (data: [String : [String : [[Int]]]]) {
        self.variationsData = data

    }
}
