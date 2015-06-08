//
//  FaceView.swift
//  Smiley
//
//  Created by Bernhard Kraft on 04.06.15.
//  Copyright (c) 2015 bfk engineering. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var scaleFactor: CGFloat {
        return 0.9
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var color: UIColor = UIColor.blueColor() {didSet {setNeedsDisplay()}}
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return min(bounds.width, bounds.height)/2
    }

    var eyeRadius: CGFloat {
        return faceRadius * 0.1
    }
    
    var eyeYPosition: CGFloat {
        return 1/3 * bounds.height
    }
    
    var leftEyeXPosition: CGFloat {
        return 1/3 * bounds.width
    }
    
    var rightEyeXPosition: CGFloat {
        return 2/3 * bounds.width
    }
    
    var mouthControlPoint: CGPoint {
        return CGPoint (x: 0.5 * bounds.height, y: 0.75 * bounds.width)
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius * scaleFactor, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        let leftEyePath = UIBezierPath(arcCenter: CGPoint(x: leftEyeXPosition, y: eyeYPosition), radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        leftEyePath.lineWidth = lineWidth
        color.set()
        leftEyePath.stroke()

        let rightEyePath = UIBezierPath(arcCenter: CGPoint(x: rightEyeXPosition, y: eyeYPosition), radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        rightEyePath.lineWidth = lineWidth
        color.set()
        rightEyePath.stroke()

        let mouthPath = UIBezierPath()
        mouthPath.moveToPoint(CGPoint(x: leftEyeXPosition, y: 2/3 * bounds.height))
        mouthPath.addCurveToPoint(CGPoint(x: rightEyeXPosition, y: 2/3*bounds.height), controlPoint1: mouthControlPoint, controlPoint2: mouthControlPoint)
        mouthPath.lineWidth = lineWidth
        color.set()
        mouthPath.stroke()
        
    }


}
