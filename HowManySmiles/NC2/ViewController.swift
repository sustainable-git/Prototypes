//
//  ViewController.swift
//  NC2
//
//  Created by Shin Jae Ung on 2022/08/26.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var session: AVCaptureSession?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    var image: UIImage!
    private let shutterButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.layer.addSublayer(self.previewLayer)
        self.view.addSubview(self.shutterButton)
        self.shutterButton.addTarget(self, action: #selector(self.didTapTakePhoto), for: .touchUpInside)
        self.checkCameraPermissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = view.bounds
        self.setShutterButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let visionViewController = segue.destination as? VisionViewController else { return }
        visionViewController.image = self.image
    }
    
    private func setShutterButton() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        let sizeBarometer: Double = min(width, height) / 5
        self.shutterButton.frame.size.width = sizeBarometer
        self.shutterButton.frame.size.height = sizeBarometer
        self.shutterButton.layer.cornerRadius = sizeBarometer/2
        self.shutterButton.layer.borderWidth = sizeBarometer/20
        self.shutterButton.center = CGPoint(x: width/2, y: height - sizeBarometer)
    }
    
    @objc private func didTapTakePhoto() {
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case.notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async { self?.setUpCamera() }
            }
        case .restricted: break
        case .denied: break
        case .authorized: self.setUpCamera()
        default: break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) { session.addInput(input) }
                if session.canAddOutput(output) { session.addOutput(output) }
                self.previewLayer.videoGravity = .resizeAspectFill
                self.previewLayer.session = session
                session.startRunning()
                self.session = session
            } catch {
                print(error)
            }
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        self.image = UIImage(data: data)
        self.performSegue(withIdentifier: "Vision", sender: self)
    }
}
