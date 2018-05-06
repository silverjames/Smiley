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
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: Selector(("scale:"))))
            faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(SmileyViewController.changeHappiness(_:))))
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(SmileyViewController.rotate(_:))))
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
    @objc func changeHappiness (_ gesture: UIPanGestureRecognizer){
        var startYLocation: CGFloat = 0
        
        switch gesture.state{
        case .began:
            startYLocation = gesture.translation(in: faceView).y
        case .changed:
            happiness += Int((startYLocation - gesture.translation(in: faceView).y)/( 10 * faceView.faceRadius) * -100)
        default:
            break
        }
    }
    
    @objc func rotate (_ gesture: UIRotationGestureRecognizer){
        let currentTransMatrix = faceView.transform
        
        switch gesture.state{
        case .began:
            break
        case .ended:
            fallthrough
        case .changed:
            faceView.transform = currentTransMatrix.rotated(by: gesture.rotation/10)
            updateUI()
        default:
            break
        }
    
    }
    
    func smilinessForFaceView(_ sender: FaceView) -> Double? {
        return Double(happiness - 50)/50
    }
}
