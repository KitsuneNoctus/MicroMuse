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
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        <#code#>
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        <#code#>
    }
    
    
    var responseTypeCode: String? {
        didSet {
            fetchSpotifyToken { (dictionary, error) in
                if let error = error {
                    print("Fetching token request error \(error)")
                    return
                }
                let accessToken = dictionary!["access_token"] as! String
                DispatchQueue.main.async {
                    self.appRemote.connectionParameters.accessToken = accessToken
                    self.appRemote.connect()
                }
            }
        }
    }
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    var accessToken = UserDefaults.standard.string(forKey: Constants.accessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: Constants.accessTokenKey)
        }
    }
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: spotifyClientId, redirectURL: Constants.redirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    lazy var sessionManager: SPTSessionManager? = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    private var lastPlayerState: SPTAppRemotePlayerState?
    
    
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
        let sessionManager = sessionManager
        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            sessionManager.initiateSession(with: Constants.scopes, options: .clientOnly)
        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
            sessionManager.initiateSession(with: Constants.scopes, options: .clientOnly, presenting: self)
        }
        let nextVC = TabHomeController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: POST Request///fetch Spotify access token. Use after getting responseTypeCode
    func fetchSpotifyToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
      let url = URL(string: "https://accounts.spotify.com/api/token")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((Constants.clientID + ":" + Constants.clientSecret).data(using: .utf8)!.base64EncodedString())"
      request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey, "Content-Type": "application/x-www-form-urlencoded"]
      do {
        var requestBodyComponents = URLComponents()
        let scopeAsString = Constants.stringScopes.joined(separator: " ") //put array to string separated by whitespace
        requestBodyComponents.queryItems = [URLQueryItem(name: "client_id", value: Constants.clientID), URLQueryItem(name: "grant_type", value: "authorization_code"), URLQueryItem(name: "code", value: responseTypeCode!), URLQueryItem(name: "redirect_uri", value: Constants.redirectURI?.absoluteString), URLQueryItem(name: "code_verifier", value: ""), URLQueryItem(name: "scope", value: scopeAsString),]
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data,                            // is there data
          let response = response as? HTTPURLResponse,  // is there HTTP response
          (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
          error == nil else {                           // was there no error, otherwise ...
            print("Error fetching token \(error?.localizedDescription ?? "")")
            return completion(nil, error)
          }
          let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
          print("Access Token Dictionary=", responseObject ?? "")
          completion(responseObject, nil)
        }
        task.resume()
      } catch {
        print("Error JSON serialization \(error.localizedDescription)")
      }
    }
    
}

//MARK: Extensions

//// MARK: - SPTAppRemoteDelegate
extension LoginController: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        <#code#>
    }
    
    
}
//  func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//    updateViewBasedOnConnected()
//    appRemote.playerAPI?.delegate = self
//    appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
//      if let error = error {
//        print("Error subscribing to player state:" + error.localizedDescription)
//      }
//    })
//    fetchPlayerState()
//  }
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//    updateViewBasedOnConnected()
//    lastPlayerState = nil
//  }
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//    updateViewBasedOnConnected()
//    lastPlayerState = nil
//  }
//}
//// MARK: - SPTAppRemotePlayerAPIDelegate
//extension LoginController: SPTAppRemotePlayerStateDelegate {
//  func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//    debugPrint("Spotify Track name: %@", playerState.track.name)
//    update(playerState: playerState)
//  }
//}

// MARK: - SPTSessionManagerDelegate
extension LoginController: SPTSessionManagerDelegate {
  func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
    if error.localizedDescription == "The operation couldn’t be completed. (com.spotify.sdk.login error 1.)" {
      print("AUTHENTICATE with WEBAPI")
    } else {
        print(error)
//      presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }
  }
  
  func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//    presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
  }
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
    appRemote.connectionParameters.accessToken = session.accessToken
    appRemote.connect()
  }
}
