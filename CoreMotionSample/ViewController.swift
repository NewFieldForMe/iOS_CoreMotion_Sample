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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1

        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { (motion, error) in
            guard let motion = motion, error == nil else { return }

            print("attitude pitch: \(motion.attitude.pitch * 180 / Double.pi)")
            print("attitude roll : \(motion.attitude.roll * 180 / Double.pi)")
            print("attitude yaw  : \(motion.attitude.yaw * 180 / Double.pi)")
        })
    }
}
