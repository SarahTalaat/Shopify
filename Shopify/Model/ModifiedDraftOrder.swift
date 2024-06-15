//
//
//import Foundation
//struct ModifiedDraftOrder : Codable {
//	let id : Int?
//	let note : String?
//	let email : String?
//	let taxes_included : Bool?
//	let currency : String?
//	let invoice_sent_at : String?
//	let created_at : String?
//	let updated_at : String?
//	let tax_exempt : Bool?
//	let completed_at : String?
//	let name : String?
//	let status : String?
//	let line_items : [ModifiedLineItems]?
//	let shipping_address : String?
//	let billing_address : String?
//	let invoice_url : String?
//	let applied_discount : String?
//	let order_id : String?
//	let shipping_line : String?
//	let tax_lines : [ModifiedTaxLines]?
//	let tags : String?
//	let note_attributes : [String]?
//	let total_price : String?
//	let subtotal_price : String?
//	let total_tax : String?
//	let payment_terms : String?
//	let admin_graphql_api_id : String?
//
//	enum CodingKeys: String, CodingKey {
//
//		case id = "id"
//		case note = "note"
//		case email = "email"
//		case taxes_included = "taxes_included"
//		case currency = "currency"
//		case invoice_sent_at = "invoice_sent_at"
//		case created_at = "created_at"
//		case updated_at = "updated_at"
//		case tax_exempt = "tax_exempt"
//		case completed_at = "completed_at"
//		case name = "name"
//		case status = "status"
//		case line_items = "line_items"
//		case shipping_address = "shipping_address"
//		case billing_address = "billing_address"
//		case invoice_url = "invoice_url"
//		case applied_discount = "applied_discount"
//		case order_id = "order_id"
//		case shipping_line = "shipping_line"
//		case tax_lines = "tax_lines"
//		case tags = "tags"
//		case note_attributes = "note_attributes"
//		case total_price = "total_price"
//		case subtotal_price = "subtotal_price"
//		case total_tax = "total_tax"
//		case payment_terms = "payment_terms"
//		case admin_graphql_api_id = "admin_graphql_api_id"
//	}
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		id = try values.decodeIfPresent(Int.self, forKey: .id)
//		note = try values.decodeIfPresent(String.self, forKey: .note)
//		email = try values.decodeIfPresent(String.self, forKey: .email)
//		taxes_included = try values.decodeIfPresent(Bool.self, forKey: .taxes_included)
//		currency = try values.decodeIfPresent(String.self, forKey: .currency)
//		invoice_sent_at = try values.decodeIfPresent(String.self, forKey: .invoice_sent_at)
//		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//		tax_exempt = try values.decodeIfPresent(Bool.self, forKey: .tax_exempt)
//		completed_at = try values.decodeIfPresent(String.self, forKey: .completed_at)
//		name = try values.decodeIfPresent(String.self, forKey: .name)
//		status = try values.decodeIfPresent(String.self, forKey: .status)
//		line_items = try values.decodeIfPresent([ModifiedLineItems].self, forKey: .line_items)
//		shipping_address = try values.decodeIfPresent(String.self, forKey: .shipping_address)
//		billing_address = try values.decodeIfPresent(String.self, forKey: .billing_address)
//		invoice_url = try values.decodeIfPresent(String.self, forKey: .invoice_url)
//		applied_discount = try values.decodeIfPresent(String.self, forKey: .applied_discount)
//		order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
//		shipping_line = try values.decodeIfPresent(String.self, forKey: .shipping_line)
//		tax_lines = try values.decodeIfPresent([ModifiedTaxLines].self, forKey: .tax_lines)
//		tags = try values.decodeIfPresent(String.self, forKey: .tags)
//		note_attributes = try values.decodeIfPresent([String].self, forKey: .note_attributes)
//		total_price = try values.decodeIfPresent(String.self, forKey: .total_price)
//		subtotal_price = try values.decodeIfPresent(String.self, forKey: .subtotal_price)
//		total_tax = try values.decodeIfPresent(String.self, forKey: .total_tax)
//		payment_terms = try values.decodeIfPresent(String.self, forKey: .payment_terms)
//		admin_graphql_api_id = try values.decodeIfPresent(String.self, forKey: .admin_graphql_api_id)
//	}
//
//}
