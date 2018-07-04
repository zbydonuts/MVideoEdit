//
//  ReactiveExtension.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/04.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

extension Signal {
    func onMain() -> Signal<Value, Error> {
        return self.observe(on: UIScheduler())
    }
    
    func tr(_ object: NSObject) -> Signal<Value, Error> {
        return self.take(during: object.reactive.lifetime)
    }
    
    func disOnMainWith(_ object: NSObject) -> Signal<Value, Error> {
        return self.take(during: object.reactive.lifetime).observe(on: UIScheduler())
    }
}

extension SignalProducer {
    func onMain() -> SignalProducer<Value, Error> {
        return self.observe(on: UIScheduler())
    }
    
    func tr(_ object: NSObject) -> SignalProducer<Value, Error> {
        return self.take(during: object.reactive.lifetime)
    }
    
    func disOnMainWith(_ object: NSObject) -> SignalProducer<Value, Error> {
        return self.take(during: object.reactive.lifetime).observe(on: UIScheduler())
    }
}
