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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let motionManager = CMMotionManager()
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1

        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { (motion, error) in
            guard error == nil else {
                print(error)
                return
            }

            guard let motion = motion else {
                print("motion equal nil")
                return
            }

            print("attitude pitch: \(motion.attitude.pitch)")
            print("attitude roll : \(motion.attitude.roll)")
            print("attitude yaw  : \(motion.attitude.yaw)")
        })
    }
}
