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
    
    var images: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    var UIScale = CGFloat(1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if UIDevice.current.userInterfaceIdiom == .pad {
            UIScale = 1.5
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        images = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 86 * UIScale, height: 86 * UIScale)
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 32 * UIScale)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(PhotoPickerHeaderView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) 
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        cell.addSubview(imageView)
        
        var imageAsset: PHAsset? {
            didSet {
                self.imageManager.requestImage(for: imageAsset!, targetSize: CGSize(width: imageView.frame.width, height: imageView.frame.height), contentMode: .aspectFill, options: nil) { image, info in
                    
                    imageView.image = image
                }
            }
        }
        imageAsset = images[(indexPath as NSIndexPath).item]
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let image = images[(indexPath as NSIndexPath).item].localIdentifier
        UserDefaults.standard.set(image, forKey: "backgroundID")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var view: UICollectionReusableView
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView =
            collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                withReuseIdentifier: "Header",
                for: indexPath) as! PhotoPickerHeaderView
            headerView.label.text = "Choose Background"
            headerView.cancelButton.addTarget(self, action: #selector(LandscapePhotoPicker.cancelPicker(_:)), for: UIControl.Event.touchUpInside)
            headerView.defaultButton.addTarget(self, action: #selector(LandscapePhotoPicker.defaultBackground(_:)), for: UIControl.Event.touchUpInside)
            view =  headerView
        default:
            assert(false, "Unexpected element kind")
            view = UICollectionReusableView()
        }
        return view
    }
    
    @objc func cancelPicker(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func defaultBackground(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(nil, forKey: "backgroundID")
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}

