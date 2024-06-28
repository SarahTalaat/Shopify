//
//  SplashScreenVC.swift
//  Shopify
//
//  Created by Sara Talat on 05/06/2024.
//
//
import UIKit
import Lottie

class SplashScreenVC: UIViewController {

    @IBOutlet weak var animationLottieView: AnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        animationLottieView.contentMode = .scaleAspectFit
        animationLottieView.loopMode = .loop
        animationLottieView.play()


        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(goToOnboardingScreen), userInfo: nil, repeats: false)
    }


    @objc func goToOnboardingScreen(){
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
         let onboardingVC = sb.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true, completion: nil)

        
    }
}






