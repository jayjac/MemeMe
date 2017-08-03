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


// This struct holds the information that is necessary to fill the tableview's and the collectionview's cells
struct MemeDataSourceModel {
    let originalImageUrl: URL
    let memedImageUrl: URL
    let miniImageUrl: URL
    let topText: String
    let bottomText: String
    let fontName: String
    let date: Date
    let activityType: UIActivityType?
}


struct MemeManager {
    // Constants
    private static let memesMainPath = "Memes"
    private static let originalImagePath = "originalImage.jpeg"
    private static let memedImagePath = "memedImage.jpeg"
    private static let miniImagePath = "miniImage.jpeg"
    private static let metaDataPath = "data.bin"
    // ---------------------
    
    // Array shared by the collectionview and the tableview
    private(set) static var memesDataSourceArray = [MemeDataSourceModel]()
    
    // Convenience method to get the '/applicationSandboxDirectory/Memes' folder
    static var memesDirectoryUrl: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let memesDirectory = documentUrl.appendingPathComponent("Memes", isDirectory: true)
        return memesDirectory
    }
    
    
    static func initializeMemeData() {
        createMemesDirectoryIfDoesntExist()
        lookupMemesOnDisk()
    }
    
    
    //Should only be called on the app's first launch
    private static func createMemesDirectoryIfDoesntExist() {
        guard !FileManager.default.fileExists(atPath: memesDirectoryUrl.path) else { return }
        do {
            try FileManager.default.createDirectory(at: memesDirectoryUrl, withIntermediateDirectories: false)
        } catch let err {
            print(err)
        }
    }
    
    // Inspects the "Memes" directory to retrieve all the previously shared memes and creates the dataSourceArray
    private static func lookupMemesOnDisk() {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: memesDirectoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles) else { return }
        var dataSourceModel = [MemeDataSourceModel]()
        for url in urls {
            let dataUrl = url.appendingPathComponent(metaDataPath, isDirectory: false)
            let metaData = NSDictionary(contentsOf: dataUrl)!
            let originalImageUrl = url.appendingPathComponent(originalImagePath)
            let memedImageUrl = url.appendingPathComponent(memedImagePath)
            let miniImageUrl = url.appendingPathComponent(miniImagePath)
            let topText = metaData["topText"] as! String
            let bottomText = metaData["bottomText"] as! String
            let fontName = metaData["fontName"] as! String
            let date = metaData["date"] as! Date
            let activityType = metaData["activityType"] as? UIActivityType
            let model = MemeDataSourceModel(originalImageUrl: originalImageUrl, memedImageUrl: memedImageUrl, miniImageUrl: miniImageUrl, topText: topText, bottomText: bottomText, fontName: fontName, date: date, activityType: activityType)
            dataSourceModel.append(model)
        }
        memesDataSourceArray = dataSourceModel.reversed() //reverse it to have the memes appear in reverse chronological order in both the collectionView and the tableView
    }

    /* The meme will be saved on disk in the following folder: /appSandboxDirectory/Memes/timestampOfTheMeme/
    In this directory, several files will be saved.
      - originalImage.jpeg contains the image without the meme texts
      - memedImage.jpeg contains the image after it has been turned into a meme
      - miniImage.jpeg contains the original image resized to be 200px x 200px max (for faster loading time into the tableview and collectionview
      - data.bin contains the meta data: the upper and lower texts, the font used, the date and the UIActivityType to remember how the meme was shared (in order to display a message like "shared on facebook on <date>") */
    static func saveMemeOnDisk(_ meme: Meme) {
        let date = Date()
        let directoryName = "\(date.timeIntervalSinceReferenceDate)"
        let directoryUrl = memesDirectoryUrl.appendingPathComponent(directoryName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: false)
        }
        catch {
            return
        }
        let metaData = ["topText": meme.topText, "bottomText": meme.bottomText, "fontName": meme.fontName, "activityType": meme.activityType ?? "", "date": date] as NSDictionary
        let originalData = UIImageJPEGRepresentation(meme.originalImage, 1.0)
        let memedData = UIImageJPEGRepresentation(meme.memedImage, 1.0)
        
        let miniImage = generateMiniImage(from: meme.originalImage)
        let miniImageData = UIImageJPEGRepresentation(miniImage, 1.0)
        let originalImageUrl = directoryUrl.appendingPathComponent(originalImagePath, isDirectory: false)
        let memedImageUrl = directoryUrl.appendingPathComponent(memedImagePath, isDirectory: false)
        let miniImageUrl = directoryUrl.appendingPathComponent(miniImagePath, isDirectory: false)
        let metaDataUrl = directoryUrl.appendingPathComponent(metaDataPath, isDirectory: false)
        do {
            try originalData?.write(to: originalImageUrl)
            try memedData?.write(to: memedImageUrl)
            try miniImageData?.write(to: miniImageUrl)
            metaData.write(to: metaDataUrl, atomically: true)
        }
        catch let error {
            print("error saving the meme: \(error.localizedDescription)")
        }
        lookupMemesOnDisk()
    }
    
    
    //Generates a small version of the original image for faster loading time when calling UIImage(contentsOfFile:) in the tableview / collectionview
    private static func generateMiniImage(from image: UIImage) -> UIImage {
        let maxSide = max(image.size.width, image.size.height)
        let ratio = 200.0 / maxSide
        let size = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let miniImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return miniImage
    }
    
    //When user swipes across the tableview to delete the meme this function deletes the meme from disk
    static func deleteMemeFromDisk(with index: Int) {
        let dataSourceModel = memesDataSourceArray[index]
        let url = dataSourceModel.originalImageUrl.deletingLastPathComponent()
        do {
            try FileManager.default.removeItem(at: url)
        } catch {}
        memesDataSourceArray.remove(at: index)
    }
    


}
