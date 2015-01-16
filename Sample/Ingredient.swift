//
//  Ingredient.swift
//  Sample
//
//  Created by Muneeb Samuels on 2015/01/16.
//  Copyright (c) 2015 Codebus.io (Pty) Ltd. All rights reserved.
//

import Foundation
import CoreData

@objc(Ingredient)
class Ingredient: NSManagedObject {

    @NSManaged var text: String
    @NSManaged var recipe: Recipe

}
