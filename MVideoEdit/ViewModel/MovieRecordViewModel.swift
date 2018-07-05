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
import UIKit


final class MovieRecordViewModel: NSObject, RecordEditViewModel {
    let recordSession = GPUImageRecordSession()
    
    let rotateCameraAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let addBgmAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let editSepeedAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let movieListAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let recordAction: Action<Void, Void, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let presentVCAction: Action<UIViewController, UIViewController, NoError> = {
        return Action { SignalProducer(value: $0) }
    }()
    
    let inRecording = MutableProperty<Bool>(false)
    
    override init() {
        super.init()
        setupNotification()
        rotateCameraAction.values.disOnMainWith(self).observeValues { [weak self] in
            guard let sSelf = self else { return }
            sSelf.recordSession.excuteCameraEvent(.rotate)
        }
        
        recordAction.values.disOnMainWith(self).observeValues { [weak self] in
            guard let sSelf = self else { return }
            sSelf.inRecording.swap(!sSelf.inRecording.value)
        }
        
        
        let movieListVCProducer = movieListAction.values.producer.map { _ -> UIViewController in
            let vc = MovieListViewController()
            return UINavigationController(rootViewController: vc)
        }
        
        SignalProducer.merge(movieListVCProducer).startWithValues { [weak self] (vc) in
            self?.presentVCAction.apply(vc).start()
        }
        
        inRecording.signal.disOnMainWith(self).observeValues { [weak self] (value) in
            guard let sSelf = self else { return }
            if value {
                sSelf.recordSession.startRecord()
            } else {
                sSelf.recordSession.stopRecord()
            }
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.UIApplicationWillResignActive, object: nil)
                                  .disOnMainWith(self)
                                  .observeValues { [weak self] _ in
                                    guard let sSelf = self else { return }
                                    //if in recording, stop recording & save the clip
                                    sSelf.recordSession.excuteCameraEvent(.pause)
        }
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.UIApplicationDidBecomeActive, object: nil)
                                  .disOnMainWith(self)
                                  .observeValues { [weak self] _ in
                                    guard let sSelf = self else { return }
                                    sSelf.recordSession.excuteCameraEvent(.resume)
        }
    }
    
    func startCapturing() {
        recordSession.excuteCameraEvent(.start)
    }
}

