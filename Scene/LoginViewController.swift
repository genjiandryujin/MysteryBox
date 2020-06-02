//
//  LoginViewController.swift
//  SandBox
//
//  Created by iZE Appsynth on 1/6/2563 BE.
//  Copyright © 2563 iZE Appsynth. All rights reserved.
//

import UIKit
import LocalAuthentication

enum AuthenticationState {
    case loggedin, loggedout
}


class LoginViewController: UIViewController {
    
    var context = LAContext()
    
    var state = AuthenticationState.loggedout {
        didSet {
//            loginButton.isHighlighted = state == .loggedin
//            stateView.backgroundColor = state == .loggedin ? .green : .red
//            faceIDLabel.isHidden = (state == .loggedin) || (context.biometryType != .faceID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
    }
    
    @IBAction func loginDidTap(_ sender: Any) {
        
        if state == .loggedin {
            state = .loggedout
        } else {
            context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    if success {
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                            self.showModal()
                        }
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")
            }
            
        }
        
    }
    
    func showModal() {
//        let loginSuccess = MainViewController()
//        loginSuccess.modalPresentationStyle = .fullScreen
//        present(loginSuccess, animated: true, completion: nil)
        
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        newViewController?.modalTransitionStyle = .crossDissolve
        newViewController?.modalPresentationStyle = .fullScreen
        self.present(newViewController!, animated: true, completion: nil)
        
    }
    
}
