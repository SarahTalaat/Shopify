//
//  SignUpViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation



class SignUpViewModel {
    private let authService: AuthServiceProtocol
    
    var user: UserModel? {
        didSet {
            self.bindUserViewModelToController()
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.bindErrorViewModelToController()
        }
    }
    
    var bindUserViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func signUp(email: String, password: String) {
        authService.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}



/*

 import Foundation


 class LeaguesViewModel: LeaguesViewModelProtocol {

     var resultToViewController: (()->()) = {}
     
     var leaguesArray: [League]? = []
     {
         didSet{
           resultToViewController()
         }
     }
     
     var networkProtocol: NetworkProtocol
     
     init(networkProtocol: NetworkProtocol){
         self.networkProtocol = networkProtocol
     }
     
     func getLeagues(sport: String) {
         let url = "https://apiv2.allsportsapi.com/\(sport)/"
         let parameters = ["met" : "Leagues", "APIkey" : Constants.API_KEY]
           networkProtocol.fetchDataFromAPI(url: url, param: parameters){ [weak self] (response : MyResponse<League>?) in
               self?.leaguesArray = response?.result ?? []
 //              print("leagues array count : \(self?.leaguesArray?.count)")
 //              print("League name::  \(self?.leaguesArray?[0].league_name ?? "")")
         }
     }
     
     

     
     
     
     
 }

 */
