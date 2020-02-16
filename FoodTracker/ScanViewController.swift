//
//  ScanViewController.swift
//  FoodTracker
//
//  Created by Katrina Jiao on 2020/2/14.
//  Copyright © 2020 Katrina Jiao. All rights reserved.
//

import SwiftUI
import UIKit
import Vision
import CoreML


class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var percentage: UITextView!
    
    @IBOutlet weak var btnChooseImage: UIButton!
    
    var productCatalog = ProductCatalog()
    let fruitNames = ["acerolas", "apples", "apricots", "avocados", "bananas", "blackberries", "blueberries", "cantaloupes", "cherries", "coconuts", "figs", "grapefruits", "grapes", "guava", "honneydew_melon", "kiwifruit", "lemons", "limes", "mangos", "nectarine", "olives", "onion", "oranges", "passionfruit", "peaches", "pears", "pineapples", "plums", "pomegranates", "potato", "raspberries", "strawberries", "tomatoes", "watermelons"]
    var vgg = VGGNorm()
    
    
    func showInfo(for payload: String) {
        if let product = productCatalog.item(forKey: payload) {
            print(payload)
            showAlert(withTitle: product.name ?? "No product name provided", message: payload)
        } else {
            showAlert(withTitle: "No item found for this payload", message: "")
        }
    }
    
    var imagePicker = UIImagePickerController()
    /*
    lazy var barcodeRequest = VNDetectBarcodesRequest(completionHandler: { request, error in

        guard let results = request.results else { return }

        // Loopm through the found results
        if let bestResult = request.results?.first as? VNBarcodeObservation,
            let payload = bestResult.payloadStringValue {
            self.showInfo(for: payload)
            print(payload)
        } else {
            self.showAlert(withTitle: "Unable to extract results",
                           message: "Cannot extract barcode information from data.")
        }
        
        for result in results {
            
            // Cast the result to a barcode-observation
            
            if let barcode = result as? VNBarcodeObservation {
                
                // Print barcode-values
                print("Symbology: \(barcode.symbology.rawValue)")
                if let payload = barcode.payloadStringValue {
                    print("payload is \(payload)")
                }
                //currently useless
                /*if let desc = barcode.barcodeDescriptor as? CIQRCodeDescriptor {
                    let content = String(data: desc.errorCorrectedPayload, encoding: .utf8)
                    
                    // FIXME: This currently returns nil. I did not find any docs on how to encode the data properly so far.
                    print("Payload: \(String(describing: content))")
                    print("Error-Correction-Level: \(desc.errorCorrectionLevel)")
                    print("Symbol-Version: \(desc.symbolVersion)")
                }*/
            }
        }
    })
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imgProfile.layer.borderWidth = 0
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfile.layer.cornerRadius = imgProfile.bounds.width/2
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        self.btnChooseImage.layer.cornerRadius = 5
    }
    
    @IBAction func btnChooseImageOnClick(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }


//MARK: - UIImagePickerControllerDelegate


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imgProfile.image = editedImage
            processImage(editedImage)
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    
    func processImage(_ image: UIImage) {

        let vegfruit = VegFruit()
        let size = CGSize(width: 250, height: 250)

        guard let buffer = image.resize(to: size)?.pixelBuffer()
            else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }

        
        guard let result = try? self.vgg.prediction(image: buffer)
            else {
            fatalError("VGG feature extraction failed!")
        }
        print(result.output.shape)
        print(MLMultiArray.toDoubleArray(result.output))
        guard let pred = try? vegfruit.prediction(input: VegFruitInput(features: result.output))
            else {
            fatalError("VGG feature extraction failed!")
        }
        
        let probs = MLMultiArray.toDoubleArray(pred.output)
        print(probs)
        let (index, val) = argmax(probs)
        
        let converted = String(format: "%.2f", val*100)

        self.percentage.text = "\(fruitNames[index]) - \(converted) %"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

