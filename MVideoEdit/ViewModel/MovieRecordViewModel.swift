//
//  MovieRecordViewModel.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/04.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

final class MovieRecordViewModel: NSObject, RecordEditViewModel {
    let recordSession = RecordSession()
    
    let switchCameraAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let addBgmAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let editSepeedAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let recordAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    override init() {
        super.init()
        
        switchCameraAction.values.disOnMainWith(self).observeValues { [weak self] in
            guard let sSelf = self else { return }
            sSelf.recordSession.switchCamera()
        }
        
        
    }
    
    func startCapturing() {
        recordSession.captureSession.startRunning()
    }
}

