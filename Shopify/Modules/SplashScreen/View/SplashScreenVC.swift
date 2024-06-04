//
//  SplashScreenVC.swift
//  Shopify
//
//  Created by Sara Talat on 05/06/2024.
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
        
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(goToSignUpVC), userInfo: nil, repeats: false)
    }
    
    @objc func goToSignUpVC(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let signUpVC = sb.instantiateViewController(withIdentifier: "OnboardingContentViewController")
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
