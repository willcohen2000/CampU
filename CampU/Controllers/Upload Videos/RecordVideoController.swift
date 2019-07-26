//
//  RecordVideoController.swift
//  CampU
//
//  Created by Will Cohen on 7/26/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos

class RecordVideoController: UIViewController, AVCaptureFileOutputRecordingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var videoFeedView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var chooseFromLibraryButton: UIButton!
    
    var isRecording: Bool = false;
    var canRecord: Bool = true;
    
    var timer: Timer?
    
    let imagePickerController = UIImagePickerController()
    
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    var outputURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureViews();
        
        if setupSession() {
            setupPreview();
            startSession();
        } else {
            canRecord = false;
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (canRecord) {
            previewLayer.frame = videoFeedView.layer.bounds;
        }
    }
    
    private func configureViews() {
        chooseFromLibraryButton.layer.cornerRadius = (chooseFromLibraryButton.frame.height / 2);
        recordButton.layer.cornerRadius = (recordButton.frame.height / 2);
        recordButton.layer.borderColor = Colors.centralBlack.cgColor;
        recordButton.layer.borderWidth = 1.0;
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoFeedView.layer.addSublayer(previewLayer)
    }
    
    func setupSession() -> Bool {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // Setup Camera
        if let camera = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                
                let input = try AVCaptureDeviceInput(device: camera)
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    activeInput = input
                }
            } catch {
                print("Error setting device video input: \(error)")
                return false
            }
            
            // Setup Microphone
            let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
            
            do {
                let micInput = try AVCaptureDeviceInput(device: microphone)
                if captureSession.canAddInput(micInput) {
                    captureSession.addInput(micInput)
                }
            } catch {
                print("Error setting device audio input: \(error)")
                return false
            }
            
            
            // Movie output
            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            }
            
            return true
        }
        print("Using simulator or device with no camera")
        return false
    }
    
    func setupCaptureMode(_ mode: Int) {
        // Video Mode
        
    }
    
    //MARK:- Camera Session
    func startSession() {
        
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVideoSegue" {
            if let destination = segue.destination as? EditVideoViewController {
                destination.videoURL = self.outputURL;
            }
        }
    }
    
    func startRecording() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeRecordedLabel), userInfo: nil, repeats: true);
        if movieOutput.isRecording == false {
            
            let connection = movieOutput.connection(with: AVMediaType.video)
            
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            
            if (device.isSmoothAutoFocusSupported) {
                
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
                
            }
            
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
        }
        else {
            stopRecording()
        }
        
    }
    
    func stopRecording() {
        timer?.invalidate();
        timer = nil;
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if (error != nil) {
            
            print("Error recording movie: \(error!.localizedDescription)")
            
        } else {
            
            let videoRecorded = outputURL! as URL
            outputURL = videoRecorded;
            performSegue(withIdentifier: "toEditVideoSegue", sender: videoRecorded);
            
        }
        
    }
    
    @objc func updateTimeRecordedLabel() {
        if (timer != nil) {
            var secondsLabelText = secondsLabel.text!;
            let wordToRemove = " seconds";
            if let range = secondsLabelText.range(of: wordToRemove) {
                secondsLabelText.removeSubrange(range)
            }
            let currentSeconds = Float(secondsLabelText)!;
            secondsLabel.text = "\(String(format: "%.01f", (currentSeconds + 0.1))) seconds";
        }
    }
    
    func checkPermissions() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    
                } else {
                    print("do something ehre tohandle")
                }
            })
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        checkPermissions();
        
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            dismiss(animated: true) {
                self.outputURL = videoURL as URL;
                self.performSegue(withIdentifier: "toEditVideoSegue", sender: self);
            }
        }
        //Dismiss the controller after picking some media
        //dismiss(animated: true, completion: nil);
        
    }
    
    @IBAction func chooseFromLibraryButtonPressed(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func recordingButtonPressed(_ sender: Any) {
        isRecording = !isRecording;
        if (isRecording && canRecord) {
            startRecording();
            recordButton.backgroundColor = Colors.centralBlack;
        } else {
            stopRecording();
            recordButton.backgroundColor = UIColor.white;
        }
    }
    
}
