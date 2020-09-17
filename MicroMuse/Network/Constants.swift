//
//  Constants.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/14/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import Foundation

struct Constants{
    static let accessTokenKey = "access-token-key"
    static let clientID = "0ca05b1e477141e79eb15f6be52f502f"
    static let redirectURI = URL(string: "micromuse://")
    static let clientSecret = "3ec33deb2490422f9257ff01610eae0d"
    
    //remove scopes you don't need
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
}


