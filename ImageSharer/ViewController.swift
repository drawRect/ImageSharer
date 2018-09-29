//
//  ViewController.swift
//  ImageSharer
//
//  Created by Boominadha Prakash on 29/09/18.
//  Copyright © 2018 Drawrect. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func instaShareAct(_ sender: Any) {
        self.downloadMedia(urlString: "https://images.pexels.com/photos/236047/pexels-photo-236047.jpeg?auto=compress&cs=tinysrgb&h=640")
    }
    
    func downloadMedia(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        do {
            let urlData = try Data(contentsOf: url)
            guard UIImage(data: urlData, scale: 640) != nil else { fatalError("Image Data error") }
            UIImageWriteToSavedPhotosAlbum(UIImage(data: urlData, scale: 640)!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } catch let error {
            debugPrint("Download media error: \(error)")
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let err = error {
            debugPrint("Image save error: \(err)")
        } else {
            sharePostOnInstagram()
        }
    }
    @objc func sharePostOnInstagram() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let assetToShare = result.count > 0 ?  result[0] : nil
        
        if let asset = assetToShare {
            let localIdentifier = asset.localIdentifier
            let urlString = "instagram://library?LocalIdentifier=\(localIdentifier)"
            let instagramScheme = URL(string: "instagram://app")
            let instagramURL = URL(string: urlString)
            let application = UIApplication.shared
            
            if let scheme = instagramScheme,
                let url = instagramURL,
                application.canOpenURL(scheme) {
                if #available(iOS 10.0, *) {
                    application.open(url, options: [:]) { (success) in
                        debugPrint("Open \(urlString): \(success)")
                    }
                } else {
                    let success = application.openURL(url)
                    debugPrint("Open \(urlString): \(success)")
                }
            } else {
                debugPrint("Instagram not installed on this iPhone")
            }
        }
    }
}

