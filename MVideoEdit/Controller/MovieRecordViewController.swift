//
//  MovieRecordViewController.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/04.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import SnapKit

final class MovieRecordViewController: UIViewController {
    private lazy var previewView: GPUImagePreviewView = { [unowned self] in
        let view = GPUImagePreviewView(session: viewModel.recordSession)
        return view
    }()
    
    private let editView = RecordEditView()
    
    private let viewModel = MovieRecordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(previewView)
        view.addSubview(editView)
        autolayout()
        bind(viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startCapturing()
    }
    
    func bind(_ viewModel: MovieRecordViewModel) {
        editView.bind(viewModel)
        
        viewModel.presentVCAction.values.disOnMainWith(self).observeValues { [weak self] (vc) in
            guard let sSelf = self else { return }
            sSelf.present(vc, animated: true, completion: nil)
        }
    }
    
    func autolayout() {
        previewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        editView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.viewModel.deviceRotated()
        }
    }
}


