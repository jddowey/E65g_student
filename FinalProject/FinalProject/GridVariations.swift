//
//  GridVariations.swift
//  Assignment4
//
//  Created by Jelena Dowey on 4/29/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

class GridVariation {
    
    static var gridVariationSingleton: GridVariation = GridVariation(data: ["initial row": ["alive": [[0, 0]]]], titles: ["initial row"])
    var variationsData: [String : [String : [[Int]]]]
    var titles: [String] {
        didSet {
            titlesUpdateClosure?(self.titles)
            }
    }
    var titlesUpdateClosure: (([String]) -> Void)?
    
    init (data: [String : [String : [[Int]]]], titles: [String]){
        self.variationsData = data
        self.titles = titles
    }
}
