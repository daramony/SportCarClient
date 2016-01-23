//
//  SportCarOwnerShip.generated.swift
//
//  This code was generated by AlecrimCoreData code generator tool.
//
//  Changes to this file may cause incorrect behavior and will be lost if
//  the code is regenerated.
//

import Foundation
import CoreData

import AlecrimCoreData

// MARK: - SportCarOwnerShip properties

extension SportCarOwnerShip {

    @NSManaged var identified: Bool // cannot mark as optional because Objective-C compatibility issues
    @NSManaged var signature: String?

    @NSManaged var car: SportCar?
    @NSManaged var user: User?

}

// MARK: - SportCarOwnerShip query attributes

extension SportCarOwnerShip {

    static let identified = AlecrimCoreData.NullableAttribute<Bool>("identified")
    static let signature = AlecrimCoreData.NullableAttribute<String>("signature")

    static let car = AlecrimCoreData.NullableAttribute<SportCar>("car")
    static let user = AlecrimCoreData.NullableAttribute<User>("user")

}

// MARK: - AttributeType extensions

extension AlecrimCoreData.AttributeType where Self.ValueType: SportCarOwnerShip {

    var identified: AlecrimCoreData.NullableAttribute<Bool> { return AlecrimCoreData.NullableAttribute<Bool>("identified", self) }
    var signature: AlecrimCoreData.NullableAttribute<String> { return AlecrimCoreData.NullableAttribute<String>("signature", self) }

    var car: AlecrimCoreData.NullableAttribute<SportCar> { return AlecrimCoreData.NullableAttribute<SportCar>("car", self) }
    var user: AlecrimCoreData.NullableAttribute<User> { return AlecrimCoreData.NullableAttribute<User>("user", self) }

}

// MARK: - DataContext extensions

extension DataContext {

    var sportCarOwnerShips: AlecrimCoreData.Table<SportCarOwnerShip> { return AlecrimCoreData.Table<SportCarOwnerShip>(dataContext: self) }

}

