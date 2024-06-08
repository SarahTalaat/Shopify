

import Foundation
struct Email_marketing_consent : Codable {
	let state : String?
	let opt_in_level : String?
	let consent_updated_at : String?

	enum CodingKeys: String, CodingKey {

		case state = "state"
		case opt_in_level = "opt_in_level"
		case consent_updated_at = "consent_updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		opt_in_level = try values.decodeIfPresent(String.self, forKey: .opt_in_level)
		consent_updated_at = try values.decodeIfPresent(String.self, forKey: .consent_updated_at)
	}

}
