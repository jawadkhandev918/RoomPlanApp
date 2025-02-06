import Foundation
import UIKit
import RoomPlan
import React

@objc(RoomPlanModule)
class RoomPlanModule: NSObject {
    @objc func startScanning(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                reject("NO_VIEW_CONTROLLER", "Could not find root view controller", nil)
                return
            }
            
            let captureVC = RoomCaptureViewController()
            captureVC.modalPresentationStyle = .fullScreen
            rootViewController.present(captureVC, animated: true, completion: nil)
        }
    }
    
    @objc func stopScanning() {
        DispatchQueue.main.async {
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
