//
//  RecordSession.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/04.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import AVFoundation
import GPUImage
import ReactiveCocoa
import ReactiveSwift
import Result

enum CameraType {
    case front
    case back
}

final class RecordSession: NSObject {

    
    var captureSession = AVCaptureSession()
    
    var videoDevice: AVCaptureDevice?
    var videoInput : AVCaptureInput?
    
    
    var audioDevice: AVCaptureDevice?
    var audioInput : AVCaptureInput?
    
    let outputQueue = DispatchQueue(label: "outputQueue")
    var curCamearType: CameraType = .front
    
    override init() {
        super.init()
        requestPermision()
        setupCamera(type: .front)
        setupCaptureOutput()
    }
    
    func switchCamera() {
        switch curCamearType {
        case .front:
            setupCamera(type: .back)
            curCamearType = .back
        case .back:
            setupCamera(type: .front)
            curCamearType = .front
        }
    }

    private func setupCamera(type: CameraType) {
        if videoInput != nil {
            captureSession.removeInput(videoInput!)
            videoInput = nil
        }
        
        var deviceHolder: AVCaptureDevice? = nil
        switch type {
        case .front:
            deviceHolder = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        case .back:
            deviceHolder = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        
        guard let device = deviceHolder else {
            print("get \(type) camear failed ")
            return
        }
        
        videoDevice = device
        do {
            let input  = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
            videoInput = input
        } catch {
            print("get device input failed")
        }
    }
    
    func setupCaptureOutput() {
        captureSession.beginConfiguration()
        if captureSession.canSetSessionPreset(.hd1280x720) {
            captureSession.sessionPreset = .hd1280x720
        } else if captureSession.canSetSessionPreset(.high) {
            captureSession.sessionPreset = .high
        }
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        output.setSampleBufferDelegate(self, queue: outputQueue)
        guard self.captureSession.canAddOutput(output) else {
            print("Failed to add capture session output.")
            return
        }
        captureSession.addOutput(output)
        captureSession.commitConfiguration()
    }
    
    private func requestPermision() {
        AVCaptureDevice.requestAccess(for: .video) { (result) in
            guard result else {
                print("video permission not allowed")
                return
            }
        }
        
        AVCaptureDevice.requestAccess(for: .video) { (result) in
            guard result else {
                print("microphone permission not allowed")
                return
            }
        }
    }
}

extension RecordSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}


enum GPUImageCameraEvent {
    case start
    case pause
    case resume
    case stop
    case rotate
}

struct RecordState {
    var movieWriter: GPUImageMovieWriter
    var outputURL: URL
}

final class GPUImageRecordSession: NSObject {
    private let videoSize = CGSize(width: 720, height: 1280)
    
    private let camera = GPUImageVideoCamera()
    private var recordState: RecordState?
    
    
    var output: GPUImageOutput {
        return camera
    }
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func excuteCameraEvent(_ event: GPUImageCameraEvent) {
        switch event {
        case .start:
            camera.startCapture()
        case .pause:
            camera.pauseCapture()
        case .resume:
            camera.resumeCameraCapture()
        case .stop:
            camera.stopCapture()
        case .rotate:
            camera.rotateCamera()
        }
    }
    
    func startRecord() {
        let outputURL = ClipFileManager.shared.requestFileURL(name: "movie", type: "mov")
        let outputSettings: [AnyHashable: Any] = [AVVideoCodecKey: AVVideoCodecH264,
                                                  AVVideoWidthKey: videoSize.width,
                                                 AVVideoHeightKey: videoSize.height,
                                            AVVideoScalingModeKey: AVVideoScalingModeResizeAspect]
        
        let movieWriter = GPUImageMovieWriter(movieURL: outputURL,
                                                  size: videoSize,
                                              fileType: AVFileType.mov.rawValue,
                                        outputSettings: outputSettings)
        
        guard let writer = movieWriter else {
            print("create movie writer failed")
            return
        }
        output.addTarget(writer)
        camera.audioEncodingTarget = writer
        recordState = RecordState(movieWriter: writer, outputURL: outputURL)
        writer.startRecording()
    }
    
    func stopRecord() {
        recordState?.movieWriter.finishRecording()
        output.removeTarget(recordState?.movieWriter)
        camera.audioEncodingTarget = nil
    }
    
    private func setupCamera() {
        if camera.captureSession.canSetSessionPreset(.hd1280x720) {
            camera.captureSession.sessionPreset = .hd1280x720
        } else if camera.captureSession.canSetSessionPreset(.high) {
            camera.captureSession.sessionPreset = .high
        }

        updateCameraOrientation()
        camera.horizontallyMirrorRearFacingCamera = false
        camera.horizontallyMirrorFrontFacingCamera = true
        camera.addAudioInputsAndOutputs()
    }
    
    func updateCameraOrientation() {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            camera.outputImageOrientation = .portrait
        case .landscapeLeft:
            camera.outputImageOrientation = .landscapeLeft
        case .landscapeRight:
            camera.outputImageOrientation = .landscapeRight
        default:
            break
        }
    }
}
