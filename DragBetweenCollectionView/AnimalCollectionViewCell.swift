//
//  AnimalCollectionViewCell.swift
//  DragBetweenCollectionView
//
//  Created by Daniel Hjärtström on 2019-04-09.
//  Copyright © 2019 Sog. All rights reserved.
//

import UIKit

class AnimalCollectionViewCell: BaseCollectionViewCell<AnimalObject> {
    
    private lazy var label: UILabel = {
        let temp = UILabel()
        temp.textColor = UIColor.black
        temp.textAlignment = .center
        temp.minimumScaleFactor = 0.7
        temp.adjustsFontSizeToFitWidth = true
        temp.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return temp
    }()
    
    override func setupWithObject(_ object: AnimalObject) {
        let colorIndex = CGFloat(object.index * 35)
        backgroundColor = UIColor.rgb(red: 124, green: 252 - colorIndex, blue: 0, alpha: 1.0)
        label.text = object.text
    }
    
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
