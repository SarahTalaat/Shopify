


import Foundation

// MARK: - CustomerResponse
struct CustomerResponse: Codable {
    let customer: CustomerDetails
}

// MARK: - CustomerDetails
struct CustomerDetails: Codable {
    let id: Int
    let email: String
    let createdAt: String
    let updatedAt: String
    let firstName: String
    let lastName: String?
    let ordersCount: Int
    let state: String
    let totalSpent: String
    let lastOrderID: Int?
    let note: String?
    let verifiedEmail: Bool
    let multipassIdentifier: String?
    let taxExempt: Bool
    let tags: String
    let lastOrderName: String?
    let currency: String
    let phone: String?
    let addresses: [AddressModel]
    let acceptsMarketing: Bool
    let acceptsMarketingUpdatedAt: String?
    let marketingOptInLevel: String
    let taxExemptions: [String]
    let emailMarketingConsent: EmailMarketingConsent
    let smsMarketingConsent: SMSMarketingConsent?
    let adminGraphQLAPIID: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency, phone, addresses
        case acceptsMarketing = "accepts_marketing"
        case acceptsMarketingUpdatedAt = "accepts_marketing_updated_at"
        case marketingOptInLevel = "marketing_opt_in_level"
        case taxExemptions = "tax_exemptions"
        case emailMarketingConsent = "email_marketing_consent"
        case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphQLAPIID = "admin_graphql_api_id"
    }
}

// MARK: - AddressModel
struct AddressModel: Codable {
    let id: Int?
    let customerID: Int?
    let firstName: String?
    let lastName: String?
    let company: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let name: String?
    let provinceCode: String?
    let countryCode: String?
    let countryName: String?
    let isDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company, address1, address2, city, province, country, zip, phone, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case isDefault = "default"
    }
}

// MARK: - EmailMarketingConsent
struct EmailMarketingConsent: Codable {
    let state: String
    let optInLevel: String
    let consentUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
    }
}

// MARK: - SMSMarketingConsent
struct SMSMarketingConsent: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?
    let consentCollectedFrom: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
        case consentCollectedFrom = "consent_collected_from"
    }
}


//
//struct CustomersResponse: Codable {
//    let customers: [CustomersDetails]?
//}
//
//struct CustomersDetails: Codable {
//    let id: Int?
//    let email: String?
//    let created_at: String?
//    let updated_at: String?
//    let first_name: String?
//    let last_name: String?
//    let orders_count: Int?
//    let state: String?
//    let total_spent: String?
//    let last_order_id: Int?
//    let note: String?
//    let verified_email: Bool?
//    let multipass_identifier: String?
//    let tax_exempt: Bool?
//    let tags: String?
//    let last_order_name: String?
//    let currency: String?
//    let phone: String?
//    let addresses: [AddressModel]?
//    let accepts_marketing: Bool?
//    let accepts_marketing_updated_at: String?
//    let marketing_opt_in_level: String?
//    let tax_exemptions: [String]?
//    let email_marketing_consent: EmailMarketingConsent?
//    let sms_marketing_consent: SMSMarketingConsent?
//    let admin_graphql_api_id: String?
//    let default_address: AddressModel?
//}
//
//struct AddressModel: Codable {
//    let id: Int?
//    let customer_id: Int?
//    let first_name: String?
//    let last_name: String?
//    let company: String?
//    let address1: String?
//    let address2: String?
//    let city: String?
//    let province: String?
//    let country: String?
//    let zip: String?
//    let phone: String?
//    let name: String?
//    let province_code: String?
//    let country_code: String?
//    let country_name: String?
//    let `default`: Bool?
//}
//
//struct EmailMarketingConsent: Codable {
//    let state: String?
//    let opt_in_level: String?
//    let consent_updated_at: String?
//}
//
//struct SMSMarketingConsent: Codable {
//    let state: String?
//    let opt_in_level: String?
//    let consent_updated_at: String?
//    let consent_collected_from: String?
//}



