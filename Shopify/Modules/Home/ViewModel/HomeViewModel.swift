//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation
import Reachability

class HomeViewModel {
    let networkService: NetworkServiceAuthenticationProtocol
    var reachability: Reachability?

    var brands: [SmartCollection] = [] {
        didSet {
            self.bindBrandsData()
        }
    }

    var coupons: [PriceRules] = [] {
        didSet {
            self.bindCouponsData?()
        }
    }

    var bindBrandsData: (() -> ()) = {}
    var bindCouponsData: (() -> Void)?
    var networkStatusChanged: ((Bool) -> Void)?

    init() {
        self.networkService = networkService
        setupReachability()
        getBrands()
        getCoupons()
    }

    func getBrands() {
        let urlString = APIConfig.smart_collections.url
        networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<CollectionResponse, Error>) in
            switch result {
            case .success(let response):
                self.brands = response.smart_collections
                self.bindBrandsData()
            case .failure(let error):
                print("Failed to fetch brands: \(error.localizedDescription)")
            }
        }
    }

    func getCoupons() {
        let urlString = APIConfig.endPoint("price_rules").url
        networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<PriceRulesResponse, Error>) in
            switch result {
            case .success(let response):
                self.coupons = response.price_rules
                self.bindCouponsData?()
            case .failure(let error):
                print("Failed to fetch coupons: \(error.localizedDescription)")
            }
        }
    }

    func postDiscountCodes() {
        let discountCodes = ["SUMMERSALE20OFF", "SUMMERSALE10OFF"]

        for (index, coupon) in coupons.enumerated() {
            guard index < discountCodes.count else {
                print("Not enough discount codes provided for all price rules.")
                return
            }

            let discountCodeData = DiscountCode(price_rule_id: coupon.id, code: discountCodes[index])
            let urlString = APIConfig.endPoint("price_rules/\(coupon.id)/discount_codes").url
            networkService.requestFunction(urlString: urlString, method: .post, model: discountCodeData.toDictionary() ?? [:]) { (result: Result<DiscountCodeResponse, Error>) in
                switch result {
                case .success:
                    print("Discount code '\(discountCodes[index])' posted successfully for price rule with ID \(coupon.id)")
                case .failure(let error):
                    print("Failed to post discount code '\(discountCodes[index])' for price rule with ID \(coupon.id): \(error.localizedDescription)")
                }
            }
        }
    }

    func getDiscountCode(id: Int, completion: @escaping (String?) -> Void) {
        let urlString = APIConfig.endPoint("price_rules/\(id)/discount_codes").url
        networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { (result: Result<DiscountResponse, Error>) in
            switch result {
            case .success(let response):
                let discountCode = response.discount_codes.first?.code
                completion(discountCode)
            case .failure(let error):
                print("Failed to fetch discount code: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    func setupReachability() {
        reachability = try? Reachability()
        reachability?.whenReachable = { reachability in
            self.networkStatusChanged?(reachability.connection == .wifi)
            print("wifi connection")
        }
        reachability?.whenUnreachable = { _ in
            self.networkStatusChanged?(false)
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
