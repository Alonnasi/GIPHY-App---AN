//
//  PreviewViewController.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import UIKit
import SwiftyGif
import Photos

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var gifNameLbl: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    
    var gifData: GifData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func setView() {
        view.overrideUserInterfaceStyle = .light
        statusLbl.alpha = 0
        if let gifData = gifData {
            DispatchQueue.main.async {
                self.gifImageView.setGifFromURL(URL(string: gifData.images.fixed_width.url)!)
                self.gifNameLbl.text = gifData.title
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if let gifData = gifData {
            let gifUrl = URL(string: gifData.images.fixed_width.url)!
            
            if let gifUrlNSData = NSData(contentsOf: gifUrl){
                let gifUrlData = Data(gifUrlNSData)
                PHPhotoLibrary.shared().performChanges {
                    let request = PHAssetCreationRequest.forAsset()
                    request.addResource(with: .photo, data: gifUrlData, options: nil)
                } completionHandler: { success, error in
                    
                    if error != nil {
                        print("Error saving Gif")
                        DispatchQueue.main.async { self.presentStatusLbl(message: "Error saving Gif") }
                    }
                    if success != true {
                        print("Couldn't save Gif")
                        DispatchQueue.main.async { self.presentStatusLbl(message: "Couldn't save Gif") }
                    } else {
                        print("Gif Saved")
                        DispatchQueue.main.async { self.presentStatusLbl(message: "Saved to Camera Roll") }
                    }
                }
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        if let gifData = gifData {
            let shareURL: NSURL = NSURL(string: gifData.images.fixed_width.url)!
            let shareData: NSData = NSData(contentsOf: shareURL as URL)!
            let gifData: [Any] = [shareData as Any]
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: gifData, applicationActivities: nil)
            DispatchQueue.main.async {
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func presentStatusLbl(message: String) {
        statusLbl.text = message
        UIView.fadeInOut(view: statusLbl, fadeInDelay: 0, fadeInTime: 0.5, alphaValue: 2.0, fadeOutDelay: 2.0, fadeOutTime: 0.5)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
