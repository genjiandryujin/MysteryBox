//
//  PhotoDetailedViewController.swift
//  SandBox
//
//  Created by iZE Appsynth on 7/6/2563 BE.
//  Copyright © 2563 iZE Appsynth. All rights reserved.
//

import UIKit

public class PhotoDetailedViewController: UIViewController {
    
    @IBOutlet weak var imagedDetailed: UIImageView?
    
    var imageFromCollection = UIImage()
    var titleName = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        imagedDetailed?.image = imageFromCollection
        imagedDetailed?.enableZoom()
        navigationItem.title = titleName
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icBack"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(backDidtap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "lockic"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(lockPhotoDidtap))
    }
    
    @objc private func backDidtap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func lockPhotoDidtap() {
        print("lockPhotoDidtap")
    }
    
}
