//
//  CGL+CoreDataProperties.swift
//  
//
//  Created by Diya V Gounder on 10/9/23.
//
//

import Foundation
import CoreData


extension CGL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CGL> {
        return NSFetchRequest<CGL>(entityName: "CGL")
    }

    @NSManaged public var course: String?
    @NSManaged public var grade: String?
    @NSManaged public var level: String?

}
