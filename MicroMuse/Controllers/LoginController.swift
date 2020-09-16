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

class LoginController: UIViewController{
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    
    @IBOutlet weak var loginButton: UIButton!
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func authorize(){
        
    }
    
    //MARK: Action
    @IBAction func login(_ sender: Any) {
        //        guard let sessionManager = sessionManager else { return }
        //        if #available(iOS 11, *) {
        //          // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
        //          sessionManager.initiateSession(with: scopes, options: .clientOnly)
        //        } else {
        //          // Use this on iOS versions < 11 to use SFSafariViewController
        //          sessionManager.initiateSession(with: scopes, options: .clientOnly, presenting: self)
        //        }
    }
    
}

//MARK: Extensions

// MARK: - SPTAppRemoteDelegate
//extension ViewController: SPTAppRemoteDelegate {
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        updateViewBasedOnConnected()
//        appRemote.playerAPI?.delegate = self
//        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
//            if let error = error {
//                print("Error subscribing to player state:" + error.localizedDescription)
//            }
//        })
//        fetchPlayerState()
//    }
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        updateViewBasedOnConnected()
//        lastPlayerState = nil
//    }
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        updateViewBasedOnConnected()
//        lastPlayerState = nil
//    }
//}
//// MARK: - SPTAppRemotePlayerAPIDelegate
//extension ViewController: SPTAppRemotePlayerStateDelegate {
//  func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//    debugPrint("Spotify Track name: %@", playerState.track.name)
//    update(playerState: playerState)
//  }
//}

// MARK: - SPTSessionManagerDelegate
extension LoginController: SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate{
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        <#code#>
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        <#code#>
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        <#code#>
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        <#code#>
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
      if error.localizedDescription == "The operation couldn’t be completed. (com.spotify.sdk.login error 1.)" {
        print("AUTHENTICATE with WEBAPI")
      } else {
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
      }
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
      presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
      appRemote.connectionParameters.accessToken = session.accessToken
      appRemote.connect()
    }
    
    
}
