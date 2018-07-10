//
//  MovieListViewController.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/05.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift
import Result
import AVFoundation

final class MovieListViewController: UIViewController {
    
    lazy var tableView: UITableView = { [unowned self] in
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let assets: [URL] = {
        ClipFileManager.shared.fetchAllContents()
        return ClipFileManager.shared.assetURLs.map {
            print($0.path)
            return $0
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(closeButton)
        autolayout()
        setupAction()
    }
    
    private func setupAction() {
        closeButton.reactive.controlEvents(.touchUpInside).disOnMainWith(self).observeValues { [weak self] _ in
            guard let sSelf = self else { return }
            sSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    private func autolayout() {
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MoviePreviewViewController(url: assets[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}


final class MoviePreviewViewController: UIViewController {
    
    private let playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        return layer
    }()
    
    private var player: AVPlayer
    private var url: URL
    
    init(url: URL) {
        self.url = url
        let asset = AVAsset(url: url)
        print(asset.duration)
        player = AVPlayer(url: url)
        super.init(nibName: nil, bundle: nil)
        playerLayer.player = player
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.addSublayer(playerLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MovieClipPreviewViewController: UIViewController {
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    private let playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        return layer
    }()
    
    private var movieComposition: MovieComposition?
    private var player = AVPlayer()
//    private var clips: [Clip]
//    private var currentIndex: Int = 0
    
    init(movieComposition: MovieComposition?) {
//        self.clips = clips
        self.movieComposition = movieComposition
        super.init(nibName: nil, bundle: nil)
        playerLayer.player = player
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.addSublayer(playerLayer)
        view.addSubview(closeButton)
        setupNotification()
        autolayout()
        setupAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        guard clips.count > 0 else { return }
//        playClipAtIndex(0)
        guard let movie = movieComposition else { return }
        let playeItem = AVPlayerItem(asset: movie.composition)
        player.replaceCurrentItem(with: playeItem)
        player.play()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying(notificaiton:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func autolayout() {
        closeButton.sizeToFit()
        closeButton.snp.makeConstraints { (make) in
            make.width.equalTo(closeButton.bounds.width)
            make.height.equalTo(closeButton.bounds.height)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-50)
        }
    }
    
    private func setupAction() {
        closeButton.reactive.controlEvents(.touchUpInside).disOnMainWith(self).observeValues { [weak self] _ in
            guard let sSelf = self else { return }
            sSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func didFinishPlaying(notificaiton: Notification) {
//        currentIndex += 1
//        guard currentIndex < clips.count else { return }
//        playClipAtIndex(currentIndex)
    }
    
    private func playClipAtIndex(_ index: Int) {
//        let asset = AVAsset(url: clips[index].assetURL)
//        let playItem = AVPlayerItem(asset: asset)
//        player.replaceCurrentItem(with: playItem)
//        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
