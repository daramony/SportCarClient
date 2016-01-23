//
//  NewsComment.generated.swift
//
//  This code was generated by AlecrimCoreData code generator tool.
//
//  Changes to this file may cause incorrect behavior and will be lost if
//  the code is regenerated.
//

import Foundation
import CoreData

import AlecrimCoreData

// MARK: - NewsComment properties

extension NewsComment {

    @NSManaged var alreaySent: Bool // cannot mark as optional because Objective-C compatibility issues
    @NSManaged var atString: String?
    @NSManaged var commentID: String?
    @NSManaged var content: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var image: String?

    @NSManaged var commentTo: NewsComment?
    @NSManaged var news: News?
    @NSManaged var user: User?

    @NSManaged var replys: Set<NewsComment>

}

// MARK: - NewsComment KVC compliant to-many accessors and helpers

extension NewsComment {

    @NSManaged private func addReplysObject(object: NewsComment)
    @NSManaged private func removeReplysObject(object: NewsComment)
    @NSManaged func addReplys(replys: Set<NewsComment>)
    @NSManaged func removeReplys(replys: Set<NewsComment>)

    func addReply(reply: NewsComment) { self.addReplysObject(reply) }
    func removeReply(reply: NewsComment) { self.removeReplysObject(reply) }

}

// MARK: - NewsComment query attributes

extension NewsComment {

    static let alreaySent = AlecrimCoreData.NullableAttribute<Bool>("alreaySent")
    static let atString = AlecrimCoreData.NullableAttribute<String>("atString")
    static let commentID = AlecrimCoreData.NullableAttribute<String>("commentID")
    static let content = AlecrimCoreData.NullableAttribute<String>("content")
    static let createdAt = AlecrimCoreData.NullableAttribute<NSDate>("createdAt")
    static let image = AlecrimCoreData.NullableAttribute<String>("image")

    static let commentTo = AlecrimCoreData.NullableAttribute<NewsComment>("commentTo")
    static let news = AlecrimCoreData.NullableAttribute<News>("news")
    static let user = AlecrimCoreData.NullableAttribute<User>("user")

    static let replys = AlecrimCoreData.Attribute<Set<NewsComment>>("replys")

}

// MARK: - AttributeType extensions

extension AlecrimCoreData.AttributeType where Self.ValueType: NewsComment {

    var alreaySent: AlecrimCoreData.NullableAttribute<Bool> { return AlecrimCoreData.NullableAttribute<Bool>("alreaySent", self) }
    var atString: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("atString", self) }
    var commentID: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("commentID", self) }
    var content: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("content", self) }
    var createdAt: AlecrimCoreData.NullableAttribute<NSDate> { return AlecrimCoreData.NullableAttribute<NSDate>("createdAt", self) }
    var image: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("image", self) }

    var commentTo: AlecrimCoreData.NullableAttribute<NewsComment> { return AlecrimCoreData.NullableAttribute<NewsComment>("commentTo", self) }
    var news: AlecrimCoreData.NullableAttribute<News> { return AlecrimCoreData.NullableAttribute<News>("news", self) }
    var user: AlecrimCoreData.NullableAttribute<User> { return AlecrimCoreData.NullableAttribute<User>("user", self) }

    var replys: AlecrimCoreData.Attribute<Set<NewsComment>> { return AlecrimCoreData.Attribute<Set<NewsComment>>("replys", self) }

}

// MARK: - DataContext extensions

extension DataContext {

    var newsComments: AlecrimCoreData.Table<NewsComment> { return AlecrimCoreData.Table<NewsComment>(dataContext: self) }

}

