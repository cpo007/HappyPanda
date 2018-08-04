//
//  Color.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/21.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
func UIColorFromRGBA(rgbValue: UInt ,alpha :Float) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha)
    )
}

class Color {
    
    //F13B75 in xib
    //    public static let Navigation = UIColorFromRGB(rgbValue: 0xE91E63)
    public static let deepCyan = RGB(red: 186, green: 223, blue: 241)
    public static let cyan = RGB(red: 227, green: 246, blue: 255)
    public static let lightBlue = RGB(red: 47, green: 180, blue: 225)
    public static let lightGreen = RGB(red: 142, green: 213, blue: 91)
    public static let lightOrange = RGB(red: 253, green: 153, blue: 0)
    public static let backgroundColor = RGB(red: 247, green: 248, blue: 249)
    public static let lineColor = RGB(red: 227, green: 228, blue: 229)
    public static let lineNavigationColor = RGB(red: 177, green: 228, blue: 253)
    
    
    public static let darkCyan = RGB(red: 125, green: 205, blue: 202)
    public static let lightYellow = RGB(red: 251, green: 188, blue: 43)
    public static let orange = RGB(red: 244, green: 160, blue: 96)
    public static let pink = RGB(red: 242, green: 116, blue: 127)
    public static let purple = RGB(red: 107, green: 87, blue: 114)
    
    public static let ace = RGB(red: 89, green: 88, blue: 117)


    public static let Navigation = UIColorFromRGB(rgbValue: 0x30B4FF)
    public static let button = UIColorFromRGB(rgbValue: 0xE91E63)
    public static let White1Alpha05 = UIColor(white: 1, alpha: 0.05)
    public static let LiveColor = UIColorFromRGB(rgbValue: 0xE91E63)
    public static let White = UIColorFromRGB(rgbValue: 0xFFFFFF)
    public static let LandingAgreeHighTextColor = UIColorFromRGB(rgbValue: 0xEFEFEF)
    public static let BiographyTextColor = UIColorFromRGB(rgbValue: 0x4A90E2)
    public static let MessageBubbleColor = UIColor.clear
    public static let MessageBubbleHighColor = UIColor.clear
    public static let callButtonGreen = RGB(red: 76, green: 205, blue: 85)
    public static let selectedText = UIColor.white
    public static let text = UIColor.black
    public static let textDisabled = UIColor.gray
    public static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
    public static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
    public static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
    public static let sundaySelectionBackground = sundayText
    
    class func createImageWithColor(color :UIColor)->UIImage
    {
        let rect=CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage ?? UIImage()
    }
    
}

//颜色便利构造
func RGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red / 255, green: green / 255 , blue: blue / 255, alpha: 1)
}


//  随机颜色
func RandomColor() -> UIColor {
    return RGB(red: CGFloat(arc4random() % 256), green: CGFloat(arc4random() % 256), blue: CGFloat(arc4random() % 256))
}

func createImage(color: UIColor) -> UIImage? {
    let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
    
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

