//
//  MovieConposer.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/09.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import AVFoundation

extension CGSize {
    static var portrait720p: CGSize {
        return CGSize(width: 720, height: 1280)
    }
}

struct MovieComposition {
    var composition         : AVComposition
    var videoCompostion     : AVVideoComposition
    var audioMix            : AVAudioMix?
}

final class MovieComposer: NSObject {
    private var clips: [Clip]
    var movieComposition: MovieComposition?
    
    init(clips: [Clip]) {
        self.clips = clips
        super.init()
        createMoveComposition()
    }
    
    func createMoveComposition()  {
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        //let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        var instructionList = [AVMutableVideoCompositionInstruction]()
        
        //let videoSize = CGSize(width: 720, height: 1280)
        var startTime = CMTimeMake(0, 600)
        
        for clip in clips {
            clip.offsetTime = startTime
            let asset = AVAsset(url: clip.assetURL)
            guard let videoTrack = asset.tracks(withMediaType: .video).first else { return }
            
            let instruction = AVMutableVideoCompositionInstruction()
            let layerInstruction = AVMutableVideoCompositionLayerInstruction()
            
            //let videoRect = CGRect(origin: .zero, size: videoTrack.naturalSize)
            
            instruction.layerInstructions = [layerInstruction]
            instruction.timeRange = CMTimeRangeMake(startTime, clip.timeRange.duration)
            instructionList.append(instruction)
            
            do {
                try compositionVideoTrack?.insertTimeRange(clip.timeRange, of: videoTrack, at: startTime)
            } catch(let error) {
                print("compose failed: " + error.localizedDescription)
            }
            startTime = CMTimeAdd(startTime, instruction.timeRange.duration)
        }
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = instructionList
        videoComposition.renderSize = CGSize.portrait720p
        self.movieComposition = MovieComposition(composition: composition, videoCompostion: videoComposition, audioMix: nil)
    }
}

