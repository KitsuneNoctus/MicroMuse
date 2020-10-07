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
import Foundation

class NetworkManager{
    //make it singleton
    public static let shared = NetworkManager()
    private init() {}
    //properties
    static let urlSession = URLSession.shared // shared singleton session object used to run tasks. Will be useful later
    static private let baseURL = "https://accounts.spotify.com/"
    static private var parameters: [String: String] = [:]
    
    static let clientID = "4fc72d1cb09e4eecbcb849ed0236dc1f"
    static let redirectURI = "micromuse://"
    static let clientSecret = "666cfb93d2294c44a88f5c3056568a69"
    
    static private let defaults = UserDefaults.standard
    
    static var totalCount: Int = Int.max
    static var codeVerifier: String = ""
    
    //MARK: Scopes
    static let scopes: SPTScope = [.userReadEmail, .userReadPrivate,
                                   .userReadPlaybackState, .userModifyPlaybackState,
                                   .userReadCurrentlyPlaying, .streaming, .appRemoteControl,
                                   .playlistReadCollaborative, .playlistModifyPublic, .playlistReadPrivate, .playlistModifyPrivate,
                                   .userLibraryModify, .userLibraryRead,
                                   .userTopRead, .userReadPlaybackState, .userReadCurrentlyPlaying,
                                   .userFollowRead, .userFollowModify,]//remove scopes you don't need
    
    static let stringScopes = ["user-read-email", "user-read-private",
                               "user-read-playback-state", "user-modify-playback-state", "user-read-currently-playing",
                               "streaming", "app-remote-control",
                               "playlist-read-collaborative", "playlist-modify-public", "playlist-read-private", "playlist-modify-private",
                               "user-library-modify", "user-library-read",
                               "user-top-read", "user-read-playback-position", "user-read-recently-played",
                               "user-follow-read", "user-follow-modify",]
    
    //MARK: Tokens
    static var accessToken = UserDefaults.standard.string(forKey: Constants.accessTokenKey) {
        didSet { defaults.set(accessToken, forKey: Constants.accessTokenKey) }
    }
    
    static var authorizationCode = UserDefaults.standard.string(forKey: Constants.accessTokenKey) {
        didSet { defaults.set(authorizationCode, forKey: Constants.authorizationCodeKey) }
    }
    static var refreshToken = UserDefaults.standard.string(forKey: Constants.refreshTokenKey) {
        didSet { UserDefaults.standard.set(refreshToken, forKey: Constants.refreshTokenKey) }
    }
    
    
    //MARK: Configurtion
    static var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Constants.clientID, redirectURL: Constants.redirectURI!)
        configuration.playURI = ""
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    //MARK: Fetch Access Token
    static func fetchAccessToken(completion: @escaping (_ error: Error?) -> Void) {
        guard let code = authorizationCode else { return completion(EndPointError.missing(message: "No authorization code found.")) }
        let url = URL(string: "\(baseURL)api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((clientID + ":" + clientSecret).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        var requestBodyComponents = URLComponents()
        let scopeAsString = stringScopes.joined(separator: " ") //put array to string separated by whitespace
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code_verifier", value: codeVerifier),
            URLQueryItem(name: "scope", value: scopeAsString),
        ]
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                              // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error, otherwise ...
                return completion(EndPointError.noData(message: "No data found"))
            }
            do {
                if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]{
                    //                    print(jsonResult)
                    guard let refreshToken = jsonResult["refresh_token"] as? String else { return }
                    guard let accessToken = jsonResult["access_token"] as? String else {
                        return }
                    self.accessToken = accessToken
                    self.authorizationCode = nil
                    self.refreshToken = refreshToken
                    Spartan.authorizationToken = accessToken
                    completion(nil)
                }
                //                  if let spotifyAuth = try? decoder.decode(SpotifyAuth.self, from: data) {
                //                      self.accessToken = spotifyAuth.accessToken
                //                      self.authorizationCode = nil
                //                      self.refreshToken = spotifyAuth.refreshToken
                //  //                    Spartan.authorizationToken = spotifyAuth.accessToken
                //                      return completion(.success(spotifyAuth))
                //                  }
                completion(EndPointError.couldNotParse(message: "Failed to decode data"))
            }
        }
        task.resume()
    }
    
    //MARK: Refresh Access Token
    static func refreshAcessToken(completion: @escaping (_ error: Error?) -> Void) {
        guard let refreshToken = refreshToken else { return completion(EndPointError.missing(message: "No refresh token found.")) }
        let url = URL(string: "\(baseURL)api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((clientID + ":" + clientSecret).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: clientID),
        ]
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                              // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error, otherwise ...
                return completion(EndPointError.noData(message: "No data found"))
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase  //convert keys from snake case to camel case
            do {
                if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]{
                    print(jsonResult)
                    guard let accessToken = jsonResult["access_token"] as? String else {
                        return }
                    self.accessToken = accessToken
                    self.authorizationCode = nil
                    Spartan.authorizationToken = accessToken
                    completion(nil)
                }
                //                  if let spotifyAuth = try? decoder.decode(SpotifyAuth.self, from: data) {
                //                      self.accessToken = spotifyAuth.accessToken
                //  //                    Spartan.authorizationToken = spotifyAuth.accessToken
                //                      return completion(.success(spotifyAuth))
                //                  }
                completion(EndPointError.couldNotParse(message: "Failed to decode data"))
            }
        }
        task.resume()
    }
    
    //MARK: Fetch Users
    static func fetchUser(){
        
    }
    
    //MARK: Fetch Artists
    static func fetchTopArtists(completion: @escaping (Result<[Artist], Error>) -> Void){
        _ = Spartan.getMyTopArtists(limit: 50, offset: 0, timeRange: .mediumTerm, success: { (pagingObject) in
            completion(.success(pagingObject.items))
        }, failure: { (error) in
            completion(.failure(error))
        })
    }
    
    //MARK: Fetch Artists Top Tracks
    static func fetchTopTracks(artistId: String,completion: @escaping (Result<[Track], Error>) -> Void){
        _ = Spartan.getArtistsTopTracks(artistId: artistId, country: .us, success: { (tracks) in
            completion(.success(tracks))
       }, failure: { (error) in
        completion(.failure(error))
       })
    }
    
}
