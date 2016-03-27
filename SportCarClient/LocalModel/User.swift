//
//  User.swift
//  SportCarClient
//
//  Created by 黄延 on 16/3/25.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//

import Foundation
import CoreData
import CoreData
import SwiftyJSON


class User: BaseModel {
    
    override class var idField: String {
        return "userID"
    }
    
    var avatarURL: NSURL? {
        if avatar == nil {
            return nil
        }
        return SFURL(avatar!)
    }
    
    private var _avatarCarModel: SportCar?
    var avatarCarModel: SportCar? {
        get {
            if avatarCar == nil {
                return nil
            }
            if _avatarCarModel == nil {
                let carJSON = JSON(data: avatarCar!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                _avatarCarModel = try! manager.getOrCreate(carJSON) as SportCar
            }
            return _avatarCarModel
        }
        set {
            _avatarCarModel = newValue
            avatarCar =  try! _avatarCarModel?.toJSONString(0)
        }
    }
    
    private var _avatarClubModel: Club?
    var avatarClubModel: Club? {
        get {
            if avatarClub == nil {
                return nil
            }
            if _avatarClubModel == nil {
                let clubJSON = JSON(data: avatarClub!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                _avatarClubModel = try! manager.getOrCreate(clubJSON) as Club
            }
            return _avatarClubModel
        }
        set {
            _avatarClubModel = newValue
            avatarClub = try! _avatarClubModel?.toJSONString(0)
        }
    }
    
    private var _chater: Chater?
    func toChatter() -> Chater {
        if _chater == nil {
            _chater = try! Chater().loadDataFromJSON([
                User.idField: ssidString,
                "nick_name": nickName!,
                "avatar": avatar!
                ])
        }
        return _chater!
    }

    override func loadDataFromJSON(data: JSON, detailLevel: Int, forceMainThread: Bool = false) throws -> Self {
        try super.loadDataFromJSON(data, detailLevel: detailLevel, forceMainThread: forceMainThread)
        nickName = data["nick_name"].stringValue
        avatar = data["avatar"].stringValue
        if detailLevel >= 1 {
            district = data["district"].stringValue
            gender = data["gender"].stringValue
            phoneNum = data["phoneNum"].stringValue
            starSign = data["starSign"].stringValue
            age = data["age"].int32Value
            signature = data["signature"].stringValue
            if let f = data["followed"].bool {
                followed = f
            }
            
            fansNum = data["fans_num"].int32Value
            followsNum = data["follow_num"].int32Value
            statusNum = data["status_num"].int32Value
            
            let carJSON = data["avatar_car"]
            if carJSON.isExists() {
                avatarCar = carJSON.rawString()
                _avatarCarModel = try manager.getOrCreate(carJSON) as SportCar
            } else {
                avatarCar = nil
                _avatarCarModel = nil
            }
            
            let clubJSON = data["avatar_club"]
            if clubJSON.isExists() {
                avatarClub = clubJSON.rawString()
                _avatarClubModel = try manager.getOrCreate(clubJSON) as Club
            } else {
                avatarClub = nil
                _avatarClubModel = nil
            }
        }
        
        return self
    }
    
    override func toJSONObject(detailLevel: Int) throws -> JSON {
        if detailLevel > 0 {
            assertionFailure("Not supported")
        }
        let json = [User.idField: ssidString, "nick_name": nickName!, "avatar": avatar!] as JSON
        return json
    }
    // MARK: 一下是User自己的Utility函数
    var isHost: Bool {
        return ssid == manager.hostUserID
    }

}