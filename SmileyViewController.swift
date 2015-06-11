//
//  SmileyViewController.swift
//  Smiley
//
//  Created by Bernhard Kraft on 08.06.15.
//  Copyright (c) 2015 bfk engineering. All rights reserved.
//

import UIKit

class SmileyViewController: UIViewController, faceViewDataSource {
    
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "changeHappiness:"))
        }
        
    }
 
    var happiness: Int = 60 {//0:very sad ... 100: ecstatic
        didSet {
            happiness = min(max(happiness, 0),100)
            updateUI()
        }
    }

    func updateUI() {
        faceView.setNeedsDisplay()
    }
    
//    evaluates the panned distance in relation to face radius. Will ignore x-axis movements, 
//    look at y-axis only
    func changeHappiness (gesture: UIPanGestureRecognizer){
        var startYLocation: CGFloat = 0
        
        switch gesture.state{
        case .Began:
            startYLocation = gesture.translationInView(faceView).y
        case .Changed:
            happiness += Int((startYLocation - gesture.translationInView(faceView).y)/( 10 * faceView.faceRadius) * -100)
        default:
            break
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness - 50)/50
    }
}