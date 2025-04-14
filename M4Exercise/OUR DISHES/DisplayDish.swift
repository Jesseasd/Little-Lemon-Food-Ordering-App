//
// DisplayDish.swift



import SwiftUI


struct DisplayDish: View {
    @ObservedObject var dish: Dish
    init(_ dish: Dish) {
        self.dish = dish
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // If dish.image is a URL string, you can use AsyncImage:
                if let imageUrlString = dish.value(forKey: "image") as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                    .clipped()
                }
                Text(dish.name ?? "No Name")
                    .font(.title)
                Text(dish.formatPrice())
                    .font(.headline)
                // Optionally, display dish description
                // Text(dish.value(forKey: "description") as? String ?? "")
            }
            .padding()
        }
        .navigationTitle(dish.name ?? "")
    }
}


struct DisplayDish_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    let dish = Dish(context: context)
    static var previews: some View {
        DisplayDish(oneDish())
    }
    static func oneDish() -> Dish {
        let dish = Dish(context: context)
        dish.name = "Hummus"
        dish.price = 10
        dish.size = "Extra Large"
        return dish
    }
}

