//
//  ImagePicker.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 2/2/2565 BE.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelectImage(image: UIImage?, imagePicker: ImagePicker, base64: String)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private var sourceType: [UIImagePickerController.SourceType?]
    
    public init(presentationController: UIViewController, sourceType: [UIImagePickerController.SourceType?], delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        self.sourceType = sourceType
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        self.sourceType.forEach({ type in
            switch type {
            case .camera:
                if let action = setActionType(type: .camera , title: "ถ่ายภาพ") {
                    alertController.addAction(action)
                }
                break
            case .photoLibrary:
                if let action = setActionType(type: .photoLibrary , title: "เลือกจากอัลบั้ม") {
                    alertController.addAction(action)
                }
                break
            case .savedPhotosAlbum:
                if let action = setActionType(type: .savedPhotosAlbum , title: "Camera roll") {
                    alertController.addAction(action)
                }
                break
            default:
                break
            }
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func setActionType(type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        if let action = self.action(for: type, title: title) {
            return action
        } else {
            return nil
        }
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        presentationController?.startLoding()
        if let base64 = image?.convertImageToBase64String(quality: 0.7) {
            self.delegate?.didSelectImage(image: image, imagePicker: self, base64: base64)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.presentationController?.stopLoding()
            }
        } else {
            presentationController?.stopLoding()
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
