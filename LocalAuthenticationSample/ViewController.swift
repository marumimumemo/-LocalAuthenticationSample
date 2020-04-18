//
//  ViewController.swift
//  LocalAuthenticationSample
//
//  Created by satoshi.marumoto on 2020/04/18.
//  Copyright © 2020 satoshi.marumoto. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
   
   @IBOutlet weak var headerView: UIView!
   @IBOutlet weak var loginStatusLabel: UILabel!
   @IBOutlet weak var button: UIButton!
   @IBOutlet weak var faceIdDescriptionLabel: UILabel!
   
   enum AuthenticationState {
       case loggedin, loggedout
   }
    
   var state: AuthenticationState = .loggedout {
       didSet {
           headerView.backgroundColor = self.state == .loggedin ? .systemGreen : .systemGray
           loginStatusLabel.text = self.state == .loggedin ? "ログイン中" : "LocalAuthenticationSample"
           button.backgroundColor = self.state == .loggedout ? .systemGreen : .systemGray
           button.setTitle(self.state == .loggedin ? "ログアウト" : "ログイン", for: .normal)
           faceIdDescriptionLabel.isHidden = state == .loggedin || context.biometryType != .faceID
       }
   }
   var context: LAContext = LAContext()

   override func viewDidLoad() {
       super.viewDidLoad()
       // context.biometryType 有効
       context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
       state = .loggedout
   }

   @IBAction func didTabLoginButton(_ sender: Any) {
       
       guard state == .loggedout else {
           state = .loggedout
           return
       }
       
       context = LAContext()
       if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
           
           let reason = "パスワードを入力してください"
           context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
               if success {
                   DispatchQueue.main.async { [unowned self] in
                       self.state = .loggedin
                   }
               } else if let laError = error as? LAError {
                   switch laError.code {
                   case .authenticationFailed:
                       break
                   case .userCancel:
                       break
                   case .userFallback:
                       break
                   case .systemCancel:
                       break
                   case .passcodeNotSet:
                       break
                   case .touchIDNotAvailable:
                       break
                   case .touchIDNotEnrolled:
                       break
                   case .touchIDLockout:
                       break
                   case .appCancel:
                       break
                   case .invalidContext:
                       break
                   case .notInteractive:
                       break
                   @unknown default:
                       break
                   }
               }
           }
       } else {
           // 生体認証ができない場合の認証画面表示
       }
   }
}

