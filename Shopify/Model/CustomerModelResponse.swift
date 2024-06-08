

import Foundation
struct CustomerModelResponse : Codable {
	let customer : CustomerResponse?

	enum CodingKeys: String, CodingKey {

		case customer = "customer"
	}
    
    
    init(customer: CustomerResponse){
        self.customer = customer
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customer = try values.decodeIfPresent(CustomerResponse.self, forKey: .customer)
	}

}
