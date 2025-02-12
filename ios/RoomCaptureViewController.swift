//
//  RoomCaptureViewController.swift
//  RoomPlanApp
//
//  Created by Water on 2/4/25.
//

import Foundation
import UIKit
import RoomPlan

class RoomCaptureViewController: UIViewController, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {
  
  @IBOutlet var exportButton: UIButton?
  
  @IBOutlet var doneButton: UIBarButtonItem?
  @IBOutlet var cancelButton: UIBarButtonItem?
  @IBOutlet var activityIndicator: UIActivityIndicatorView?
  
  private var isScanning: Bool = false
  
  private var roomCaptureView: RoomCaptureView!
  private var roomCaptureSessionConfig: RoomCaptureSession.Configuration = RoomCaptureSession.Configuration()
  
  private var finalResults: CapturedRoom?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up after loading the view.
    
    // Add a close button
    let closeButton = UIButton(type: .system)
    closeButton.setTitle("Close", for: .normal)
    closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    closeButton.frame = CGRect(x: 20, y: 50, width: 100, height: 40)
    view.addSubview(closeButton)
    
    let doneButton = UIButton(type: .system)
    doneButton.setTitle("Done", for: .normal)
    doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    doneButton.frame = CGRect(x: self.view.frame.size.width - 120, y: 50, width: 100, height: 40)
    view.addSubview(doneButton)
    
    
    self.exportButton = UIButton(type: .system)
    self.exportButton!.setTitle("Export", for: .normal)
    self.exportButton!.addTarget(self, action: #selector(exportResults), for: .touchUpInside)
    self.exportButton!.frame = CGRect(x: (self.view.frame.size.width / 2) - 50, y: self.view.frame.size.height - 140, width: 100, height: 40)
    view.addSubview(self.exportButton!)
    
    setupRoomCaptureView()
    activityIndicator?.stopAnimating()
  }
  @objc func closeTapped() {
    dismiss(animated: true, completion: nil)
  }
  @objc func doneTapped() {
    if isScanning { stopSession() } else { closeTapped() }
    self.exportButton?.isEnabled = false
    self.activityIndicator?.startAnimating()
  }
  
  
  private func setupRoomCaptureView() {
    roomCaptureView = RoomCaptureView(frame: view.bounds)
    roomCaptureView.captureSession.delegate = self
    roomCaptureView.delegate = self
    
    view.insertSubview(roomCaptureView, at: 0)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    startSession()
  }
  
  override func viewWillDisappear(_ flag: Bool) {
    super.viewWillDisappear(flag)
    stopSession()
  }
  
  private func startSession() {
    isScanning = true
    roomCaptureView?.captureSession.run(configuration: roomCaptureSessionConfig)
    
    setActiveNavBar()
  }
  
  private func stopSession() {
    isScanning = false
    roomCaptureView?.captureSession.stop()
    
    setCompleteNavBar()
  }
  
  // Decide to post-process and show the final results.
  func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
    return true
  }
  
  // Access the final post-processed results.
  func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
    finalResults = processedResult
    self.exportButton?.isEnabled = true
    self.activityIndicator?.stopAnimating()
  }
  
  @IBAction func doneScanning(_ sender: UIBarButtonItem) {
    if isScanning { stopSession() } else { cancelScanning(sender) }
    self.exportButton?.isEnabled = false
    self.activityIndicator?.startAnimating()
  }
  
  @IBAction func cancelScanning(_ sender: UIBarButtonItem) {
    navigationController?.dismiss(animated: true)
  }
  
  // Export the USDZ output by specifying the `.parametric` export option.
  // Alternatively, `.mesh` exports a nonparametric file and `.all`
  // exports both in a single USDZ.
  @objc @IBAction func exportResults(_ sender: UIButton) {
    let destinationFolderURL = FileManager.default.temporaryDirectory.appending(path: "Export")
    let destinationURL = destinationFolderURL.appending(path: "Room.usdz")
    let capturedRoomURL = destinationFolderURL.appending(path: "Room.json")
    do {
      try FileManager.default.createDirectory(at: destinationFolderURL, withIntermediateDirectories: true)
      let jsonEncoder = JSONEncoder()
      let jsonData = try jsonEncoder.encode(finalResults)
      try jsonData.write(to: capturedRoomURL)
      try finalResults?.export(to: destinationURL, exportOptions: .parametric)
      
      let activityVC = UIActivityViewController(activityItems: [destinationFolderURL], applicationActivities: nil)
      activityVC.modalPresentationStyle = .popover
      
      present(activityVC, animated: true, completion: nil)
      if let popOver = activityVC.popoverPresentationController {
        popOver.sourceView = self.exportButton
      }
    } catch {
      print("Error = \(error)")
    }
  }
  
  private func setActiveNavBar() {
    UIView.animate(withDuration: 1.0, animations: {
      self.cancelButton?.tintColor = .white
      self.doneButton?.tintColor = .white
      self.exportButton?.alpha = 0.0
    }, completion: { complete in
      self.exportButton?.isHidden = true
    })
  }
  
  private func setCompleteNavBar() {
    self.exportButton?.isHidden = false
    UIView.animate(withDuration: 1.0) {
      self.cancelButton?.tintColor = .systemBlue
      self.doneButton?.tintColor = .systemBlue
      self.exportButton?.alpha = 1.0
    }
  }
}

