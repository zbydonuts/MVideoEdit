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

struct MovieComposerSetting {
    var enableBGM: Bool
    var enableVideoAudio: Bool
    var enableVoice: Bool
}

final class MovieComposer: NSObject {
    private var setting: MovieComposerSetting
    
    private var clips: [Clip]
    private var bgm: BGM?
    private var voice: Voice?
    
    var movieComposition: MovieComposition?
    
    
    init(clips: [Clip], bgm: BGM?, voice: Voice?, setting: MovieComposerSetting) {
        self.clips = clips
        self.bgm = bgm
        self.setting = setting
        super.init()
        createMoveComposition()
    }
    
    func createMoveComposition()  {
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        var audioParams = [AVMutableAudioMixInputParameters]()
    
        var instructionList = [AVMutableVideoCompositionInstruction]()
        
        //let videoSize = CGSize(width: 720, height: 1280)
        var startTime = CMTimeMake(10, 600)
        
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
                print("compose video track failed: " + error.localizedDescription)
            }
            
            if setting.enableVideoAudio {
                if let videoAudioTrack = asset.tracks(withMediaType: .audio).first {
                    do {
                        try compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, clip.timeRange.duration), of: videoAudioTrack, at: startTime)
                    } catch (let error) {
                        print("compose video audio track failed: " + error.localizedDescription)
                    }
                } else {
                    compositionAudioTrack?.insertEmptyTimeRange(CMTimeRangeMake(startTime, clip.timeRange.duration))
                }
                
                let videoAudioInputParams = AVMutableAudioMixInputParameters()
                videoAudioInputParams.setVolume(1.0, at: kCMTimeZero)
                audioParams.append(videoAudioInputParams)
            }
            
            startTime = CMTimeAdd(startTime, instruction.timeRange.duration)
        }
        
        // add audio track
        if let bgm = bgm, let bgmTrack = getBGMTrack(bgm, with: composition), setting.enableBGM {
            let bgmInputParams = AVMutableAudioMixInputParameters(track: bgmTrack)
            bgmInputParams.setVolume(1.0, at: kCMTimeZero)
            audioParams.append(bgmInputParams)
        }
        
        
        // add voice track
        if let voice = voice, let voiceTrack = getVoiceTrack(voice, with: composition), setting.enableVoice {
            let voiceInputParams = AVMutableAudioMixInputParameters(track: voiceTrack)
            voiceInputParams.setVolume(1.0, at: kCMTimeZero)
            audioParams.append(voiceInputParams)
        }
        
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = instructionList
        videoComposition.renderSize = CGSize.portrait720p
        videoComposition.frameDuration = CMTimeMake(20, 600)
        self.movieComposition = MovieComposition(composition: composition, videoCompostion: videoComposition, audioMix: nil)
        
        let audioMix = AVMutableAudioMix()
        audioMix.inputParameters = audioParams
    }
    
    private func getBGMTrack(_ bgm: BGM, with composition: AVMutableComposition) -> AVMutableCompositionTrack? {
        let asset = AVAsset(url: bgm.assetURL)
        return getAudioTrack(asset, with: composition)
    }
    
    private func getVoiceTrack(_ voice: Voice, with composition: AVMutableComposition) -> AVMutableCompositionTrack? {
        let asset = AVAsset(url: voice.assetURL)
        return getAudioTrack(asset, with: composition)
    }
    
    private func getAudioTrack(_ asset: AVAsset, with composition: AVMutableComposition) -> AVMutableCompositionTrack? {
        guard let audioTrack = asset.tracks(withMediaType: .audio).first else { return nil }
        let newAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        do {
            try newAudioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, composition.duration), of: audioTrack, at: kCMTimeZero)
        } catch(let error) {
            print("add audio track failed: " + error.localizedDescription)
        }
        return newAudioTrack
    }
    
}

