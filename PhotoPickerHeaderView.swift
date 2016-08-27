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
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            UIScale = 1.5
        }
        label.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 26 * UIScale)
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        
        cancelButton.frame = CGRectMake(self.bounds.width - 100, 0, 100, 30 * UIScale)
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.addSubview(cancelButton)
        
        defaultButton.frame = CGRectMake(0, 0, 100, 30 * UIScale)
        defaultButton.setTitle("Default", forState: UIControlState.Normal)
        defaultButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        defaultButton.backgroundColor = UIColor.clearColor()
        defaultButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.addSubview(defaultButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

