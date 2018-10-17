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

    @IBAction func instaShareAct(_ sender: Any) {
        let url:URL = "https://images.pexels.com/photos/236047/pexels-photo-236047.jpeg?auto=compress&cs=tinysrgb&h=640"
        do {
            let contents = try Data(contentsOf: url)
            guard let scaledImage = UIImage(
                data: contents, scale: 640) else { fatalError("Data has corrupted") }
            UIImageWriteToSavedPhotosAlbum(scaledImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } catch let error {
            debugPrint("Download media error: \(error)")
        }
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let err = error {
            debugPrint("Image save error: \(err)")
        } else {
            sharePostOnInstagram()
        }
    }

    @objc private  func sharePostOnInstagram() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard let asset = result.firstObject else {fatalError("Does not find Image Asset")}
        let urlString = "instagram://library?LocalIdentifier=\(asset.localIdentifier)"
        let scheme:URL = "instagram://app"
        let instagramURL = URL(string: urlString)
        let application = UIApplication.shared

        let url = instagramURL
        if application.canOpenURL(scheme) {
            if #available(iOS 10.0, *) {
                application.open(url!, options: [:]) { (success) in
                    debugPrint("Open \(urlString): \(success)")
                }
            } else {
                let success = application.openURL(url!)
                debugPrint("Open \(urlString): \(success)")
            }
        }
    }
}




