//
//  ViewController.swift
//  AudioWaveForm
//
//  Created by PIYUSH  GHOGHARI on 04/02/19.
//  Copyright © 2019 AK_Creation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - All IBOutlet's for this UIViewController
    
    @IBOutlet weak var vwAudioPlayerMain: UIView!
    @IBOutlet weak var vwDownload: UIView!
    @IBOutlet weak var vwDownloadProgress: UIView!
    @IBOutlet weak var vwAudioProgress: UIProgressView!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var vwBtnDownload: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        vwDownload.layer.cornerRadius = 10.0
        vwDownload.layer.masksToBounds = true
        vwDownload.layer.borderColor = UIColor.white.cgColor
        vwDownload.layer.borderWidth = 2.0
        
        vwAudioPlayerMain.layer.cornerRadius = 10.0
        vwAudioPlayerMain.layer.masksToBounds = true
        vwAudioPlayerMain.layer.borderColor = UIColor.white.cgColor
        vwAudioPlayerMain.layer.borderWidth = 2.0
        vwBtnDownload.layer.cornerRadius = 20.0
        vwBtnDownload.layer.masksToBounds = true
        vwBtnDownload.layer.borderColor = UIColor.white.cgColor
        vwBtnDownload.layer.borderWidth = 2.0
        vwDownloadProgress.isHidden = true
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        SDDownloadManager.shared.cancelDownload(forUniqueKey: "YOUR_AUDIO_URL")
    }
    
    @IBAction func btnDownloadAudioClick(_ sender: UIButton) {
        self.lblMessage.isHidden = true
        self.vwDownloadProgress.isHidden = false
        let url = URL(string: "YOUR_AUDIO_URL")
        let request = URLRequest.init(url: url!)
        let date :NSDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        let downloadAudioURL = SDDownloadManager.shared.dowloadFile(withRequest: request,
                                                                    inDirectory: "\(dateFormatter.string(from: date as Date))",
            withName: nil,
            onProgress:  { [weak self] (progress) in
                print("Download progress : -> \(Float(progress))")
                self?.vwAudioProgress.setProgress(Float(progress), animated: true)
        }) { [weak self] (error, url) in
            if let error = error {
                print("Error is \(error as NSError)")
            } else {
                if let url = url {
                    self?.vwDownload.isHidden = true
                    let asset : AVURLAsset = AVURLAsset.init(url: url, options: nil)
                    print("Audio Local URL : ->",asset.url)
                    print(self?.vwAudioPlayerMain.frame.size.width as Any)
                    let playerView = SYWaveformPlayerView(frame: CGRect(x: 0, y: 0, width: (self?.vwAudioPlayerMain.frame.size.width)!, height:50), asset: asset, color: UIColor.gray, progressColor: UIColor(red: 132.0/255.0, green: 112.0/255.0, blue: 255.0/255.0, alpha: 1.0))
                    self?.vwAudioPlayerMain.addSubview(playerView!)
                }
            }
        }
        print("Audio URL :- \(downloadAudioURL!)")
    }
}

