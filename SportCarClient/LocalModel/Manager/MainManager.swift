//
//  MainManager.swift
//  SportCarClient
//
//  Created by 黄延 on 16/3/25.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//

import Foundation
import AlecrimCoreData
import CoreData
import SwiftyJSON


class MainManager {
    
    private static let _sharedMainManager = MainManager()
    
    class var sharedManager: MainManager {
        return _sharedMainManager
    }
    
    internal var mainContext: DataContext
    
    internal var _hostUser: User?
    internal var _hostUserID: Int32?
    
    internal var _workQueue: dispatch_queue_t?
    
    var workQueue: dispatch_queue_t {
        if _workQueue == nil {
            _workQueue = dispatch_get_main_queue()
        }
        return _workQueue!
    }
    
    var hostUser: User? {
        if _hostUser == nil {
            return nil
        }
        if _hostUser?.managedObjectContext != getOperationContext() {
            _hostUser = _hostUser?.toContext(getOperationContext()) as? User
        }
        return _hostUser
    }
    
    var hostUserID: Int32? {
        return _hostUserID
    }
    
    var hostUserIDString: String? {
        if _hostUserID == nil {
            return nil
        }
        return "\(hostUserID!)"
    }
    
    var jwtToken: String!
    
    init () {
        mainContext = DataContext()
    }
    
    /**
     获取操作需要的context
     
     - returns: AlecrimCoreData库的DataContext类型
     */
    func getOperationContext() -> DataContext {
        return mainContext
    }
    
    func getOrCreate<T where T : BaseModel>(data: JSON, detailLevel: Int = 0, ctx: DataContext? = nil, overwrite: Bool = true) throws -> T {
        let context = ctx ?? getOperationContext()
        let table = AlecrimCoreData.Table<T>(dataContext: context)
        let id = data[T.idField].int32Value
        if T.isKindOfClass(User.self) && id == hostUserID {
            let obj = hostUser!
            if !overwrite {
                return obj as! T
            }
            return try obj.loadDataFromJSON(data, detailLevel: detailLevel) as! T
        }
        var created: Bool = false
        let obj = table.first({$0.ssid == id && $0.hostSSID == hostUserID}) ?? {
            let obj = table.createEntity()
            obj.ssid = id
            obj.manager = self
            created = true
            return obj
        }()
        obj.manager = self
        if overwrite || created {
            try obj.loadDataFromJSON(data, detailLevel: detailLevel)
        }
        return obj
    }
    
    func createNew<T: BaseModel>(initial: JSON? = nil, ctx: DataContext? = nil) throws -> T {
        let context = ctx ?? getOperationContext()
        let table = AlecrimCoreData.Table<T>(dataContext: context)
        let newObj = table.createEntity()
        if initial != nil {
            try newObj.loadInitialFromJSON(initial!)
        }
        newObj.manager = self
        newObj.hostSSID = MainManager.sharedManager.hostUserID!
        return newObj
    }
    
    func objectWithSSID<T: BaseModel>(ssid: Int32?, ctx: DataContext? = nil) -> T? {
        if ssid == nil {
            return nil
        }
        let context = ctx ?? getOperationContext()
        let table = AlecrimCoreData.Table<T>(dataContext: context)
        let obj = table.first({ $0.ssid == ssid && $0.hostSSID == hostUserID})
        obj?.manager = self
        return obj
    }
    
    func save() throws {
//        assert(!NSThread.isMainThread(), "Do not save context on main thread")
        try mainContext.save()
    }
    
    func login(user: User, jwtToken: String) {
        if _hostUser != nil || user.managedObjectContext != getOperationContext() {
            assertionFailure()
        }
        NSUserDefaults.standardUserDefaults().setObject(user.ssidString, forKey: "host_user_id")
        NSUserDefaults.standardUserDefaults().setObject(jwtToken, forKey: "\(user.ssidString)_jwt_token")
        _hostUser = user
        _hostUserID = user.ssid
        self.jwtToken = jwtToken
        try! MainManager.sharedManager.save()
        
        // Initialize the message system
        MessageManager.defaultManager.connect()
        PermissionCheck.sharedInstance.sync()
    }
    
    func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("host_user_id")
        _hostUser = nil
        _hostUserID = nil
        MessageManager.defaultManager.disconnect()
    }
    
    func resumeLoginStatus() -> MainManager {
        if let userIDString = NSUserDefaults.standardUserDefaults().stringForKey("host_user_id") {
            guard let jwtToken = NSUserDefaults.standardUserDefaults().stringForKey("\(userIDString)_jwt_token") else {
                return self
            }
            self.jwtToken = jwtToken
            let userID = Int32(userIDString)
            if let user: User = AlecrimCoreData.Table<User>(dataContext: getOperationContext()).first({$0.ssid  == userID }) {
                user.manager = self
                login(user, jwtToken: jwtToken)
            }
        }
        return self
    }
}
