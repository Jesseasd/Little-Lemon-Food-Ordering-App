import Foundation

struct JSONMenu: Codable {
    let menu: [MenuItem]
}

struct MenuItem: Codable, Identifiable {
    // Optionally, if the JSON returns an id (as an Int) you could add:
    let id: Int?
    let title: String
    let description: String
    let price: String
    let image: String
    let category: String

    // If id is not provided in JSON, you can generate one:
    // let id = UUID()
}
