//
//  MovieCreateSession.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/09.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import AVFoundation

struct Clip {
    var assetURL: URL
    var timeRange: CMTimeRange
    
    init(assetURL: URL, timeRange: CMTimeRange) {
        self.assetURL = assetURL
        self.timeRange = timeRange
    }
}

final class MovieCreateSession: NSObject {
    
    static let shared = MovieCreateSession()
    var clips: [Clip]
    
    private var currentTime: CMTime = kCMTimeZero
    
    override init() {
        clips = []
        super.init()
    }
    
    func addAssetURL(_ url: URL) {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let timeRange = CMTimeRangeMake(currentTime, duration)
        let clip = Clip(assetURL: url, timeRange: timeRange)
        clips.append(clip)
    }
}
