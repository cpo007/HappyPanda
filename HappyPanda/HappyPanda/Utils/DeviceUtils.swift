//
//  DeviceUtils.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/8/3.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit
import AVFoundation

public struct DeviceUtils {
    
    public enum UIDeviceResolution : Int{
        // iPhone 1,3,3GS 标准分辨率(320x480px)
        case UIDevice_iPhoneStandardRes = 1
        // iPhone 4,4S 高清分辨率(640x960px)
        case UIDevice_iPhoneHiRes       = 2
        // iPhone 5 高清分辨率(640x1136px)
        case UIDevice_iPhoneTallerHiRes = 3
        // iPad 1,2 标准分辨率(1024x768px)
        case UIDevice_iPadStandardRes   = 4
        // iPad 3 High Resolution(2048x1536px)
        case UIDevice_iPadHiRes         = 5
    }
    
    public static func currentResolution() -> UIDeviceResolution {
        if(UIDevice.current.userInterfaceIdiom == .phone) {
            if(UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))) {
                var result = UIScreen.main.bounds.size
                result = CGSize(width: result.width * UIScreen.main.scale, height: result.height * UIScreen.main.scale)
                if(result.height <= 480.0) {
                    return .UIDevice_iPhoneStandardRes
                } else {
                    return (result.height > 960 ? .UIDevice_iPhoneTallerHiRes : .UIDevice_iPhoneHiRes)
                }
            } else {
                return .UIDevice_iPhoneStandardRes
            }
        } else {
            return UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) ? .UIDevice_iPadHiRes : .UIDevice_iPadStandardRes
        }
    }
    
    public static func getScreenSize() -> CGSize {
        var result = UIScreen.main.bounds.size
        if(UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))) {
            result = CGSize(width: result.width * UIScreen.main.scale, height: result.height * UIScreen.main.scale)
        }
        return result
    }
    
    public static func isRunningOniPhone5() -> Bool {
        return currentResolution() == .UIDevice_iPhoneTallerHiRes
    }
    
    public static func isRunningOniPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    
    
    public static func isIphone4() -> Bool {
        return getScreenSize().height == 960
    }
    public static func isIphone5() -> Bool {
        return getScreenSize().height == 1136
    }
    public static func isIphone6() -> Bool{
        return getScreenSize() == CGSize(width: 750, height: 1334)
    }
    public static func isIphone6Plus() -> Bool {
        return getScreenSize() == CGSize(width: 1242, height: 2208)
    }
    
    public static func isIphoneX() -> Bool {
        return (__CGSizeEqualToSize(CGSize.init(width: 375, height: 812), UIScreen.main.bounds.size) || __CGSizeEqualToSize(CGSize.init(width: 812, height: 375), UIScreen.main.bounds.size))
    }
    
    public static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    public static func isLandscape() -> Bool {
        return UIDeviceOrientationIsLandscape(UIDevice.current.orientation) || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft  || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight
    }
    public static func isIphone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    public static func frontCameraAvailable() -> Bool {
        let videoDevices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in videoDevices {
            if (device as AnyObject).position == .front {
                return true
            }
        }
        return false
    }
    
    public static func backCameraAvailable() -> Bool {
        let videoDevices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in videoDevices {
            if (device as AnyObject).position == .back {
                return true
            }
        }
        return false
    }
    
    public static func isCameraAuthorized() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
    }
    
    public static func isMicphoneAuthorized(response: PermissionBlock!) {
        return AVAudioSession.sharedInstance().requestRecordPermission(response)
    }
    
    public static func getVersion() -> String {
        if let info = Bundle.main.infoDictionary {
            if let version = info["CFBundleShortVersionString"] as? String {
                return version
            }
            return ""
        }
        return ""
    }
    
    public static func getBuildVersion() -> Int {
        if let info = Bundle.main.infoDictionary {
            if let version = info["CFBundleVersion"] as? String {
                return Int(version) ?? 0
            }
            return 0
        }
        return 0
    }
    
}
