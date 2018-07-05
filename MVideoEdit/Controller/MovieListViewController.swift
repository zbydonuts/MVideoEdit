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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}
