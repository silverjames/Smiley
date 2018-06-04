//
//  FaceView.swift
//  Smiley
//
//  Created by Bernhard Kraft on 04.06.15.
//  updated May 2018 to Swift 4.1
//
//  Copyright (c) 2015 bfk engineering. All rights reserved.
//

import UIKit

protocol faceViewDataSource: class {
    func smilinessForFaceView(_ sender:FaceView) ->Double?
}

@IBDesignable
//@objc(FaceView)
class FaceView: UIView {

//  Inspectable properties
    @IBInspectable
    var scaleFactor: CGFloat = 0.8 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var color: UIColor = UIColor.blue {didSet {setNeedsDisplay()}}
    
    //  constants, structs and delegates
    let eyeToFaceFactor: CGFloat = 0.15
    let eyeWidthFactor: CGFloat = 0.4 //between 0 and 1
    let eyeHeightFactor: CGFloat = 0.35 //between
    let mouthControlPointSeparator: CGFloat = 0.3
    let smilinessDamper: CGFloat = 0.3
    
    fileprivate enum Eye {
        case left, right
    }
    
    fileprivate enum ControlPoints {
        case cp1, cp2
    }
    
    weak var dataSource: faceViewDataSource?
    
//  computed properties
    var faceCenter: CGPoint {
        return convert(center, from: superview)
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
    override func draw(_ rect: CGRect) {
//        the face
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius * scaleFactor, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
//      the eyes
        getEyePath(.left).stroke()
        getEyePath(.right).stroke()
 

//        the mouth
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        
        let mouthPath = UIBezierPath()
        mouthPath.move(to: CGPoint(x: leftEyeCenter.x - eyeRadius , y: mouthYBaseline))
        mouthPath.addCurve(to: CGPoint(x: rightEyeCenter.x + eyeRadius, y: mouthYBaseline), controlPoint1: getControlPoint(.cp1, smiliness: smiliness), controlPoint2: getControlPoint(.cp2, smiliness: smiliness))
        mouthPath.lineWidth = lineWidth
        color.set()
        mouthPath.stroke()
        
//        the playpen
//        var context: CGContextRef = UIGraphicsGetCurrentContext()
        
    }
    
//  private functions supporting drawRect
    fileprivate func getControlPoint(_ cp: ControlPoints, smiliness: Double) -> CGPoint{
        var xFactor: CGFloat
        
        switch cp {
        case .cp1:
            xFactor = -1 * mouthControlPointSeparator * faceRadius * scaleFactor
        case .cp2:
            xFactor = mouthControlPointSeparator * faceRadius * scaleFactor
        }
        let yFactor = mouthYBaseline +  scaleFactor * faceRadius * smilinessDamper * CGFloat(smiliness)
        return CGPoint(x: faceCenter.x + xFactor, y: yFactor)
    }
    
    fileprivate func getEyePath(_ eye: Eye) ->UIBezierPath{
        var center: CGPoint
        
        switch eye {
        case .left:
            center = leftEyeCenter
        case .right:
            center = rightEyeCenter
        }

        let path = UIBezierPath(arcCenter: center, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        path.lineWidth = lineWidth
        color.set()
        return path

    }
    
//    gesture handlers
    @objc func scale (_ gesture: UIPinchGestureRecognizer){
        
        switch gesture.state{
        case .changed:
            scaleFactor *= gesture.scale
            print("pinch recognized, scale is: \(gesture.scale)")
            gesture.scale = 1
        default:
            break
        }
        
        
    }
    


}
