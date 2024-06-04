//
//  OnboardingViewController.swift
//  Shopify
//
//  Created by Sara Talat on 05/06/2024.
//

import UIKit

class OnboardingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    
    let images = ["girl.jpg", "salah.jpg", "girl.png"] // Replace with your image names
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create page view controller
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Set initial view controller
        if let firstViewController = viewControllerAtIndex(0) {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // Add page view controller to the view hierarchy
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        // Create page control
        pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        // Add constraints for page control
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            pageControl.widthAnchor.constraint(equalToConstant: 200),
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - UIPageViewControllerDataSource Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = (viewController as? OnboardingContentViewController)?.pageIndex, index > 0 {
            return viewControllerAtIndex(index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = (viewController as? OnboardingContentViewController)?.pageIndex, index < images.count - 1 {
            return viewControllerAtIndex(index + 1)
        }
        return nil
    }
    
    // MARK: - Helper Methods
    
    func viewControllerAtIndex(_ index: Int) -> OnboardingContentViewController? {
        guard index >= 0 && index < images.count else {
            return nil
        }
        let viewController = storyboard?.instantiateViewController(withIdentifier: "OnboardingContentViewController") as? OnboardingContentViewController
        viewController?.pageIndex = index
        viewController?.imageName = images[index]
        return viewController
    }
    
    // MARK: - UIPageViewControllerDelegate Methods
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return images.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pageControl.currentPage
    }
}

class OnboardingContentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex: Int?
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
        }
    }
}
