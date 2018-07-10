//
//  MovieCreateSession.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/09.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import AVFoundation

final class Clip: NSObject {
    var assetURL: URL
    var timeRange: CMTimeRange
    var offsetTime: CMTime = kCMTimeZero
    
    init(assetURL: URL, timeRange: CMTimeRange) {
        self.assetURL = assetURL
        self.timeRange = timeRange
        super.init()
    }
}

final class MovieCreateManager: NSObject {
    static let shared = MovieCreateManager()
    var clips: [Clip]
    
    override init() {
        clips = []
        super.init()
    }
    
    func addAssetURL(_ url: URL) {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let timeRange = CMTimeRangeMake(CMTimeMake(10, 600), CMTimeSubtract(duration, CMTimeMake(10, 600)))
        let clip = Clip(assetURL: url, timeRange: timeRange)
        clips.append(clip)
    }
    
    func getMovieComposition() -> MovieComposition? {
        let composor = MovieComposer(clips: clips)
        return composor.movieComposition
    }
}
