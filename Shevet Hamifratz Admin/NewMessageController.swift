//
//  NewMessageController.swift
//  Shevet Hamifratz Admin
//
//  Created by Alon Katz on 1/29/18.
//  Copyright © 2018 Shevet Hamifratz. All rights reserved.
//

import UIKit
import CropViewController
import Firebase
import FirebaseStorage

class NewMessageController: UIViewController, CropViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var image: UIImage?
    
    private var croppingStyle = CropViewCroppingStyle.default
    
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var inputsView: UIView!
    
    @IBOutlet weak var finalImageView: UIImageView!
    
    @IBOutlet weak var uploadView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var articleTitle: UITextField!
    
    @IBOutlet weak var articleContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

            inputsView.layer.cornerRadius = 10
        articleContent.placeholder = "Article Content"
       
        finalImageView.layer.masksToBounds = true
        finalImageView.layer.cornerRadius = 10
        
        finalImageView.isHidden = true
        
        uploadView.layer.cornerRadius = 10
    uploadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        let origImage = UIImage(named: "back2");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    
    
    // Image Controller
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = false
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: CropViewCroppingStyle.default, image: image)
        cropController.delegate = self
        cropController.aspectRatioPreset = .presetCustom
        cropController.customAspectRatio = CGSize(width: 332, height: 200)
        cropController.aspectRatioPreset = .presetCustom
        cropController.aspectRatioLockEnabled = true
        
        self.image = image
        
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//
//            selectedImageFromPicker = originalImage
//        }
//
//        if let selectedImage = selectedImageFromPicker {
//            print("hello world")
//            let cropViewController = CropViewController(image: selectedImage)
//            cropViewController.delegate = self
//            present(cropViewController, animated: true, completion: nil)
//
//
//        }
        
       
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
        
       // dismiss(animated: true, completion: nil)
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        finalImageView.isHidden = false
        finalImageView.image = image
        
        
        
        //self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
          //  articleImageView.isHidden = true
             cropViewController.dismiss(animated: true, completion: nil)
            
//            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
//                                                   toView: imageView,
//                                                   toFrame: CGRect.zero,
//                                                   setup: { self.layoutImageView() },
//                                                   completion: { self.imageView.isHidden = false })
        }
        else {
           // self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func publishPressed(_ sender: UIButton) {
        let ref = Database.database().reference()
        let imageName = UUID().uuidString
        let articleName = UUID().uuidString
        
        let title = articleTitle.text
        let content = articleContent.text
    
        
        let articlesReference = ref.child("articles").child(articleName)
        
        let storageRef = Storage.storage().reference().child("articleImages").child("\(imageName).png")
        let uploadData = UIImageJPEGRepresentation(self.finalImageView.image!, 0.5)
        //
        storageRef.putData(uploadData!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error!)
            }
            
            let date = (Int)(NSDate().timeIntervalSince1970)
            
            if let imageUrl = metadata?.downloadURL()?.absoluteString{
                
                
                let article = ["title": title, "content": content, "articleImageUrl": imageUrl, "date": date] as [String : Any]
                
                articlesReference.updateChildValues(article, withCompletionBlock: { (err, ref) in
                   
                    if err != nil {
                        print(err!)
                        return
                    }
                    
                })
            }
            
            
            
        }
        //        if let profileImage = self.image{
        //
        
        
        
        
    }
    

}


extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor(r: 209, g: 209, b: 214)
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
    
    
    
    
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


