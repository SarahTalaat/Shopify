//
//  OnboardingUIPageViewController.swift
//  Shopify
//
//  Created by Sara Talat on 05/06/2024.
//
import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    // Add your onboarding content here (images, titles, descriptions)
    private let onboardingContent = [
        OnboardingContent(imageName: "onboarding1", title: "Welcome", description: "Welcome to our app!"),
        OnboardingContent(imageName: "onboarding2", title: "Get Started", description: "Let's get started with the onboarding!"),
        OnboardingContent(imageName: "onboarding3", title: "Enjoy", description: "Enjoy using our app!")
    ]
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to white
        view.backgroundColor = .white
        
        setupScrollView()
        setupPageControl()
        addOnboardingContent()
    }
    
    // MARK: - Setup Methods
    
    private func setupScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(onboardingContent.count), height: view.frame.height)
        view.addSubview(scrollView)
    }
    
    private func setupPageControl() {
        pageControl.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 50)
        pageControl.numberOfPages = onboardingContent.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
    }
    
    private func addOnboardingContent() {
        for (index, content) in onboardingContent.enumerated() {
            let imageView = UIImageView(image: UIImage(named: content.imageName))
            imageView.frame = CGRect(x: CGFloat(index) * view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
            
            let titleLabel = UILabel(frame: CGRect(x: CGFloat(index) * view.frame.width + 20, y: 100, width: view.frame.width - 40, height: 40))
            titleLabel.text = content.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            titleLabel.textAlignment = .center
            scrollView.addSubview(titleLabel)
            
            let descriptionLabel = UILabel(frame: CGRect(x: CGFloat(index) * view.frame.width + 20, y: 150, width: view.frame.width - 40, height: 100))
            descriptionLabel.text = content.description
            descriptionLabel.font = UIFont.systemFont(ofSize: 16)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .center
            scrollView.addSubview(descriptionLabel)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

// Struct to hold onboarding content
struct OnboardingContent {
    let imageName: String
    let title: String
    let description: String
}
