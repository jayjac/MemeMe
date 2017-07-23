//
//  FileCreator.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 22/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit


//MARK: version 2.0
struct FileCreator {
    
    private static let memesMainPath = "Memes"
    private static let originalImagePath = "originalImage.jpeg"
    private static let memedImagePath = "memedImage.jpeg"
    private static let metaDataPath = "data.bin"
    
    static var memesDirectoryUrl: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let memesDirectory = documentUrl.appendingPathComponent("Memes", isDirectory: true)
        return memesDirectory
    }
    
    static func createMemesDirectory() {
        guard !FileManager.default.fileExists(atPath: memesDirectoryUrl.path) else { return }
        do {
            try FileManager.default.createDirectory(at: memesDirectoryUrl, withIntermediateDirectories: false)
            print("created directory at \(memesDirectoryUrl)")
        } catch let err {
            print(err)
        }
    }
    
    static func saveMemeOnDisk(_ meme: Meme) {
        let date = Date()
        let directoryName = "\(date.timeIntervalSinceReferenceDate)"
        let url = memesDirectoryUrl.appendingPathComponent(directoryName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
            print("created directory successfully")
        }
        catch {}
        let metaData = ["topText": meme.topText, "bottomText": meme.bottomText, "fontName": meme.fontName] as NSDictionary
        let originalData = UIImageJPEGRepresentation(meme.originalImage, 1.0)
        let memedData = UIImageJPEGRepresentation(meme.memedImage, 1.0)
        
        let originalImageUrl = url.appendingPathComponent(originalImagePath, isDirectory: false)
        let memedImageUrl = url.appendingPathComponent(memedImagePath, isDirectory: false)
        let metaDataUrl = url.appendingPathComponent(metaDataPath, isDirectory: false)
        do {
            try originalData?.write(to: originalImageUrl)
            try memedData?.write(to: memedImageUrl)
            metaData.write(to: metaDataUrl, atomically: true)
        }
        catch {
            print("error saving the meme")
        }
        
    }
    
    static func lookupMemes() {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: memesDirectoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles) else { return }
        for url in urls {
            print(url)
            let dataUrl = url.appendingPathComponent(metaDataPath, isDirectory: false)
            let dictionary = NSDictionary(contentsOf: dataUrl)
            print(dictionary!)
        }
    }

}
