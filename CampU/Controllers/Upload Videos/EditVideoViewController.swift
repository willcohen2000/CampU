//
//  EditVideoViewController.swift
//  CampU
//
//  Created by Will Cohen on 7/26/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit
import ABVideoRangeSlider
import AVFoundation
import Firebase
import Photos

class EditVideoViewController: UIViewController {

    @IBOutlet weak var videoPreviewView: UIView!
    @IBOutlet weak var trimView: ABVideoRangeSlider!
    @IBOutlet weak var postVideoButton: UIButton!
    @IBOutlet weak var saveVideoButton: UIButton!
    
    var randomID: String!
    var videoURL: URL!
    let VIDEO_MAX_DURATION: Float = 10.0;
    
    var player : AVPlayer!
    var item: AVPlayerItem!
    var avPlayerLayer : AVPlayerLayer!
    
    var endTime = 0.0;
    var startTime = 0.0;
    var timeObserver: AnyObject!
    var shouldUpdateProgressIndicator = true;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        randomID = randomString(length: 16);
        setupVideoView();
        setupTrimView();
        configureViews();
    }
    
    private func setupVideoView() {
        
        trimView.setVideoURL(videoURL: videoURL)
        trimView.delegate = self
        trimView.minSpace = 1.0
        trimView.maxSpace = 8.0
        trimView.setStartPosition(seconds: 0.0)
        self.startTime = 0.0;
        
        item = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: item)
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = videoPreviewView.layer.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.item.forwardPlaybackEndTime = CMTimeMake(value: (Int64(endTime * 10000)), timescale: 10000)
        let videoDuration = player.currentItem!.asset.duration.seconds
        
        if (Float(videoDuration) > VIDEO_MAX_DURATION) {
            self.endTime = 8.0;
            trimView.setEndPosition(seconds: 8.0)
        } else {
            self.endTime = videoDuration;
            trimView.setEndPosition(seconds: Float(videoDuration))
        }
        
        videoPreviewView.layer.addSublayer(avPlayerLayer)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTimeMake(value: (Int64((self?.startTime)! * 10000)), timescale: 10000))
            self?.player.play()
        }
        
        //self.endTime = CMTimeGetSeconds((player.currentItem?.duration)!)
        let timeInterval: CMTime = CMTimeMakeWithSeconds(0.01, preferredTimescale: 100)
        timeObserver = player.addPeriodicTimeObserver(forInterval: timeInterval,
                                                      queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
                                                        self.observeTime(elapsedTime: elapsedTime) } as AnyObject!
        
    }
    
    private func loadSuccessAlert() {
        let alert = UIAlertController(title: "Uploaded Video", message:
            "We have successfully posted your video.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configureViews() {
        postVideoButton.layer.cornerRadius = (postVideoButton.frame.height / 2);
        saveVideoButton.layer.cornerRadius = (saveVideoButton.frame.height / 2);
        saveVideoButton.layer.borderColor = Colors.centralBlack.cgColor;
        saveVideoButton.layer.borderWidth = 1.0;
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let elapsedTime = CMTimeGetSeconds(elapsedTime)
        if (player.currentTime().seconds > self.endTime) {
            player.seek(to: CMTime(seconds: (startTime * 10000), preferredTimescale: 10000))
        }
        
        if self.shouldUpdateProgressIndicator {
            trimView.updateProgressIndicator(seconds: elapsedTime)
        }
    }
    
    private func setupTrimView() {
        let customStartIndicator =  UIImage(named: "CustomStartIndicator")
        trimView.setStartIndicatorImage(image: customStartIndicator!)
        let customStopIndicator =  UIImage(named: "CustomStopIndicator")
        trimView.setEndIndicatorImage(image: customStopIndicator!)
        let customProgressIndicator =  UIImage(named: "CustomProgressIndicator")
        trimView.setProgressIndicatorImage(image: customProgressIndicator!)
        let customBorder =  UIImage(named: "CustomBorder")
        trimView.setBorderImage(image: customBorder!)
        trimView.startTimeView.backgroundColor = UIColor.white;
        trimView.endTimeView.backgroundColor = UIColor.white;
        trimView.startTimeView.timeLabel.backgroundColor = UIColor.white
        trimView.startTimeView.backgroundView.backgroundColor = UIColor.white
        trimView.endTimeView.timeLabel.backgroundColor = UIColor.white
        trimView.endTimeView.backgroundView.backgroundColor = UIColor.white
    }
    
    func cropVideo(sourceURL: URL, startTime: Double, endTime: Double, completion: ((_ outputUrl: URL) -> Void)? = nil) {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let asset = AVAsset(url: sourceURL)
        _ = Float(asset.duration.value) / Float(asset.duration.timescale)
        
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(sourceURL.lastPathComponent)")
        }catch let error {
            print(error)
        }
        
        //Remove existing file
        try? fileManager.removeItem(at: outputURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        
        let timeRange = CMTimeRange(start: CMTime(seconds: (startTime), preferredTimescale: 1000),
                                    end: CMTime(seconds: (endTime), preferredTimescale: 1000))
        
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                completion?(outputURL)
            case .failed:
                print("failed \(exportSession.error.debugDescription)")
            case .cancelled:
                print("cancelled \(exportSession.error.debugDescription)")
            default: break
            }
        }
    }
    
    func uploadToStorage(videoLink: URL) {
        let storageReference = Storage.storage().reference().child("videos").child(randomID)
        storageReference.putFile(from: videoLink as URL, metadata: nil, completion: { (metadata, error) in
            if error == nil {
                self.loadSuccessAlert()
                //self.postToDatabase(videoURL: (metadata?.downloadURL()!.absoluteString)!)
                print("lets goooooo uploaded!")
            } else {
                print(error?.localizedDescription ?? "")
            }
        })
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func postVideoButtonPressed(_ sender: Any) {
        cropVideo(sourceURL: self.videoURL! as URL, startTime: self.startTime, endTime: self.endTime) { (outputURL) in
            self.uploadToStorage(videoLink: outputURL)
        }
    }
    
    @IBAction func saveVideoButtonPressed(_ sender: Any) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
        }) { saved, error in
            if saved {
                let alertController = UIAlertController(title: "Your video was successfully saved to your camera roll", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
}

extension EditVideoViewController: ABVideoRangeSliderDelegate {
    
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        self.startTime = startTime
        self.endTime = endTime
        trimView.updateProgressIndicator(seconds: startTime)
        self.player.seek(to: CMTimeMake(value: (Int64(startTime * 10000)), timescale: 10000))
        //self.player.seek(to: CMTimeMake(value: Int64(startTime), timescale: 1))
        self.item.forwardPlaybackEndTime = CMTimeMake(value: (Int64(endTime * 10000)), timescale: 10000)
        self.player.play()
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        //  self.shouldUpdateProgressIndicator = false
    }
    
}
