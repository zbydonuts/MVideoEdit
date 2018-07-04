//
//  RecordEditView.swift
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
import SnapKit

protocol RecordEditViewModel {
    var switchCameraAction      : Action<Void, Void, NoError> { get }
    var addBgmAction            : Action<Void, Void, NoError> { get }
    var editSepeedAction        : Action<Void, Void, NoError> { get }
    var recordAction            : Action<Void, Void, NoError> { get }
}

final class RecordEditView: UIView {
    
    private let switchCameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Camear", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let addBgmButton: UIButton = {
        let button = UIButton()
        button.setTitle("BGM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let editSpeedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Speed", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 40
        button.alpha = 0.5
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview(switchCameraButton)
        addSubview(addBgmButton)
        addSubview(editSpeedButton)
        addSubview(recordButton)
        autolayout()
    }
    
    func bind(_ viewModel: RecordEditViewModel) {
        switchCameraButton.reactive.pressed = CocoaAction(viewModel.switchCameraAction)
        addBgmButton.reactive.pressed = CocoaAction(viewModel.addBgmAction)
        editSpeedButton.reactive.pressed = CocoaAction(viewModel.editSepeedAction)
        recordButton.reactive.pressed = CocoaAction(viewModel.recordAction)
    }
    
    func autolayout() {
        switchCameraButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(40)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        addBgmButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(switchCameraButton.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        editSpeedButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(addBgmButton.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        recordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-25)
            make.size.equalTo(80)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
