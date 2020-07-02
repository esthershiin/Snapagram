//
//  CameraViewController.swift
//  Snapagram
//
//  Created by RJ Pimentel on 3/11/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet weak var postThisPicButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var imageChosen = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePreview.isHidden = true
        postThisPicButton.isEnabled = false
        self.isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imagePreview.isHidden = true
        postThisPicButton.isEnabled = false
    }
    
    @IBAction func cameraButtonWasPressed(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @IBAction func libraryButtonWasPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func postNowButtonWasPressed(_ sender: Any){
        performSegue(withIdentifier: "CameraToMakePostSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MakePostViewController {
            dest.imageToUpload = imageChosen
        }
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePreview.image = image
            imageChosen = image
            imagePreview.isHidden = false
            postThisPicButton.isEnabled = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
