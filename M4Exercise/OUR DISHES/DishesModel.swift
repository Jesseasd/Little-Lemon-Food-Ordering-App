import Foundation
import CoreData


@MainActor
class DishesModel: ObservableObject {
    
    @Published var menuItems = [MenuItem]()
        
    
    func reload(_ coreDataContext: NSManagedObjectContext) async {
        let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/littleLemonSimpleMenu.json")!
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let fullMenu = try newJSONDecoder().decode(JSONMenu.self, from: data)
            self.menuItems = fullMenu.menu

            // Remove existing data, then repopulate Core Data:
            Dish.deleteAll(coreDataContext)
            Dish.createDishesFrom(menuItems: menuItems, coreDataContext)
        } catch {
            print("Error fetching or decoding data: \(error)")
        }
    }
}



func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}


extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func itemsTask(with url: URL, completionHandler: @escaping (JSONMenu?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

