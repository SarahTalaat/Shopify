//
//
//import Foundation
//struct ModifiedDraftOrderResponse : Codable {
//	let draft_order : ModifiedDraftOrder?
//
//	enum CodingKeys: String, CodingKey {
//
//		case draft_order = "draft_order"
//	}
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		draft_order = try values.decodeIfPresent(ModifiedDraftOrder.self, forKey: .draft_order)
//	}
//
//}
