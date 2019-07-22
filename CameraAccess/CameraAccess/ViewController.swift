//
//  ViewController.swift
//  CameraAccess
//
//  Created by Adakhanau on 11/07/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                
            } else {
                
            }
        }
    }
    
  
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
    }
        


    
    @IBAction func savePhotoButton(_ sender: Any) {
        guard let selectedImage = imageView.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func takePhotoButton(_ sender: Any) {

        //Camera
        
        selectImageFrom(.camera)


//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            selectImageFrom(.photoLibrary)
//            return
//        }
    }
    
    @IBAction func pickPhotoButton(_ sender: Any) {
        selectImageFrom(.photoLibrary)

    }
    
    
}


extension ViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imageView.image = selectedImage
    }
}

