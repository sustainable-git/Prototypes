//
//  VisionViewController.swift
//  NC2
//
//  Created by Shin Jae Ung on 2022/08/31.
//

import UIKit
import Vision

class VisionViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    var image: UIImage?
    var imageOrientation = CGImagePropertyOrientation(.up)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.start()
    }
    
    private func start() {
        guard imageView != nil else { return }
        if let image = image {
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFit
            self.imageOrientation = CGImagePropertyOrientation(image.imageOrientation)
            
            guard let cgImage = image.cgImage else { return }
            
            self.setupVision(image: cgImage)
        }
    }
    
    private func setupVision(image: CGImage) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaceDetectionRequest)
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: imageOrientation, options: [:])
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch let error as NSError {
            print(error)
            return
        }
    }
    
    private func handleFaceDetectionRequest(request: VNRequest?, error: Error?) {
        if let requestError = error as NSError? {
            print(requestError)
            return
        }
        guard let cgImage = imageView.image?.cgImage else { return }
        
        let imageRect = self.determineScale(cgImage: cgImage, imageViewFrame: imageView.frame)
        self.imageView.layer.sublayers = nil
        self.imageView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        if let results = request?.results as? [VNFaceObservation] {
            for observation in results {
                let faceRect = convertUnitToPoint(originalImageRect: imageRect, targetRect: observation.boundingBox)
                let emojiRect = CGRect(
                    x: faceRect.origin.x,
                    y: faceRect.origin.y - 5,
                    width: faceRect.size.width + 5,
                    height: faceRect.size.height + 5
                )
                
                let label = UILabel()
                label.text = "😀"
                label.font = .systemFont(ofSize: emojiRect.width)
                label.frame = emojiRect
                label.adjustsFontSizeToFitWidth = true
                self.imageView.addSubview(label)
            }
            self.label.text = "총 \(results.count)명"
        }
    }
}
