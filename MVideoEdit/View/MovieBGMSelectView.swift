//
//  MovieBGMSelectView.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/10.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import AVFoundation

protocol MovieBGMSelectViewModel {
    var closeBGMSelectAction: Action<Void, Void, NoError> { get }
    var bgmSelectViewHidden : MutableProperty<Bool> { get }
    var currentBGM: MutableProperty<BGM?> { get }
}

final class MovieBGMSelectView: UIView {
    private lazy var tableView: UITableView = { [unowned self] in
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        view.tableFooterView = UIView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        return button
    }()
    
    private var data = [BGM]()
    
    private var currentBGM = MutableProperty<BGM?>(nil)
    
    init() {
        super.init(frame: .zero)
        data = getData()
        addSubview(closeButton)
        addSubview(tableView)
        autolayout()
    }
    
    private func getData() -> [BGM] {
        let url1 = Bundle.main.url(forResource: "easylove", withExtension: "mp3")!
        let asset1 = AVAsset(url: url1)
        let bgm1 = BGM(name: "easylove", assetURL: url1, timeRange: CMTimeRangeMake(kCMTimeZero, asset1.duration))
        
        let url2 = Bundle.main.url(forResource: "kataomoi", withExtension: "mp3")!
        let asset2 = AVAsset(url: url2)
        let bgm2 = BGM(name: "kataomoi", assetURL: url2, timeRange: CMTimeRangeMake(kCMTimeZero, asset2.duration))
        return [bgm1, bgm2]
    }
    
    func bind(_ viewModel: MovieBGMSelectViewModel) {
        closeButton.reactive.pressed = CocoaAction(viewModel.closeBGMSelectAction)
        reactive.isHidden <~ viewModel.bgmSelectViewHidden.producer.disOnMainWith(self)
        viewModel.currentBGM <~ currentBGM.producer.disOnMainWith(self)
    }
    
    private func autolayout() {
        closeButton.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieBGMSelectView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        cell?.textLabel?.text = data[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentBGM.swap(data[indexPath.row])
    }
}
