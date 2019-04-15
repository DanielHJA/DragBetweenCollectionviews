//
//  AnimalObject.swift
//  DragBetweenCollectionView
//
//  Created by Daniel Hjärtström on 2019-04-09.
//  Copyright © 2019 Sog. All rights reserved.
//

import UIKit

struct AnimalObject {

    var text: String
    var index: Int = 0
    
}

extension AnimalObject {
    init(text: String){
        self.text = text
    }
}
