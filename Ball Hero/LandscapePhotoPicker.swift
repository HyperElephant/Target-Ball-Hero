//
//  LandscapePhotoPicker.swift
//  Ball Hero
//
//  Created by David Taylor on 8/4/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import UIKit
import Photos

class LandscapePhotoPicker: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    var images: PHFetchResult!
    let imageManager = PHCachingImageManager()
    var UIScale = CGFloat(1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            UIScale = 1.5
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        images = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 86 * UIScale, height: 86 * UIScale)
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 32 * UIScale)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.registerClass(PhotoPickerHeaderView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) 
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        cell.addSubview(imageView)
        
        var imageAsset: PHAsset? {
            didSet {
                self.imageManager.requestImageForAsset(imageAsset!, targetSize: CGSize(width: imageView.frame.width, height: imageView.frame.height), contentMode: .AspectFill, options: nil) { image, info in
                    
                    imageView.image = image
                }
            }
        }
        imageAsset = images[indexPath.item] as? PHAsset
        return cell
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.frame = CGRectMake(0, 0, size.width, size.height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        let image = images[indexPath.item].localIdentifier
        NSUserDefaults.standardUserDefaults().setObject(image, forKey: "backgroundID")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var view: UICollectionReusableView
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView =
            collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: "Header",
                forIndexPath: indexPath) as! PhotoPickerHeaderView
            headerView.label.text = "Choose Background"
            headerView.cancelButton.addTarget(self, action: #selector(LandscapePhotoPicker.cancelPicker(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            headerView.defaultButton.addTarget(self, action: #selector(LandscapePhotoPicker.defaultBackground(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            view =  headerView
        default:
            assert(false, "Unexpected element kind")
            view = UICollectionReusableView()
        }
        return view
    }
    
    func cancelPicker(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func defaultBackground(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "backgroundID")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

