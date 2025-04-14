import Foundation
import CoreData


extension Dish {

    static func createDishesFrom(menuItems: [MenuItem], _ context: NSManagedObjectContext) {
        for menuItem in menuItems {
            if exists(name: menuItem.title, context) == false {
                let newDish = Dish(context: context)
                newDish.name = menuItem.title
                if let price = Float(menuItem.price) {
                    newDish.price = price
                } else {
                    newDish.price = 0
                }
                // Store additional details if your model supports them:
                // newDish.size = menuItem.category  // Option: use category as size, or add new attributes to Dish
                // You might need to add extra properties for description or image if required
            }
        }
        Dish.save(context)
    }
    
}
