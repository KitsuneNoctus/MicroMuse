//
//  LoginController.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/9/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import AuthenticationServices
import CryptoKit
import Spartan

class LoginController: UIViewController{
    
    var responseTypeCode: String? {
        didSet {
            NetworkManager.fetchAccessToken { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                _ = Spartan.getMe(success: { (user) in
                    // Do something with the user
                    print(user.displayName)
                    print(user.email)
                    DispatchQueue.main.async {
                        let nextVC = TabHomeController()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }, failure: { (error) in
                    print(error)
                })
            }
        }
    }
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: NetworkManager.configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = NetworkManager.accessToken
        appRemote.delegate = self
        return appRemote
      }()
    
    lazy var sessionManager: SPTSessionManager? = {
        let manager = SPTSessionManager(configuration: NetworkManager.configuration, delegate: self)
        return manager
    }()
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    //MARK: Action
    @IBAction func login(_ sender: Any) {
        if let sessionManager = sessionManager {
            if #available(iOS 11, *) {
                // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
                sessionManager.initiateSession(with: Constants.scopes, options: .clientOnly)
            } else {
                // Use this on iOS versions < 11 to use SFSafariViewController
                sessionManager.initiateSession(with: Constants.scopes, options: .clientOnly, presenting: self)
            }
        }
    }
    
}


// MARK: - SPTSessionManagerDelegate
extension LoginController: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("INitiate Session")
    }
    
  func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error)
  }
}

// MARK: - SPTAppRemoteDelegate
extension LoginController: SPTAppRemoteDelegate {
  func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
    self.appRemote.playerAPI?.pause(nil)
    self.appRemote.disconnect()
  }
  func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//    updateViewBasedOnConnected()
//    lastPlayerState = nil
    print(error)
  }
  func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
    print(error)
//    last PlayerState = nil
  }
}
