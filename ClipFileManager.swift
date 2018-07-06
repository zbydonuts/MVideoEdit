//
//  RecordFileManager.swift
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/05.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

import Foundation

final class ClipFileManager: NSObject {
    
    static let shared = ClipFileManager()
    private var draftURL: URL?
    
    var assetURLs = [URL]()
    
    override init() {
        super.init()
        createRootDir()
    }
    
    private func createRootDir() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let draftURL = documentPath.appendingPathComponent("draft")
        guard FileManager.default.fileExists(atPath: draftURL.path) == false else {
            print("draft directory exists")
            self.draftURL = draftURL
            return
        }
        do {
            try FileManager.default.createDirectory(at: draftURL, withIntermediateDirectories: true, attributes: nil)
            self.draftURL = draftURL
        } catch (let error) {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func fetchAllContents() {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: draftURL!.path)
            assetURLs = contents.map {
                return draftURL!.appendingPathComponent($0)
            }
        } catch {
            
        }
    }
    
    func requestFileURL(name: String, type: String) -> URL {
        let fileName = name + "\(Int(Date().timeIntervalSince1970))" + "." + type
        let url = draftURL!.appendingPathComponent(fileName)
        print("save to " + url.path)
        return url
    }
    
}
