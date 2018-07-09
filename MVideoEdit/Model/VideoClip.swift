//
//  VideoClip.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/04.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct VideoClip {
    var asset: AVAsset
    var timeRange: CMTimeRange
    var frames: Int
    var beginTime: CMTime
    var orientation: UIImageOrientation
}


