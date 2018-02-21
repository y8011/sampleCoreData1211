//
//  Category+CoreDataProperties.swift
//  sampleCoreData
//
//  Created by yuka on 2018/02/20.
//  Copyright © 2018年 Eriko Ichinohe. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var titleOfCat: String?

}
