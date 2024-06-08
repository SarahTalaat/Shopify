//
//
//import Foundation
//struct CustomerModelResponse : Codable {
//	let customer : [CustomerResponse]?
//
//	enum CodingKeys: String, CodingKey {
//
//		case customer = "customers"
//	}
//
//
//    init(customer: [CustomerResponse]){
//        self.customer = customer
//    }
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		customer = try values.decodeIfPresent([CustomerResponse].self, forKey: .customer)
//	}
//
//}

struct CustomerModelResponse: Codable {
    let customers: [Customer]?
}

struct Customer: Codable {
    let id: Int?
    let email: String?
    let created_at: String?
    let updated_at: String?
    let first_name: String?
    let last_name: String?
    let orders_count: Int?
    let state: String?
    let total_spent: String?
    let last_order_id: String?
    let note: String??
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let tags: String?
    let last_order_name: String?
    let currency: String?
    let phone: String?
    let addresses: [String]?
    let accepts_marketing: Bool?
    let accepts_marketing_updated_at: String?
    let marketing_opt_in_level: String?
    let tax_exemptions: [String]?
    let email_marketing_consent: EmailMarketingConsent?
    let sms_marketing_consent: String?
    let admin_graphql_api_id: String?
}

struct EmailMarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
}

struct CustomerModelRequest: Codable {
    let customer: CustomerRequest
}

struct CustomerRequest: Codable {
    let first_name: String
    let email: String
    let verified_email: Bool
}
