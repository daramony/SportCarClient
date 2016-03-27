//
//  Activity.generated.swift
//
//  This code was generated by AlecrimCoreData code generator tool.
//
//  Changes to this file may cause incorrect behavior and will be lost if
//  the code is regenerated.
//

import Foundation
import CoreData

import AlecrimCoreData

// MARK: - Activity properties

extension Activity {

    @NSManaged var actDescription: String?
    @NSManaged var applyAt: NSDate?
    @NSManaged var commentNum: Int32 // cannot mark as optional because Objective-C compatibility issues
    @NSManaged var createdAt: NSDate?
    @NSManaged var endAt: NSDate?
    @NSManaged var likeNum: Int32 // cannot mark as optional because Objective-C compatibility issues
    @NSManaged var liked: Bool // cannot mark as optional because Objective-C compatibility issues
    @NSManaged var loc: String?
    @NSManaged var maxAttend: Int32 // cannot mark as optional because Objective-C compatibility issues
    @NSManaged var mine: Bool // cannot mark as optional because Objective-C compatibility issues
    @NSManaged var name: String?
    @NSManaged var poster: String?
    @NSManaged var sent: NSDate?
    @NSManaged var startAt: NSDate?

    @NSManaged var user: User?

}

// MARK: - Activity query attributes

extension Activity {

    static let actDescription = AlecrimCoreData.NullableAttribute<String>("actDescription")
    static let applyAt = AlecrimCoreData.NullableAttribute<NSDate>("applyAt")
    static let commentNum = AlecrimCoreData.NullableAttribute<Int32>("commentNum")
    static let createdAt = AlecrimCoreData.NullableAttribute<NSDate>("createdAt")
    static let endAt = AlecrimCoreData.NullableAttribute<NSDate>("endAt")
    static let likeNum = AlecrimCoreData.NullableAttribute<Int32>("likeNum")
    static let liked = AlecrimCoreData.NullableAttribute<Bool>("liked")
    static let loc = AlecrimCoreData.NullableAttribute<String>("loc")
    static let maxAttend = AlecrimCoreData.NullableAttribute<Int32>("maxAttend")
    static let mine = AlecrimCoreData.NullableAttribute<Bool>("mine")
    static let name = AlecrimCoreData.NullableAttribute<String>("name")
    static let poster = AlecrimCoreData.NullableAttribute<String>("poster")
    static let sent = AlecrimCoreData.NullableAttribute<NSDate>("sent")
    static let startAt = AlecrimCoreData.NullableAttribute<NSDate>("startAt")

    static let user = AlecrimCoreData.NullableAttribute<User>("user")

}

// MARK: - AttributeType extensions

extension AlecrimCoreData.AttributeType where Self.ValueType: Activity {

    var actDescription: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("actDescription", self) }
    var applyAt: AlecrimCoreData.NullableAttribute<NSDate> { return AlecrimCoreData.NullableAttribute<NSDate>("applyAt", self) }
    var commentNum: AlecrimCoreData.NullableAttribute<Int32> { return AlecrimCoreData.NullableAttribute<Int32>("commentNum", self) }
    var createdAt: AlecrimCoreData.NullableAttribute<NSDate> { return AlecrimCoreData.NullableAttribute<NSDate>("createdAt", self) }
    var endAt: AlecrimCoreData.NullableAttribute<NSDate> { return AlecrimCoreData.NullableAttribute<NSDate>("endAt", self) }
    var likeNum: AlecrimCoreData.NullableAttribute<Int32> { return AlecrimCoreData.NullableAttribute<Int32>("likeNum", self) }
    var liked: AlecrimCoreData.NullableAttribute<Bool> { return AlecrimCoreData.NullableAttribute<Bool>("liked", self) }
    var loc: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("loc", self) }
    var maxAttend: AlecrimCoreData.NullableAttribute<Int32> { return AlecrimCoreData.NullableAttribute<Int32>("maxAttend", self) }
    var mine: AlecrimCoreData.NullableAttribute<Bool> { return AlecrimCoreData.NullableAttribute<Bool>("mine", self) }
    var name: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("name", self) }
    var poster: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("poster", self) }
    var sent: AlecrimCoreData.NullableAttribute<NSDate> { return AlecrimCoreData.NullableAttribute<NSDate>("sent", self) }
    var startAt: AlecrimCoreData.NullableAttribute<NSDate> { return AlecrimCoreData.NullableAttribute<NSDate>("startAt", self) }

    var user: AlecrimCoreData.NullableAttribute<User> { return AlecrimCoreData.NullableAttribute<User>("user", self) }

}

// MARK: - DataContext extensions

extension DataContext {

    var activities: AlecrimCoreData.Table<Activity> { return AlecrimCoreData.Table<Activity>(dataContext: self) }

}
