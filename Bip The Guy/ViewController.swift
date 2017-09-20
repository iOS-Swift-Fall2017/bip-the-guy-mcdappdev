//
//  ViewController.swift
//  Bip The Guy
//
//  Created by Jimmy McDermott on 9/14/17.
//  Copyright © 2017 162 LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var imageToPunch: UIImageView!
    
    //MARK: - Properties
    private var audioPlayer = AVAudioPlayer()
    private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    //MARK: - Functions
    func animateImage() {
        let bounds = imageToPunch.bounds
        let shrinkValue: CGFloat = 60
        
        //shrink our imageToPunch by 60 pixels
        imageToPunch.bounds = CGRect(
            x: imageToPunch.bounds.origin.x + shrinkValue,
            y: imageToPunch.bounds.origin.y + shrinkValue,
            width: imageToPunch.bounds.size.width - shrinkValue,
            height: imageToPunch.bounds.size.height - shrinkValue
        )
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0.0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 10,
            options: [],
            animations: {
                self.imageToPunch.bounds = bounds
        }, completion: nil)
    }
    
    private func playSound(soundName: String, audioPlayer: inout AVAudioPlayer) {
        if let sound = NSDataAsset(name: soundName) {
            do {
                audioPlayer = try AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("Error: Couldn't be played as a sound file")
            }
            
        } else {
            print("ERROR: file \(soundName) didn't load")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
    }
    
    //MARK: - Actions
    @IBAction private func photoLibraryTapped(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction private func takePhotoTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device")
        }
    }
    
    @IBAction private func imageTapped(_ sender: UITapGestureRecognizer) {
        animateImage()
        playSound(soundName: "punchSound", audioPlayer: &audioPlayer)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageToPunch.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
}
