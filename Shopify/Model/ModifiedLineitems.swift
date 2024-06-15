

import Foundation
struct ModifiedLineItems : Codable {
	let id : Int?
	let variant_id : Int?
	let product_id : Int?
	let title : String?
	let variant_title : String?
	let sku : String?
	let vendor : String?
	let quantity : Int?
	let requires_shipping : Bool?
	let taxable : Bool?
	let gift_card : Bool?
	let fulfillment_service : String?
	let grams : Int?
	let tax_lines : [ModifiedTaxLines]?
	let applied_discount : String?
	let name : String?
	let properties : [String]?
	let custom : Bool?
	let price : String?
	let admin_graphql_api_id : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case variant_id = "variant_id"
		case product_id = "product_id"
		case title = "title"
		case variant_title = "variant_title"
		case sku = "sku"
		case vendor = "vendor"
		case quantity = "quantity"
		case requires_shipping = "requires_shipping"
		case taxable = "taxable"
		case gift_card = "gift_card"
		case fulfillment_service = "fulfillment_service"
		case grams = "grams"
		case tax_lines = "tax_lines"
		case applied_discount = "applied_discount"
		case name = "name"
		case properties = "properties"
		case custom = "custom"
		case price = "price"
		case admin_graphql_api_id = "admin_graphql_api_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		variant_id = try values.decodeIfPresent(Int.self, forKey: .variant_id)
		product_id = try values.decodeIfPresent(Int.self, forKey: .product_id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		variant_title = try values.decodeIfPresent(String.self, forKey: .variant_title)
		sku = try values.decodeIfPresent(String.self, forKey: .sku)
		vendor = try values.decodeIfPresent(String.self, forKey: .vendor)
		quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
		requires_shipping = try values.decodeIfPresent(Bool.self, forKey: .requires_shipping)
		taxable = try values.decodeIfPresent(Bool.self, forKey: .taxable)
		gift_card = try values.decodeIfPresent(Bool.self, forKey: .gift_card)
		fulfillment_service = try values.decodeIfPresent(String.self, forKey: .fulfillment_service)
		grams = try values.decodeIfPresent(Int.self, forKey: .grams)
		tax_lines = try values.decodeIfPresent([ModifiedTaxLines].self, forKey: .tax_lines)
		applied_discount = try values.decodeIfPresent(String.self, forKey: .applied_discount)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		properties = try values.decodeIfPresent([String].self, forKey: .properties)
		custom = try values.decodeIfPresent(Bool.self, forKey: .custom)
		price = try values.decodeIfPresent(String.self, forKey: .price)
		admin_graphql_api_id = try values.decodeIfPresent(String.self, forKey: .admin_graphql_api_id)
	}

}
