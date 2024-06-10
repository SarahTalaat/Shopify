
import Foundation



struct CustomersResponse: Codable {
    let customers: [CustomersDetails]?
}

struct CustomersDetails: Codable {
    let id: Int?
    let email: String?
    let created_at: String?
    let updated_at: String?
    let first_name: String?
    let last_name: String?
    let orders_count: Int?
    let state: String?
    let total_spent: String?
    let last_order_id: Int?
    let note: String?
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let tags: String?
    let last_order_name: String?
    let currency: String?
    let phone: String?
    let addresses: [AddressModel]?
    let accepts_marketing: Bool?
    let accepts_marketing_updated_at: String?
    let marketing_opt_in_level: String?
    let tax_exemptions: [String]?
    let email_marketing_consent: EmailMarketingConsent?
    let sms_marketing_consent: SMSMarketingConsent?
    let admin_graphql_api_id: String?
    let default_address: AddressModel?
}

struct AddressModel: Codable {
    let id: Int?
    let customer_id: Int?
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
    let `default`: Bool?
}

struct EmailMarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
}

struct SMSMarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
    let consent_collected_from: String?
}
