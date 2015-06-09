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
    var scaleFactor: CGFloat = 0.8 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var color: UIColor = UIColor.blueColor() {didSet {setNeedsDisplay()}}
    @IBInspectable
    var smiliness: CGFloat = 0.0 {didSet {setNeedsDisplay()}}//between -1 and +1
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    let eyeToFaceFactor: CGFloat = 0.15
    let eyeWidthFactor: CGFloat = 0.4 //between 0 and 1
    let eyeHeightFactor: CGFloat = 0.35 //between
    let mouthControlPointSeparator: CGFloat = 0.3
    let smilinessDamper: CGFloat = 0.3

    var faceRadius: CGFloat {
        return min(bounds.width, bounds.height)/2
    }

    var eyeRadius: CGFloat {
        return faceRadius * eyeToFaceFactor * scaleFactor
    }
    
    var leftEyeCenter: CGPoint {
        return CGPoint (x: faceCenter.x - eyeWidthFactor * faceRadius * scaleFactor, y: faceCenter.y - eyeHeightFactor * faceRadius * scaleFactor)
    }
    var rightEyeCenter: CGPoint {
        return CGPoint (x: faceCenter.x + eyeWidthFactor * faceRadius * scaleFactor, y: faceCenter.y - eyeHeightFactor * faceRadius * scaleFactor)
    }
    
    var mouthYBaseline: CGFloat {
        return faceCenter.y + eyeHeightFactor * faceRadius * scaleFactor
    }
    
    var mouthControlPoint1: CGPoint {
        return CGPoint (x: faceCenter.x - mouthControlPointSeparator * faceRadius * scaleFactor, y: mouthYBaseline + smiliness * scaleFactor * faceRadius * smilinessDamper)
    }
    var mouthControlPoint2: CGPoint {
        return CGPoint (x: faceCenter.x + mouthControlPointSeparator * faceRadius * scaleFactor, y: mouthYBaseline + smiliness * scaleFactor * faceRadius * smilinessDamper)
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius * scaleFactor, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        let leftEyePath = UIBezierPath(arcCenter: leftEyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        leftEyePath.lineWidth = lineWidth
        color.set()
        leftEyePath.stroke()

        let rightEyePath = UIBezierPath(arcCenter: rightEyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        rightEyePath.lineWidth = lineWidth
        color.set()
        rightEyePath.stroke()

        //the mouth
        let mouthPath = UIBezierPath()
        mouthPath.moveToPoint(CGPoint(x: leftEyeCenter.x - eyeRadius , y: mouthYBaseline))
        mouthPath.addCurveToPoint(CGPoint(x: rightEyeCenter.x + eyeRadius, y: mouthYBaseline), controlPoint1: mouthControlPoint1, controlPoint2: mouthControlPoint2)
        mouthPath.lineWidth = lineWidth
        color.set()
        mouthPath.stroke()
        
    }


}
