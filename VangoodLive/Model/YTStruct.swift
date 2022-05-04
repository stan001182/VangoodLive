//
//  YTStruct.swift
//  VangoodLive
//
//  Created by Stan_Tseng on 2022/4/26.
//

import Foundation


struct CommonData{
    let ApiKeys = "AIzaSyAjobrU4_61vzS3xZBK2Ft4KNMvKXraQ_Y"
    let channelID = "UC345x_D7DgK5313D3ftM_EQ"
    let playlistID = "UU345x_D7DgK5313D3ftM_EQ"
    let maxResult = 25
}

//頻道資訊
struct ChannelResponse:Codable{
    let items: [channelInfo]?
}

struct channelInfo:Codable{
    let id: String?
    let snippet: snippetinfo?
    let contentDetails: relatedPlaylists?
}

struct snippetinfo:Codable{
    let title: String?
    let description: String?
    let thumbnails: thumbnailsinfo?
}

struct thumbnailsinfo: Codable{
    let `default`: defaultinfo?
}

struct defaultinfo: Codable{
    let url: String?
}

struct relatedPlaylists:Codable{
 let relatedPlaylists: linksAndUploads?
}

struct linksAndUploads:Codable{
    let links: String?
    let uploads: String?
}

//影片清單資訊
struct PlayListResponse:Codable{
    let items: [videoInfo]?
}

struct videoInfo:Codable{
    let id: String?
    let snippet: videosnippetinfo?
    let contentDetails: videorelatedPlaylists?
}

struct videosnippetinfo:Codable{
    let title: String?
    let description: String?
}

struct videorelatedPlaylists:Codable{
    let videoId: String?
}
