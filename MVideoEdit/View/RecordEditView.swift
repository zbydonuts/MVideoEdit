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
    var rotateCameraAction      : Action<Void, Void, NoError> { get }
    var addBgmAction            : Action<Void, Void, NoError> { get }
    var editSepeedAction        : Action<Void, Void, NoError> { get }
    var recordAction            : Action<Void, Void, NoError> { get }
    var movieListAction         : Action<Void, Void, NoError> { get }
    
    var inRecording             : MutableProperty<Bool> { get }
}

final class RecordEditView: UIView {
    
    private let rotateCameraButton: UIButton = {
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
    
    private let movieListButton: UIButton = {
        let button = UIButton()
        button.setTitle("MovieList", for: .normal)
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
        addSubview(rotateCameraButton)
        addSubview(addBgmButton)
        addSubview(editSpeedButton)
        addSubview(recordButton)
        addSubview(movieListButton)
        autolayout()
    }
    
    func bind(_ viewModel: RecordEditViewModel) {
        rotateCameraButton.reactive.pressed     = CocoaAction(viewModel.rotateCameraAction)
        addBgmButton.reactive.pressed           = CocoaAction(viewModel.addBgmAction)
        editSpeedButton.reactive.pressed        = CocoaAction(viewModel.editSepeedAction)
        movieListButton.reactive.pressed        = CocoaAction(viewModel.movieListAction)
        recordButton.reactive.pressed           = CocoaAction(viewModel.recordAction)
        
        viewModel.inRecording.producer.disOnMainWith(self).startWithValues { [weak self] (value) in
            guard let sSelf = self else { return }
            UIView.animate(withDuration: 1.0, animations: {
                sSelf.recordButton.layer.cornerRadius = value ? 0 : 40
            })
            
            sSelf.rotateCameraButton.isHidden = value
            sSelf.addBgmButton.isHidden = value
            sSelf.editSpeedButton.isHidden = value
            sSelf.movieListButton.isHidden = value
        }
    }
    
    func autolayout() {
        rotateCameraButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(40)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        addBgmButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(rotateCameraButton.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        editSpeedButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(addBgmButton.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        movieListButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(editSpeedButton.snp.bottom).offset(20)
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
