//
//  MyOrderedDict.swift
//  SportCarClient
//
//  Created by 黄延 on 16/2/2.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//

import Foundation

class MyOrderedDict<Key: Hashable, Value> {
    var _keys: [Key] = []
    var _dict: [Key: Value] = [:]
    
    var keys: [Key] {
        return _keys
    }
    
    var count: Int {
        return _keys.count
    }
    
    subscript(key: Key) -> Value? {
        get {
            return _dict[key]
        }
        
        set {
            if newValue == nil {
                _dict.removeValueForKey(key)
                _keys.remove(key)
                return
            }
            
            let oldVal = _dict.updateValue(newValue!, forKey: key)
            if oldVal == nil {
                _keys.append(key)
            }
        }
    }
    
    func resort(isOrderredBefore: (Value, Value)-> Bool) {
        _keys.sortInPlace { (key1, key2) -> Bool in
            let v1 = _dict[key1]
            let v2 = _dict[key2]
            return isOrderredBefore(v1!, v2!)
        }
    }
    
    /**
     一种快速排序的方法，将给定的index处的值移动到前端，前端的位置可以用frontPos来制定
     
     - parameter index:    目标index
     - parameter frontPos: 前端位置
     */
    func bringIndexToFront(index: Int, frontPos: Int = 0) {
        let count = self.count
        if index >= count || frontPos >= count || index <= frontPos {
            return
        }
        let a = _keys[index]
        _keys.removeAtIndex(index)
        _keys.insert(a, atIndex: frontPos)
    }
    
    func bringKeyToFront(key: Key, frontPos: Int = 0) {
        if let index = _keys.indexOf(key) {
            bringIndexToFront(index, frontPos: frontPos)
        }
    }
    
    func valueForIndex(index: Int) -> Value? {
        let key = _keys[index]
        return _dict[key]
    }

}