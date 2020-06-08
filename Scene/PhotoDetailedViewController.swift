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
        imagedDetailed?.image = imageFromCollection
        navigationController?.title = titleName
        navigationItem.title = titleName
        imagedDetailed?.enableZoom()
    }
    
}
