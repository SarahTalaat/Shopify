//
//  DependencyProvider.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation


class DependencyProvider {
    
    static var authServiceProtocol : AuthServiceProtocol {
        return FirebaseAuthService()
    }
    
    static var signInViewModel: SignInViewModel{
        return SignInViewModel(authServiceProtocol: authServiceProtocol)
    }
    
    static var signUpViewModel: SignUpViewModel{
        return SignUpViewModel(authServiceProtocol: authServiceProtocol)
    }



    
}

/*
 
 static var networkProtocol: NetworkProtocol {
     return Network()
 }

 static var databaseProtocol: DBManagerProtocol{
     return DBManager.favouriteLeagueDB
 }
 
 
 static var leaguesViewModel: LeaguesViewModel {
     return LeaguesViewModel(networkProtocol: networkProtocol)
 }

 static var favouritesViewModel: FavouritesViewModel {
     return FavouritesViewModel(dbManagerProtocol: databaseProtocol)
 }

 static var teamDetailsViewModel: TeamsDetailsViewModel {
     return TeamsDetailsViewModel(networkProtocol: networkProtocol)
 }
 
 
 static func createLeaguesViewController(with viewModel: LeaguesViewModelProtocol) -> LeagueViewController {
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     guard let leaguesViewController = storyboard.instantiateViewController(withIdentifier: "LeagueViewController") as? LeagueViewController else{
         fatalError("Unable to instantiate LeaguesViewController from storyboard")
     }
     leaguesViewController.viewModel = leaguesViewModel
     return leaguesViewController
 }
 */
