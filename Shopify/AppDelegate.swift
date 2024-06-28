//
//  AppDelegate.swift
//  Shopify
//
//  Created by Sara Talat on 31/05/2024.
//

import UIKit
import CoreData
import FirebaseCore


@main
class AppDelegate: UIResponder, UIApplicationDelegate , UITabBarControllerDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
        
        // Override point for customization after application launch.
        
        // Customize the back button globally
        let backButtonAppearance = UIBarButtonItem.appearance()
        backButtonAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        backButtonAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)

        // Set the back button arrow color globally
        UINavigationBar.appearance().tintColor = .black
         let customRed = UIColor(red: 219/255.0, green: 48/255.0, blue: 34/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = customRed
             UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        
        FirebaseApp.configure()
        
        if let rootViewController = window?.rootViewController as? UITabBarController {
                // Set the delegate of the UITabBarController to self
                rootViewController.delegate = self
            }

        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Shopify")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
//
//    func configureAppTransportSecurity() {
//        // Access Info.plist as a dictionary
//        guard var infoDict = Bundle.main.infoDictionary else {
//            print("Error accessing Info.plist")
//            return
//        }
//        
//        // Create NSAppTransportSecurity dictionary
//        var appTransportSecurityDict: [String: Any] = [:]
//        
//        // Create NSAllowsArbitraryLoads key-value pair
//        appTransportSecurityDict["NSAllowsArbitraryLoads"] = true
//        
//        // If you want to allow non-HTTPS connections for specific domains, add NSExceptionDomains
//        var exceptionDomainsDict: [String: Any] = [:]
//        // Example domain "example.com"
//        var exampleDomainDict: [String: Any] = [:]
//        exampleDomainDict["NSIncludesSubdomains"] = true
//        exampleDomainDict["NSTemporaryExceptionAllowsInsecureHTTPLoads"] = true
//        // Add more domains if needed
//        
//        // Add example domain to exception domains
//        exceptionDomainsDict["example.com"] = exampleDomainDict
//        // Add more domains if needed
//        
//        // Add exception domains to app transport security dictionary
//        appTransportSecurityDict["NSExceptionDomains"] = exceptionDomainsDict
//        
//        // Add NSAppTransportSecurity dictionary to Info.plist
//        infoDict["NSAppTransportSecurity"] = appTransportSecurityDict
//        
//        // Update Info.plist with the modified dictionary
//        if let plistPath = Bundle.main.url(forResource: "Info", withExtension: "plist"),
//           let data = try? PropertyListSerialization.data(fromPropertyList: infoDict, format: .xml, options: 0) {
//            do {
//                try data.write(to: plistPath, options: .atomic)
//                print("NSAppTransportSecurity configured successfully.")
//            } catch {
//                print("Error writing to Info.plist: \(error)")
//            }
//        }
//    }

    // Call the function where appropriate


}

