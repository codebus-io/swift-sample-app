//
//  Recipe.swift
//  Sample
//
//  Created by Muneeb Samuels on 2015/01/16.
//  Copyright (c) 2015 Codebus.io (Pty) Ltd. All rights reserved.
//

import Foundation
import CoreData

@objc(Recipe)
class Recipe: NSManagedObject {

    @NSManaged var cookingTime: NSNumber
    @NSManaged var image: AnyObject
    @NSManaged var prepTime: NSNumber
    @NSManaged var servings: NSNumber
    @NSManaged var title: String
    @NSManaged var ingredients: NSSet

}
