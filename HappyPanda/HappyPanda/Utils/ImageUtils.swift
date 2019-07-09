//
//  ImageUtils.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/8/4.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

public struct ImageUtils {
    
    static let documentName = "Comic"
    

    static func createComicDocument(){
        var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let fileManager = FileManager.default
        
        documentsPath.append("/\(ImageUtils.documentName)")
        if !fileManager.fileExists(atPath: documentsPath) {
            do {
                try fileManager.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint("创建漫画文件夹时发生错误:\(error)")
            }
        }
        
    }
    
    
    static func getImage(fileName: String, imageName: String) -> UIImage? {
        var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        documentsPath.append("/\(ImageUtils.documentName)")
        documentsPath.append("/\(fileName.replacingOccurrences(of: "/", with: "-"))")

        documentsPath.append("/\(imageName)")
        if FileManager.default.fileExists(atPath: documentsPath) {
            do {
                let fileUrl = URL.init(fileURLWithPath: documentsPath)
                let imgData = try Data.init(contentsOf: fileUrl)
                return UIImage.init(data: imgData)
            } catch {
                debugPrint(error)
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    static func saveImage(image: UIImage,withFileName fileName: String, withName imageName: String) {
        var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let fileManager = FileManager.default
        
        documentsPath.append("/\(ImageUtils.documentName)")
        
        documentsPath.append("/\(fileName.replacingOccurrences(of: "/", with: "-"))")
        
        if fileManager.fileExists(atPath: documentsPath) {
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            do {
                let fileUrl = URL.init(fileURLWithPath: documentsPath.appending("/\(imageName)"))
                
                if !fileManager.fileExists(atPath: documentsPath.appending("/\(imageName)")) {
                    debugPrint("本地存储图片，位于\(documentsPath)")
                    try imageData?.write(to: fileUrl, options: Data.WritingOptions.atomic)
                }
                
            } catch {
                debugPrint(error)
            }
        } else {
            do {
                try fileManager.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
                let imageData = UIImageJPEGRepresentation(image, 0.7)
                do {
                    let fileUrl = URL.init(fileURLWithPath: documentsPath.appending("/\(imageName)"))
                    print(fileUrl)
                    try imageData?.write(to: fileUrl, options: Data.WritingOptions.atomic)
                } catch {
                    debugPrint(error)
                }
            } catch {
                debugPrint(error)
            }
        }
    }
}
