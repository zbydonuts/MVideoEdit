//
//  MovieRecordBarView.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/09.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import UIKit

final class MovieRecordBarView: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress(progress)
        }
    }
    
    private var separateLine = [CALayer]()
    private let progressLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.yellow.cgColor
        layer.anchorPoint = CGPoint(x: 0, y: 0)
        return layer
    }()
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 3
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(progressLayer)
    }
    
    private func updateProgress(_ value: CGFloat) {
        let cutValue = min(max(0, value), 1)
        let duration = Double(60 * cutValue)
        let toValue   = cutValue * bounds.width
        let animation = CABasicAnimation()
        animation.keyPath   = "bounds.size.width"
        animation.fromValue = progressLayer.bounds.width
        animation.toValue   = toValue
        animation.duration  = duration
        animation.isRemovedOnCompletion = false
        progressLayer.bounds = CGRect(x: 0, y: 0, width: toValue, height: progressLayer.bounds.height)
        progressLayer.add(animation, forKey: "bounds")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.bounds = CGRect(x: 0, y: 0, width: progressLayer.bounds.width, height: bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
