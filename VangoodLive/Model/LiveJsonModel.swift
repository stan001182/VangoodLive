//
//  LiveJsonModel.swift
//  VangoodLive
//
//  Created by Stan on 2022/3/29.
//

import Foundation

class DataStruct {
    
    struct MyJSONModel: Codable {
        let event: String?      // 事件類型
        let room_id: String?    // 房間ID
        let sender_role: Int?   // 發話者來源
        let body: BodyResult?   // 內容，依據事件類型結構可能都不同
        let time: String?       // 時間戳
    }
    
    struct BodyResult: Codable {
        let chat_id: String?
        let nickname: String?
        let type: String?
        let text: String?
        let info: InfoResult?
        let entry_notice: Entry_noticeResult?
        let real_count: Int?
        let content: ContentResult?
        
    }
    
    struct InfoResult: Codable {
        let info: Int?
    }
    
    struct Entry_noticeResult: Codable {
        let username: String?
        let action: String?
        let room_count: Int?
        let real_count: Int?
    }
    
    struct ContentResult: Codable {
        let cn: String?
        let en: String?
        let tw: String?
    }
    
}

struct SearchResponse: Codable {
    var result: ResultDate
}

struct ResultDate: Codable {
    var lightyear_list: [Live]
    var stream_list: [Live]
}

struct Live: Codable {
    var stream_title: String
    var nickname: String
    var head_photo: String
    var tags: String
    var online_num: Int
    var background_image: String
    var streamer_id : Int
}

