//
//  NetworkManager.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/14/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import AuthenticationServices
import Spartan

class NetworkManager{
    //make it singleton
    public static let shared = NetworkManager()
    private init() {}
    //properties
    static let urlSession = URLSession.shared // shared singleton session object used to run tasks. Will be useful later
    static private let baseURL = "https://accounts.spotify.com/"
    static private var parameters: [String: String] = [:]
    static let clientID = "4fc72d1cb09e4eecbcb849ed0236dc1f"
    static let redirectURI = URL(string: "micromuse://")
    static let clientSecret = "666cfb93d2294c44a88f5c3056568a69"
    static private let defaults = UserDefaults.standard
    
    static var totalCount: Int = Int.max
    static var codeVerifier: String = ""
    
    //MARK: Tokens
    static var accessToken = UserDefaults.standard.string(forKey: Constants.accessTokenKey) {
        didSet { UserDefaults.standard.set(accessToken, forKey: Constants.accessTokenKey) }
    }
    static var refreshToken = UserDefaults.standard.string(forKey: Constants.refreshTokenKey) {
        didSet { UserDefaults.standard.set(refreshToken, forKey: Constants.refreshTokenKey) }
    }
    
    var accessToken = UserDefaults.standard.string(forKey: Constants.accessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: Constants.accessTokenKey)
        }
    }
    
    //MARK: Configurtion
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Constants.clientID, redirectURL: Constants.redirectURI!)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    //MARK: Fetch Access Token
    static func fetchAccessToken(){
        
    }
    
    //MARK: Refresh Access Token
    static func refreshAccessToken(){
        
    }
    
    //MARK: Fetch User
    static func fetchUser(){
        
    }
    
}
