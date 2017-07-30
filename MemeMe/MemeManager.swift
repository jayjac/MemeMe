//
//  FileCreator.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 22/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit


//MARK: version 2.0
/** Saves, deletes, looks up memes that are saved on the disk
*/

struct MemeDataSourceModel {
    let originalImageUrl: URL
    let memedImageUrl: URL
    let topText: String
    let bottomText: String
    let fontName: String
    let activityType: UIActivityType?
}


struct MemeManager {
    
    private static let memesMainPath = "Memes"
    private static let originalImagePath = "originalImage.jpeg"
    private static let memedImagePath = "memedImage.jpeg"
    private static let metaDataPath = "data.bin"
    private(set) static var memesArray = [MemeDataSourceModel]()
    
    static var memesDirectoryUrl: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let memesDirectory = documentUrl.appendingPathComponent("Memes", isDirectory: true)
        return memesDirectory
    }
    
    
    static func initializeMemeData() {
        createMemesDirectoryIfDoesntExist()
        lookupMemesOnDisk()
    }
    
    private static func createMemesDirectoryIfDoesntExist() {
        guard !FileManager.default.fileExists(atPath: memesDirectoryUrl.path) else { return }
        do {
            try FileManager.default.createDirectory(at: memesDirectoryUrl, withIntermediateDirectories: false)
            //print("created directory at \(memesDirectoryUrl)")
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
        let metaData = ["topText": meme.topText, "bottomText": meme.bottomText, "fontName": meme.fontName, "activityType": meme.activityType ?? ""] as NSDictionary
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
        lookupMemesOnDisk()
    }
    
    
    static func deleteMemeFromDisk(with index: Int) {
        let dataSourceModel = memesArray[index]
        let url = dataSourceModel.originalImageUrl.deletingLastPathComponent()
        do {
            try FileManager.default.removeItem(at: url)
        } catch {}
        memesArray.remove(at: index)
    }
    
    private static func lookupMemesOnDisk() {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: memesDirectoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles) else { return }
        var dataSourceModel = [MemeDataSourceModel]()
        for url in urls {
            let dataUrl = url.appendingPathComponent(metaDataPath, isDirectory: false)
            let metaData = NSDictionary(contentsOf: dataUrl)!
            let originalImageUrl = url.appendingPathComponent(originalImagePath)
            let memedImageUrl = url.appendingPathComponent(memedImagePath)
            let topText = metaData["topText"] as! String
            let bottomText = metaData["bottomText"] as! String
            let fontName = metaData["fontName"] as! String
            let activityType = metaData["activityType"] as? UIActivityType
            let model = MemeDataSourceModel(originalImageUrl: originalImageUrl, memedImageUrl: memedImageUrl, topText: topText, bottomText: bottomText, fontName: fontName, activityType: activityType)
            dataSourceModel.append(model)
        }
        memesArray = dataSourceModel.reversed() //reverse it to have the memes appear in reverse chronological order in both the collectionView and the tableView
    }

}
