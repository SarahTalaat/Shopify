
import Foundation
struct ModifiedTaxLines : Codable {
	let rate : Double?
	let title : String?
	let price : String?

	enum CodingKeys: String, CodingKey {

		case rate = "rate"
		case title = "title"
		case price = "price"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		rate = try values.decodeIfPresent(Double.self, forKey: .rate)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		price = try values.decodeIfPresent(String.self, forKey: .price)
	}

}
