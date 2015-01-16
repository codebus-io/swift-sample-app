//
//  RecipeAddViewController.swift
//  Sample
//
//  Created by Muneeb Samuels on 2015/01/16.
//  Copyright (c) 2015 Codebus.io (Pty) Ltd. All rights reserved.
//

import UIKit
import CoreData

@objc protocol RecipeAddDelegate {
    func didAddRecipe(recipe:Recipe)
}

class RecipeAddViewController: XLFormViewController {
    
    weak var delegate:RecipeAddDelegate!
    var cdh:CoreDataHelper!
    var recipe:Recipe!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initForm()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initForm() {
        var form:XLFormDescriptor!
        var section:XLFormSectionDescriptor!
        var row:XLFormRowDescriptor!
        
        form = XLFormDescriptor(title: "Add Recipe")
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Recipe Details") as XLFormSectionDescriptor
        
        row = XLFormRowDescriptor(tag: "recipeName", rowType: XLFormRowDescriptorTypeText, title: "Recipe Name")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "prepTime", rowType: XLFormRowDescriptorTypeNumber, title: "Prep Time")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "cookingTime", rowType: XLFormRowDescriptorTypeNumber, title: "Cooking Time")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "serves", rowType: XLFormRowDescriptorTypeNumber, title: "Serves")
        section.addFormRow(row)
        
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Ingredients", multivaluedSection: true) as XLFormSectionDescriptor
        section.multiValuedTag = "textFieldRow"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeText)
        row.cellConfig.setObject("Add Ingredient", forKey: "textField.placeholder")
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!)
    {
        
    }
    
    @IBAction func save(sender: AnyObject) {
        var fv = formValues() as NSDictionary
        var ingredients: NSArray? = fv.objectForKey("textFieldRow") as? NSArray
        
        let recipeTitle = fv.objectForKey("recipeName") as String
        let prepTime = fv.objectForKey("prepTime") as Int
        let cookingTime = fv.objectForKey("cookingTime") as Int
        let serves = fv.objectForKey("serves") as Int
        
        if (recipe == nil) {
            recipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: cdh.managedObjectContext!) as? Recipe
        }
        recipe.title = recipeTitle
        recipe.prepTime = prepTime
        recipe.cookingTime = cookingTime
        recipe.servings = serves
        
        for var index = 0; index < ingredients?.count; ++index {
            if let ingredient: Ingredient = NSEntityDescription.insertNewObjectForEntityForName("Ingredient", inManagedObjectContext: cdh.managedObjectContext!) as? Ingredient {
                if let text = ingredients?.objectAtIndex(index) as? String {
                    ingredient.text = text
                    ingredient.recipe = recipe
                    recipe.ingredients.setByAddingObject(ingredient)
                }
            }
        }
        
        var error:NSError?
        
        recipe.managedObjectContext?.save(&error)
        
        delegate.didAddRecipe(recipe)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
