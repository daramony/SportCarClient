//
//  SportCarRequester.swift
//  SportCarClient
//
//  Created by 黄延 on 15/12/15.
//  Copyright © 2015年 WoodyHuang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class SportCarURLMaker: AccountURLMaker {
    static let sharedMaker = SportCarURLMaker(user: nil)
    
    func querySportCar()->String{
        return website + "/cars/querybyname"
    }
    
    func followSportCar(carID: String) -> String {
        return website + "/cars/\(carID)/follow"
    }
    
    func getAuthedCarList(userID: String) -> String {
        return website + "/profile/\(userID)/authed_cars"
    }
}


class SportCarRequester: AccountRequester {
    
    static let sharedSCRequester = SportCarRequester()
    
    /**
     根据生产商和汽车的名字检索跑车对象并返回详细信息
     
     - parameter manufacturer: 生产商名称
     - parameter carName:      车型名称
     - parameter onSuccess:    成功以后调用这个
     - parameter onError:      失败以后调用这个
     */
    func querySportCarWith(manufacturer: String, carName: String, onSuccess: (data: JSON)->(), onError: (code: String?)->()){
        let urlStr = SportCarURLMaker.sharedMaker.querySportCar()
        self.manager.request(.GET, urlStr, parameters: ["manufacturer": manufacturer, "car_name": carName]).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                if json["success"].boolValue {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        onSuccess(data: json["data"])
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        onError(code: json["code"].string)
                    })
                }
                break
            case .Failure(let error):
                print("\(error)")
                break
            }
        }
    }
    
    /**
     关注某一辆汽车，但是并不认证
     
     - parameter signature: 跑车签名
     - parameter carId:     跑车id
     - parameter onSuccess: 成功以后调用这个
     - parameter onError:   失败以后调用这个
     */
    func postToFollow(signature:String?, carId: String, onSuccess: ()->(), onError: (code: String?)->()) {
        let urlStr = SportCarURLMaker.sharedMaker.followSportCar(carId)
       
        self.manager.request(.POST, urlStr, parameters: ["signature": signature ?? ""]).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                if json["success"].boolValue {
                    dispatch_async(dispatch_get_main_queue(), onSuccess)
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        onError(code: json["code"].string)
                    })
                }
                break
            case .Failure(let error):
                print("\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    onError(code: "0000")
                })
                break
            }
        }
    }
    
    /**
     获取某个用户经过认证的所有跑车的信息
     
     - parameter userID:    用户uid
     - parameter onSuccess: 成功以后调用这个
     - parameter onError:   失败以后调用这个
     */
    func getAuthedCarsList(userID: String, onSuccess: (JSON?)->(), onError: (code: String?)->()) {
        let urlStr = SportCarURLMaker.sharedMaker.getAuthedCarList(userID)
        
        self.manager.request(.GET, urlStr).responseJSON { (let response) -> Void in
            self.resultValueHandler(response.result, dataFieldName: "cars", onSuccess: onSuccess, onError: onError)
        }
    }
}
