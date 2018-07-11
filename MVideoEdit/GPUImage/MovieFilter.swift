//
//  MovieFilter.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/11.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import GPUImage

class MovieFilter: NSObject {
    private let filters : [GPUImageFilter]
    
    init(filters: [GPUImageFilter]) {
        self.filters = filters
        super.init()
    }
    
    func enableFilter(input: GPUImageOutput, outputView: GPUImageView) {
        var curInput = input
        for i in 0 ..< filters.count {
            curInput.addTarget(filters[i])
            curInput = filters[i]
        }
        curInput.addTarget(outputView)
    }
}
