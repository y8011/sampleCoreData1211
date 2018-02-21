//
//  ToDo+CoreDataProperties.swift
//  sampleCoreData
//
//  Created by yuka on 2018/02/20.
//  Copyright © 2018年 Eriko Ichinohe. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var saveDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var catTitle: String?

}
