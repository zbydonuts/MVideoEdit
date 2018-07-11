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

final class BGM: NSObject {
    var name: String
    var assetURL: URL
    var timeRange: CMTimeRange

    init(name: String, assetURL: URL, timeRange: CMTimeRange) {
        self.name = name
        self.assetURL = assetURL
        self.timeRange = timeRange
        super.init()
    }
}

final class Voice: NSObject {
    var assetURL: URL
    var timeRange: CMTimeRange
    
    init(assetURL: URL, timeRange: CMTimeRange) {
        self.assetURL = assetURL
        self.timeRange = timeRange
    }
}

final class MovieCreateManager: NSObject {
    static let shared = MovieCreateManager()
    var clips  : [Clip]
    var bgm    : BGM? = nil
    var voice  : Voice? = nil
    
    override init() {
        clips = []
        super.init()
    }
    
    func addAssetURL(_ url: URL) {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        //The audio record start while the video record is not ready which cause blank frame, delete first 0.1 and last 0.1 second
        let timeRange = CMTimeRangeMake(CMTimeMake(60, 600), CMTimeSubtract(duration, CMTimeMake(120, 600)))
        let clip = Clip(assetURL: url, timeRange: timeRange)
        clips.append(clip)
    }
    
    func addBGM(_ bgm: BGM) {
        self.bgm = bgm
    }
    
    func getMovieComposition() -> MovieComposition? {
        let composerSetting = MovieComposerSetting(enableBGM: true, enableVideoAudio: true, enableVoice: true)
        let composer = MovieComposer(clips: clips, bgm: bgm, voice: voice, setting: composerSetting)
        return composer.movieComposition
    }
}
