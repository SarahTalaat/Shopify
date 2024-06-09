
import Foundation

struct CustomersModelResponse: Codable {
    let customers: [CustomersResponse]?
}


struct CustomersResponse: Codable {
    let id: Int64?
    let email: String?
    let created_at: Date?
    let updated_at: Date?
    let first_name: String?
    let last_name: String?
    let orders_count: Int?
    let state: String?
    let total_spent: String?
    let last_order_id: Int64?
    let note: String?
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let tags: String?
    let last_order_name: String?
    let currency: String?
    let phone: String?
    let addresses: [AddressesModel]?
    let accepts_marketing: Bool?
    let accepts_marketing_updated_at: Date?
    let marketing_opt_in_level: String?
    let tax_exemptions: [String]?
    let email_marketing_consent: Consent?
    let sms_marketing_consent: Consent?
    let admin_graphql_api_id: String?
    let default_address: AddressesModel?
}
struct AddressesModel: Codable {
    let id: Int64?
    let customer_id: Int64?
    let first_name: String?
    let last_name: String?
    let company: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let name: String?
    let province_code: String?
    let country_code: String?
    let country_name: String?
    let defaultValue: Bool?
    
    enum CodingKeys: String, CodingKey {
        case defaultValue = "default"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        defaultValue = try values.decodeIfPresent(Bool.self, forKey: .defaultValue)
        
        // Set default values for non-optional properties
        id = nil
        customer_id = nil
        first_name = nil
        last_name = nil
        company = nil
        address1 = nil
        address2 = nil
        city = nil
        province = nil
        country = nil
        zip = nil
        phone = nil
        name = nil
        province_code = nil
        country_code = nil
        country_name = nil
    }
}



struct Consent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: Date?
    let consent_collected_from: String?
}
