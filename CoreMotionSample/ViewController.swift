//
//  ViewController.swift
//  CoreMotionSample
//
//  Created by yamada.ryo on 2019/12/10.
//  Copyright © 2019 yamada.ryo. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let motionManager = CMMotionManager()
    weak var circleView: UIView?
    weak var targetView: UIView?
    var goalCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetView()
        addCircleView()

        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1 / 100

        motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: OperationQueue.current!, withHandler: { [weak self] (motion, error) in
            guard let motion = motion, error == nil else { return }
            guard let strongSelf = self else { return }

            let xAngle = motion.attitude.roll * 180 / Double.pi
            let yAngle = motion.attitude.pitch * 180 / Double.pi

            let coefficient: CGFloat = 0.5

            print("attitude pitch: \(motion.attitude.pitch * 180 / Double.pi)")
            print("attitude roll : \(motion.attitude.roll * 180 / Double.pi)")
            print("attitude yaw  : \(motion.attitude.yaw * 180 / Double.pi)")

            strongSelf.circleView?.addX(CGFloat(xAngle) * coefficient)
            strongSelf.circleView?.addY(CGFloat(yAngle) * coefficient)

            strongSelf.judgeGoal()
        })
    }

    func addCircleView() {
        let size: CGFloat = 32.0
        let circleView = UIView()
        circleView.frame = CGRect(x:0, y:0 ,width: size, height:size)
        circleView.backgroundColor = UIColor.blue
        circleView.layer.cornerRadius = size / 2
        self.view.addSubview(circleView)
        self.circleView = circleView
    }

    func addTargetView() {
        let size: CGFloat = 48.0
        let targetView = UIView()
        targetView.frame = CGRect(x:0, y:0 ,width: size, height:size)
        targetView.backgroundColor = UIColor.gray
        targetView.layer.cornerRadius = size / 2
        var frame = targetView.frame
        frame.origin.x = CGFloat.random(in: view.frame.minX..<view.frame.maxX - frame.width)
        frame.origin.y = CGFloat.random(in: view.frame.minY..<view.frame.maxY - frame.height)
        targetView.frame = frame
        view.addSubview(targetView)
        self.targetView = targetView
        view.sendSubviewToBack(targetView)
    }

    func judgeGoal() {
        if let targetView = targetView, let circleView = circleView,
            targetView.frame.contains(circleView.frame) {
            goalCount += 1
            if goalCount <= 5 {
                targetView.removeFromSuperview()
                addTargetView()
            } else {
                motionManager.stopDeviceMotionUpdates()
            }
        }
    }
}

extension UIView {
    func addX(_ x: CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x += x
        if let superViewFrame = superview?.frame {
            if superViewFrame.minX > frame.origin.x {
                frame.origin.x = superViewFrame.minX
            } else if superViewFrame.maxX - frame.width < frame.origin.x {
                frame.origin.x = superViewFrame.maxX - frame.width
            }
        }
        self.frame = frame
    }

    func addY(_ y: CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y += y
        if let superViewFrame = superview?.frame {
            if superViewFrame.minY > frame.origin.y {
                frame.origin.y = superViewFrame.minY
            } else if superViewFrame.maxY - frame.height < frame.origin.y {
                frame.origin.y = superViewFrame.maxY - frame.height
            }
        }
        self.frame = frame
    }
}
