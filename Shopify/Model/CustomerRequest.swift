
import Foundation
struct CustomerRequest : Codable {
	let first_name : String?
	let email : String?
	let verified_email : Bool?

	enum CodingKeys: String, CodingKey {

		case first_name = "first_name"
		case email = "email"
		case verified_email = "verified_email"
	}
    
    
    init(first_name: String?, email: String?, verified_email: Bool?) {
        self.first_name = first_name
        self.email = email
        self.verified_email = verified_email
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		verified_email = try values.decodeIfPresent(Bool.self, forKey: .verified_email)
	}

}
