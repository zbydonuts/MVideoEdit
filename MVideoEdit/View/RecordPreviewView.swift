//
//  RecordPreviewView.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/04.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import GPUImage

protocol RecordPreviewViewModel {
    
}

final class RecordPreviewView: UIView {
    
    private var previewLayer: AVCaptureVideoPreviewLayer
    
    init(session: AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        super.init(frame: .zero)
        backgroundColor = .lightGray
        layer.addSublayer(previewLayer)
    }
    
    func bind(_ viewModel: RecordPreviewViewModel) {
        
    }
    
    private func updateVideoOrientation() {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:
            previewLayer.connection?.videoOrientation = .landscapeLeft
        case .landscapeRight:
            previewLayer.connection?.videoOrientation = .landscapeRight
        case .portrait:
            previewLayer.connection?.videoOrientation = .portrait
        case .portraitUpsideDown:
            previewLayer.connection?.videoOrientation = .portraitUpsideDown
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
        updateVideoOrientation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class GPUImagePreviewView: UIView {
    private let previewLayer: GPUImageView = {
        let view = GPUImageView()
        view.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        return view
    }()
    
    init(session: GPUImageRecordSession) {
        let movieFilter = MovieFilter(filters: [TestFilter()])
        movieFilter.enableFilter(input: session.output, outputView: previewLayer)
        
        
        //session.output.addTarget(previewLayer)
        super.init(frame: .zero)
        addSubview(previewLayer)
        autolayout()
    }
    
    private func autolayout() {
        previewLayer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
