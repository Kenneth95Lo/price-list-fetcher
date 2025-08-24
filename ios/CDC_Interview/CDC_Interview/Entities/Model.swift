import Foundation

enum Tag: String, Codable {
    case deposit = "deposit"
    case withdrawal = "withdrawal"
}

struct USDPrice: Codable {
    struct Price: Codable, Identifiable {
        let id: Int
        let name: String
        let usd: Decimal
        let tags: [Tag]
        
        func toDictionary() -> NSDictionary {
            return [
                "id": id,
                "name": name,
                "usd": usd,
                "tags": tags.toStringArray()
            ]
        }
    }

    let data: [Price]
}

struct AllPrice: Codable {
    struct Price: Codable, Identifiable {
        struct PriceRecord: Codable {
            let usd: Decimal
            let eur: Decimal
        }
        
        let id: Int
        let name: String
        let price: PriceRecord
        let tags: [Tag]
        
        func toDictionary() -> NSDictionary {
            return [
                "id": id,
                "name": name,
                "usd": price.usd,
                "eur": price.eur,
                "tags": tags.toStringArray()
            ]
        }
    }

    let data: [Price]
}

extension Array where Element == Tag {
    func toStringArray() -> [String] {
        return self.map { $0.rawValue }
    }
}
