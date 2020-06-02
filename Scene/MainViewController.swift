//
//  MainViewController.swift
//  SandBox
//
//  Created by iZE Appsynth on 1/6/2563 BE.
//  Copyright © 2563 iZE Appsynth. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    enum StorageType {
        case userDefaults
        case fileSystem
    }
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageFromDocument: UIImageView!
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setDocument()
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
            picker.mediaTypes = ["public.image", "public.movie"]
            present(picker, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func getImageFromDocument(_ sender: Any) {
        display()
    }
    
    private func save(image: UIImage?) {
        if let buildingImage = image {
            DispatchQueue.global(qos: .background).async {
                self.store(image: buildingImage,
                           forKey: "buildingImage",
                           withStorageType: .fileSystem)
            }
        }
    }
    
    private func display() {
        DispatchQueue.global(qos: .background).async {
            if let savedImage = self.retrieveImage(forKey: "buildingImage",
                                                   inStorageType: .fileSystem) {
                DispatchQueue.main.async {
                    self.imageFromDocument.image = savedImage
                }
            }
        }
    }
    
}

extension MainViewController {
    
    //MARK:- Store Image
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    private func store(image: UIImage, forKey key: String, withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath, options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation, forKey: key)
            }
        }
    }
    
    private func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),   //contentsOfDirectory(atPath: String)
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
    
    //MARK: - File Manager
    private func setDocument() {
        let path = documentDirectory()
        print("path : \(path)")
    }

    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    
    private func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        return nil
    }
    
    private func read(fromDocumentsWithFileName fileName: String) {
        guard let filePath = self.append(toPath: self.documentDirectory(), withPathComponent: fileName) else { return }
        do {
            let savedString = try String(contentsOfFile: filePath)
            
            print(savedString)
        } catch {
            print("Error reading saved file")
        }
    }
    
    private func save(text: String, toDirectory directory: String, withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory, withPathComponent: fileName) else { return }
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        print("Save successful")
    }

}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image.image = imagePicked
            
            self.save(image: imagePicked)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