class stream_list{
    static func parseJson<T:Codable>(_ data: Data) -> T? {
        let decode = JSONDecoder()
        do {
            return try decode.decode(T.self, from: data)
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static let liveJson: Data = """
   [
         {
           "stream_id": 5007,
           "streamer_id": 88952,
           "stream_title": "下午好",
           "status": 2,
           "open_at": 1646716949,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "凌晨🌛",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645517728.png",
           "tags": "女神",
           "online_num": 5216,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645517798.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5018,
           "streamer_id": 89030,
           "stream_title": "感冒不大能說話",
           "status": 2,
           "open_at": 1646720663,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "跳跳",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644428619.png",
           "tags": "疗愈系,性感",
           "online_num": 5043,
           "game": "SICBO-PAOFSC-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644428867.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5012,
           "streamer_id": 88927,
           "stream_title": "大口吃肉肉",
           "status": 2,
           "open_at": 1646719122,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "肉肉",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644397286.png",
           "tags": "大秀,疗愈系",
           "online_num": 5025,
           "game": "E5-PAOE5-1",
           "charge": 10,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644397298.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5015,
           "streamer_id": 88928,
           "stream_title": "水水姑娘回来到",
           "status": 2,
           "open_at": 1646719585,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "水水",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644397354.png",
           "tags": "陪玩,哥哥快来",
           "online_num": 5008,
           "game": "LT-PAO1MLT-1",
           "charge": 50,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644397369.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5019,
           "streamer_id": 4,
           "stream_title": "你的小可爱已上线",
           "status": 2,
           "open_at": 1646720723,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "乐乐",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1646720583.png",
           "tags": "疗愈系,哥哥快来",
           "online_num": 5028,
           "game": "SICBO-PAOFSC-1",
           "charge": 10,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1646720599.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5003,
           "streamer_id": 88992,
           "stream_title": "暖暖",
           "status": 2,
           "open_at": 1646716192,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "暖暖",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644324926.png",
           "tags": "疗愈系,女神",
           "online_num": 5132,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644578697.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 4971,
           "streamer_id": 89056,
           "stream_title": "福利群介绍",
           "status": 2,
           "open_at": 1646701205,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "直播小帮手",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645294011.png",
           "tags": "中国好声音",
           "online_num": 7742,
           "game": "PK-PAOPK-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645294024.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5010,
           "streamer_id": 88961,
           "stream_title": "燕窩",
           "status": 2,
           "open_at": 1646717698,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "燕子",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644385399.png",
           "tags": "",
           "online_num": 5100,
           "game": "E5-PAOE5-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5008,
           "streamer_id": 88996,
           "stream_title": "新主播",
           "status": 2,
           "open_at": 1646717002,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "安苡萱",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644390202.png",
           "tags": "",
           "online_num": 5217,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644389880.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5020,
           "streamer_id": 89033,
           "stream_title": "一起冒險",
           "status": 2,
           "open_at": 1646721083,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "小檸檬",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644481213.png",
           "tags": "可盐可甜,哥哥快来",
           "online_num": 5016,
           "game": "SC-PAO1MSC-1",
           "charge": 3,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 4972,
           "streamer_id": 89057,
           "stream_title": "道具卡介绍",
           "status": 2,
           "open_at": 1646701332,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "直播小帮手",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645122865.png",
           "tags": "中国好声音",
           "online_num": 15342,
           "game": "SICBO-PAOFSC-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645122818.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5013,
           "streamer_id": 88999,
           "stream_title": "可比",
           "status": 2,
           "open_at": 1646719140,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "可比",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644377119.png",
           "tags": "哥哥快来",
           "online_num": 5240,
           "game": "LT-PAO1MLT-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644377383.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5016,
           "streamer_id": 88954,
           "stream_title": "❤❤❤",
           "status": 2,
           "open_at": 1646719748,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "妍淨",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644471854.png",
           "tags": "女神,高颜值",
           "online_num": 5024,
           "game": "LT-PAO1MLT-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5007,
           "streamer_id": 88952,
           "stream_title": "下午好",
           "status": 2,
           "open_at": 1646716949,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "凌晨🌛",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645517728.png",
           "tags": "女神",
           "online_num": 5216,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645517798.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5014,
           "streamer_id": 88976,
           "stream_title": "快三",
           "status": 2,
           "open_at": 1646719149,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "佳佳",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645797071.png",
           "tags": "带投",
           "online_num": 5034,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644333668.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5011,
           "streamer_id": 88975,
           "stream_title": "Hi",
           "status": 2,
           "open_at": 1646719057,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "Bee",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645682209.png",
           "tags": "陪玩",
           "online_num": 5110,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644346570.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5017,
           "streamer_id": 88903,
           "stream_title": "來",
           "status": 2,
           "open_at": 1646720546,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "錢錢",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644337896.png",
           "tags": "带投,嫩模",
           "online_num": 5005,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644338003.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5015,
           "streamer_id": 88928,
           "stream_title": "水水姑娘回来到",
           "status": 2,
           "open_at": 1646719585,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "水水",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644397354.png",
           "tags": "陪玩,哥哥快来",
           "online_num": 5008,
           "game": "LT-PAO1MLT-1",
           "charge": 50,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644397369.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5013,
           "streamer_id": 88999,
           "stream_title": "可比",
           "status": 2,
           "open_at": 1646719140,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "可比",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644377119.png",
           "tags": "哥哥快来",
           "online_num": 5240,
           "game": "LT-PAO1MLT-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644377383.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5019,
           "streamer_id": 4,
           "stream_title": "你的小可爱已上线",
           "status": 2,
           "open_at": 1646720723,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "乐乐",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1646720583.png",
           "tags": "疗愈系,哥哥快来",
           "online_num": 5028,
           "game": "SICBO-PAOFSC-1",
           "charge": 10,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1646720599.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5018,
           "streamer_id": 89030,
           "stream_title": "感冒不大能說話",
           "status": 2,
           "open_at": 1646720663,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "跳跳",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644428619.png",
           "tags": "疗愈系,性感",
           "online_num": 5043,
           "game": "SICBO-PAOFSC-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644428867.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5011,
           "streamer_id": 88975,
           "stream_title": "Hi",
           "status": 2,
           "open_at": 1646719057,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "Bee",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645682209.png",
           "tags": "陪玩",
           "online_num": 5110,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644346570.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5007,
           "streamer_id": 88952,
           "stream_title": "下午好",
           "status": 2,
           "open_at": 1646716949,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "凌晨🌛",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645517728.png",
           "tags": "女神",
           "online_num": 5216,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645517798.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5016,
           "streamer_id": 88954,
           "stream_title": "❤❤❤",
           "status": 2,
           "open_at": 1646719748,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "妍淨",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644471854.png",
           "tags": "女神,高颜值",
           "online_num": 5024,
           "game": "LT-PAO1MLT-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5014,
           "streamer_id": 88976,
           "stream_title": "快三",
           "status": 2,
           "open_at": 1646719149,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "佳佳",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645797071.png",
           "tags": "带投",
           "online_num": 5034,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644333668.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5010,
           "streamer_id": 88961,
           "stream_title": "燕窩",
           "status": 2,
           "open_at": 1646717698,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "燕子",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644385399.png",
           "tags": "",
           "online_num": 5100,
           "game": "E5-PAOE5-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5012,
           "streamer_id": 88927,
           "stream_title": "大口吃肉肉",
           "status": 2,
           "open_at": 1646719122,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "肉肉",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644397286.png",
           "tags": "大秀,疗愈系",
           "online_num": 5025,
           "game": "E5-PAOE5-1",
           "charge": 10,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644397298.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 4971,
           "streamer_id": 89056,
           "stream_title": "福利群介绍",
           "status": 2,
           "open_at": 1646701205,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "直播小帮手",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645294011.png",
           "tags": "中国好声音",
           "online_num": 7742,
           "game": "PK-PAOPK-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645294024.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5020,
           "streamer_id": 89033,
           "stream_title": "一起冒險",
           "status": 2,
           "open_at": 1646721083,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "小檸檬",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644481213.png",
           "tags": "可盐可甜,哥哥快来",
           "online_num": 5016,
           "game": "SC-PAO1MSC-1",
           "charge": 3,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5003,
           "streamer_id": 88992,
           "stream_title": "暖暖",
           "status": 2,
           "open_at": 1646716192,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "暖暖",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644324926.png",
           "tags": "疗愈系,女神",
           "online_num": 5132,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644578697.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5008,
           "streamer_id": 88996,
           "stream_title": "新主播",
           "status": 2,
           "open_at": 1646717002,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "安苡萱",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644390202.png",
           "tags": "",
           "online_num": 5217,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644389880.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 4972,
           "streamer_id": 89057,
           "stream_title": "道具卡介绍",
           "status": 2,
           "open_at": 1646701332,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "直播小帮手",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645122865.png",
           "tags": "中国好声音",
           "online_num": 15342,
           "game": "SICBO-PAOFSC-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645122818.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5017,
           "streamer_id": 88903,
           "stream_title": "來",
           "status": 2,
           "open_at": 1646720546,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "錢錢",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644337896.png",
           "tags": "带投,嫩模",
           "online_num": 5005,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644338003.png",
           "open_attention": true,
           "open_guardians": false
         }
       ]

""".data(using: .utf8)!
    
}

class lightyear_list{
    static func parseJson<T:Codable>(_ data: Data) -> T? {
        let decode = JSONDecoder()
        do {
            return try decode.decode(T.self, from: data)
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static let liveJson: Data = """
   [
         {
           "stream_id": 5015,
           "streamer_id": 88928,
           "stream_title": "水水姑娘回来到",
           "status": 2,
           "open_at": 1646719585,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "水水",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644397354.png",
           "tags": "陪玩,哥哥快来",
           "online_num": 5008,
           "game": "LT-PAO1MLT-1",
           "charge": 50,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644397369.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5013,
           "streamer_id": 88999,
           "stream_title": "可比",
           "status": 2,
           "open_at": 1646719140,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "可比",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644377119.png",
           "tags": "哥哥快来",
           "online_num": 5240,
           "game": "LT-PAO1MLT-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644377383.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5019,
           "streamer_id": 4,
           "stream_title": "你的小可爱已上线",
           "status": 2,
           "open_at": 1646720723,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "乐乐",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1646720583.png",
           "tags": "疗愈系,哥哥快来",
           "online_num": 5028,
           "game": "SICBO-PAOFSC-1",
           "charge": 10,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1646720599.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5018,
           "streamer_id": 89030,
           "stream_title": "感冒不大能說話",
           "status": 2,
           "open_at": 1646720663,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "跳跳",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644428619.png",
           "tags": "疗愈系,性感",
           "online_num": 5043,
           "game": "SICBO-PAOFSC-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644428867.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5011,
           "streamer_id": 88975,
           "stream_title": "Hi",
           "status": 2,
           "open_at": 1646719057,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "Bee",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645682209.png",
           "tags": "陪玩",
           "online_num": 5110,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644346570.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5007,
           "streamer_id": 88952,
           "stream_title": "下午好",
           "status": 2,
           "open_at": 1646716949,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "凌晨🌛",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645517728.png",
           "tags": "女神",
           "online_num": 5216,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645517798.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5016,
           "streamer_id": 88954,
           "stream_title": "❤❤❤",
           "status": 2,
           "open_at": 1646719748,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "妍淨",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644471854.png",
           "tags": "女神,高颜值",
           "online_num": 5024,
           "game": "LT-PAO1MLT-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5014,
           "streamer_id": 88976,
           "stream_title": "快三",
           "status": 2,
           "open_at": 1646719149,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "佳佳",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645797071.png",
           "tags": "带投",
           "online_num": 5034,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644333668.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5010,
           "streamer_id": 88961,
           "stream_title": "燕窩",
           "status": 2,
           "open_at": 1646717698,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "燕子",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644385399.png",
           "tags": "",
           "online_num": 5100,
           "game": "E5-PAOE5-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5012,
           "streamer_id": 88927,
           "stream_title": "大口吃肉肉",
           "status": 2,
           "open_at": 1646719122,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "肉肉",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644397286.png",
           "tags": "大秀,疗愈系",
           "online_num": 5025,
           "game": "E5-PAOE5-1",
           "charge": 10,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644397298.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 4971,
           "streamer_id": 89056,
           "stream_title": "福利群介绍",
           "status": 2,
           "open_at": 1646701205,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "直播小帮手",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645294011.png",
           "tags": "中国好声音",
           "online_num": 7742,
           "game": "PK-PAOPK-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645294024.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5020,
           "streamer_id": 89033,
           "stream_title": "一起冒險",
           "status": 2,
           "open_at": 1646721083,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "小檸檬",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644481213.png",
           "tags": "可盐可甜,哥哥快来",
           "online_num": 5016,
           "game": "SC-PAO1MSC-1",
           "charge": 3,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube-dev/develop/1/backgroundImage/preset.jpg",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5003,
           "streamer_id": 88992,
           "stream_title": "暖暖",
           "status": 2,
           "open_at": 1646716192,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "暖暖",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644324926.png",
           "tags": "疗愈系,女神",
           "online_num": 5132,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644578697.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 5008,
           "streamer_id": 88996,
           "stream_title": "新主播",
           "status": 2,
           "open_at": 1646717002,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "安苡萱",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644390202.png",
           "tags": "",
           "online_num": 5217,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644389880.png",
           "open_attention": true,
           "open_guardians": false
         },
         {
           "stream_id": 4972,
           "streamer_id": 89057,
           "stream_title": "道具卡介绍",
           "status": 2,
           "open_at": 1646701332,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "直播小帮手",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1645122865.png",
           "tags": "中国好声音",
           "online_num": 15342,
           "game": "SICBO-PAOFSC-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1645122818.png",
           "open_attention": true,
           "open_guardians": true
         },
         {
           "stream_id": 5017,
           "streamer_id": 88903,
           "stream_title": "來",
           "status": 2,
           "open_at": 1646720546,
           "closed_at": 0,
           "deleted_at": 0,
           "start_time": 0,
           "nickname": "錢錢",
           "head_photo": "https://storage.googleapis.com/lottcube/production/1/headphoto/headphoto1644337896.png",
           "tags": "带投,嫩模",
           "online_num": 5005,
           "game": "Q3-PAOQ3-1",
           "charge": 0,
           "group_id": 0,
           "background_image": "https://storage.googleapis.com/lottcube/production/1/backgroundImage/backgroundImage1644338003.png",
           "open_attention": true,
           "open_guardians": false
         }
       ]

""".data(using: .utf8)!
    
}
