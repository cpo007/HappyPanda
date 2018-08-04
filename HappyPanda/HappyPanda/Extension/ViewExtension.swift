//
//  ViewExtension.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2018/5/23.
//  Copyright © 2018年 cpo007@qq.com. All rights reserved.
//

import UIKit



extension UIView {
    @IBInspectable
    var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var boardColor:UIColor {
        set {
            layer.borderColor = newValue.cgColor
            layer.masksToBounds = true
        }
        
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        
    }
    
    @IBInspectable
    var shadowRadius:CGFloat {
        set {
            layer.shadowRadius = newValue
            layer.masksToBounds = true
        }
        
        get {
            return layer.shadowRadius
        }
        
    }
    
    @IBInspectable
    var shadowColor:UIColor {
        set {
            layer.shadowColor = newValue.cgColor
            layer.masksToBounds = true
        }
        
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        
    }
    
    @IBInspectable
    var shadowOffset:CGSize {
        set {
            layer.shadowOffset = newValue
            layer.masksToBounds = true
        }
        
        get {
            return layer.shadowOffset
        }
        
    }
    
    @IBInspectable
    var shadowOpacity:Float {
        set {
            layer.shadowOpacity = newValue
            layer.masksToBounds = true
        }
        get {
            return layer.shadowOpacity
        }
        
    }
    
    
    func addOnClickListener(target: AnyObject, action: Selector) -> UITapGestureRecognizer {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
        return gr
    }
    
    func addOnLongClickListener(target: AnyObject, action: Selector) -> UILongPressGestureRecognizer {
        let gr = UILongPressGestureRecognizer(target: target, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
        return gr
    }
    
    
    func addOnClickListener(target: AnyObject, action: Selector, tapNumber:Int)-> UITapGestureRecognizer {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = tapNumber
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
        return gr
    }
    
    func addPanListener(target: AnyObject, action: Selector)-> UIPanGestureRecognizer {
        let gr = UIPanGestureRecognizer(target: target, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
        return gr
    }
    
    
    func radius(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    var width: CGFloat {
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
        get {
            return self.frame.size.height
        }
    }
    
    var x: CGFloat {
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var centerX: CGFloat {
        set {
            var point = self.center
            point.x = newValue
            self.center = point
        }
        get {
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            var point = self.center
            point.y = newValue
            self.center = point
        }
        get {
            return self.center.y
        }
    }
    
    var left: CGFloat{
        set {
            var rect = self.frame as CGRect
            rect.origin.x = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var right: CGFloat{
        set {
            var rect = self.frame as CGRect
            rect.origin.x = newValue - self.frame.size.width
            self.frame = rect
        }
        get{
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var top: CGFloat {
        set {
            var rect = self.frame as CGRect
            rect.origin.y = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var bottom: CGFloat {
        set {
            var rect = self.frame as CGRect
            rect.origin.y = newValue - self.frame.size.height
            self.frame = rect
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    var origin: CGPoint {
        set {
            self.frame.origin = newValue
        }
        get{
            return self.frame.origin
        }
    }
    
    var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            return self.frame.size
        }
        
    }
    
    
    func removeAllSubviews(){
        let subviews = self.subviews
        for subview in subviews  {
            subview.removeFromSuperview()
        }
    }
    
    
}



extension UIButton {
    
    enum ButtonEdgeInsetsStyle {
        case top  //image在上 label在下
        case bottom //image在下 label 在上
        case left //image在左 label 在右
        case right //image在右 label 在左
    }
    
    func layoutButtonWithEdgeInsetsStyle(style: ButtonEdgeInsetsStyle, space: CGFloat) {
        
        let imageWidth = imageView?.frame.width ?? 0
        let imageHeight = imageView?.frame.height ?? 0
        
        var labelWidth: CGFloat = 0
        var labelHeight: CGFloat = 0
        
        if #available(iOS 8.0, *) {
            labelWidth = titleLabel?.intrinsicContentSize.width ?? 0
            labelHeight = titleLabel?.intrinsicContentSize.height ?? 0
        } else {
            labelWidth = titleLabel?.frame.width ?? 0
            labelHeight = titleLabel?.frame.height ?? 0
        }
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        switch style {
        case .top :
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space / 2, right: 0)
        case .left :
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: space/2.0)
        case .bottom :
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWidth, bottom: 0, right: 0)
        case .right :
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-space/2.0, bottom: 0, right: imageWidth+space/2.0)
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}


extension String{
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
}

