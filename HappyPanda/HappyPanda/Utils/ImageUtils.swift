//
//  ImageUtils.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/8/4.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

public struct ImageUtils {
    
    static func loadNoteImageWithName(imageName: String) -> UIImage! {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imagePath = documentsPath.appending("/\(imageName)")
        
        if FileManager.default.fileExists(atPath: imagePath) {
            return UIImage(data: NSData(contentsOfFile: imagePath)! as Data)!
        }
        else {
            return nil
        }
    }
    
    static func saveImage(image: UIImage, withName imageName: String!) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        do {
            try imageData?.write(to: URL.init(string: documentsPath.appending("/\(imageName)"))!, options: Data.WritingOptions.atomic)
        } catch {
            debugPrint(error)
        }
//        imageData?.writeToFile(documentsPath.stringByAppendingString("/\(imageName)"), atomically: true)
    }
}
