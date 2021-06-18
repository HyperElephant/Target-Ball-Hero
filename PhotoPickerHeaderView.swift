//
//  PhotoPickerHeaderView.swift
//  Ball Hero
//
//  Created by David Taylor on 8/5/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import UIKit

class PhotoPickerHeaderView: UICollectionReusableView {
    
    var label = UILabel()
    var cancelButton = UIButton()
    var defaultButton = UIButton()
    var UIScale = CGFloat(1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            UIScale = 1.5
        }
        label.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 26 * UIScale)
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        
        cancelButton.frame = CGRect(x: self.bounds.width - 100, y: 0, width: 100, height: 30 * UIScale)
        cancelButton.setTitle("Cancel", for: UIControl.State())
        cancelButton.setTitleColor(UIColor.black, for: UIControl.State())
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.addSubview(cancelButton)
        
        defaultButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30 * UIScale)
        defaultButton.setTitle("Default", for: UIControl.State())
        defaultButton.setTitleColor(UIColor.black, for: UIControl.State())
        defaultButton.backgroundColor = UIColor.clear
        defaultButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.addSubview(defaultButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

