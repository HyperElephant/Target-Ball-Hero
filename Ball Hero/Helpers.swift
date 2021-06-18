//
//  Helpers.swift
//  Ball Hero
//
//  Created by David Taylor on 3/31/18.
//  Copyright © 2018 Hyper Elephant. All rights reserved.
//

import Foundation
import Photos
import SpriteKit
import GameKit

class Helpers {
    
    static func getBackground(frame: CGRect) -> SKSpriteNode {
        var bg = SKSpriteNode()
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if UserDefaults.standard.object(forKey: "backgroundID") != nil && authorizationStatus == .authorized{
            var images: PHFetchResult<PHAsset>!
            let imageManager = PHImageManager()
            var backgroundID : [String] = []
            
            backgroundID.append(UserDefaults.standard.object(forKey: "backgroundID")! as! String)
            images = PHAsset.fetchAssets(withLocalIdentifiers: backgroundID, options: nil)
            let options: PHImageRequestOptions = PHImageRequestOptions()
            options.isSynchronous = true
            var imageAsset: PHAsset? {
                didSet {
                    imageManager.requestImage(for: imageAsset!, targetSize:CGSize(width: frame.width * 8, height: frame.height * 8), contentMode: .aspectFill, options: options) { image, info in
                        if image != nil {
                            let texture = SKTexture(image: image!)
                            bg = SKSpriteNode(texture: texture, size: frame.size)
                            
                            switch image!.imageOrientation {
                            case UIImage.Orientation.down:
                                bg.yScale = -1
                                bg.xScale = -1
                            case UIImage.Orientation.left:
                                bg.zRotation = CGFloat(Double.pi / 2)
                            case UIImage.Orientation.right:
                                bg.zRotation = CGFloat(-Double.pi / 2)
                            default:
                                break
                            }
                        } else {
                            bg = SKSpriteNode(color: UIColor(red: 0.404, green: 0.945, blue: 0.49, alpha: 1), size: CGSize(width: frame.width, height: frame.height))
                        }
                    }
                }
            }
            imageAsset = images[0]
        } else {
            bg = SKSpriteNode(color: UIColor(red: 0.404, green: 0.945, blue: 0.49, alpha: 1), size: CGSize(width: frame.width, height: frame.height))
        }
        return bg
    }
    
    static func isHighScore(_ score: Double, scoreKey: String) -> Bool {
        var isHigh = Bool()
        if UserDefaults.standard.object(forKey: scoreKey) != nil {
            let oldScore = UserDefaults.standard.object(forKey: scoreKey) as! Double
            if score > oldScore {
                UserDefaults.standard.set(score, forKey: scoreKey)
                isHigh = true
            } else {
                isHigh = false
            }
        } else {
            UserDefaults.standard.set(score, forKey: scoreKey)
            isHigh = true
        }
        UserDefaults.standard.set(score, forKey: "lastScore")
        return isHigh
    }
    
    static func authenticateLocalPlayer(_ view: SKView?) {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                view?.window?.rootViewController?.present(viewController!, animated: true, completion: nil)
            } else {
                //                println(error)
            }
        }
    }
}

enum GeneralError: Error {
    case notImplemented
}
