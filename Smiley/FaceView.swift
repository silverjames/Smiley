//
//  FaceView.swift
//  Smiley
//
//  Created by Bernhard Kraft on 04.06.15.
//  Copyright (c) 2015 bfk engineering. All rights reserved.
//

import UIKit

protocol faceViewDataSource: class {
    func smilinessForFaceView(sender:FaceView) ->Double?
}

@IBDesignable
class FaceView: UIView {

//  Inspectable properties
    @IBInspectable
    var scaleFactor: CGFloat = 0.8 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var color: UIColor = UIColor.blueColor() {didSet {setNeedsDisplay()}}
    
    //  constants, structs and delegates
    let eyeToFaceFactor: CGFloat = 0.15
    let eyeWidthFactor: CGFloat = 0.4 //between 0 and 1
    let eyeHeightFactor: CGFloat = 0.35 //between
    let mouthControlPointSeparator: CGFloat = 0.3
    let smilinessDamper: CGFloat = 0.3
    
    private enum Eye {
        case Left, Right
    }
    
    private enum ControlPoints {
        case CP1, CP2
    }
    
    weak var dataSource: faceViewDataSource?
    
//  computed properties
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
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
    
    

//    public methods
    override func drawRect(rect: CGRect) {
//        the face
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius * scaleFactor, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
//      the eyes
        getEyePath(.Left).stroke()
        getEyePath(.Right).stroke()
 

//        the mouth
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        
        let mouthPath = UIBezierPath()
        mouthPath.moveToPoint(CGPoint(x: leftEyeCenter.x - eyeRadius , y: mouthYBaseline))
        mouthPath.addCurveToPoint(CGPoint(x: rightEyeCenter.x + eyeRadius, y: mouthYBaseline), controlPoint1: getControlPoint(.CP1, smiliness: smiliness), controlPoint2: getControlPoint(.CP2, smiliness: smiliness))
        mouthPath.lineWidth = lineWidth
        color.set()
        mouthPath.stroke()
        
//        the playpen
//        var context: CGContextRef = UIGraphicsGetCurrentContext()
        
    }
    
//  private functions supporting drawRect
    private func getControlPoint(cp: ControlPoints, smiliness: Double) -> CGPoint{
        var xFactor: CGFloat
        
        switch cp {
        case .CP1:
            xFactor = -1 * mouthControlPointSeparator * faceRadius * scaleFactor
        case .CP2:
            xFactor = mouthControlPointSeparator * faceRadius * scaleFactor
        }
        let yFactor = mouthYBaseline +  scaleFactor * faceRadius * smilinessDamper * CGFloat(smiliness)
        return CGPoint(x: faceCenter.x + xFactor, y: yFactor)
    }
    
    private func getEyePath(eye: Eye) ->UIBezierPath{
        var center: CGPoint
        
        switch eye {
        case .Left:
            center = leftEyeCenter
        case .Right:
            center = rightEyeCenter
        }

        let path = UIBezierPath(arcCenter: center, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        color.set()
        return path

    }
    
//    gesture handlers
    func scale (gesture: UIPinchGestureRecognizer){
        
        switch gesture.state{
        case .Changed:
            scaleFactor *= gesture.scale
            print("pinch recognized, scale is: \(gesture.scale)")
            gesture.scale = 1
        default:
            break
        }
        
        
    }
    


}
