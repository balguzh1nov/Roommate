//
//  SwipeViewController.swift
//  RoommateApplication
//
//  Created by Абай on 19.05.2023.
//


import UIKit

class SwipeViewController: UIViewController {
    private let swipeItems = [
        SwipeItem(image: "onboarding-1", headline: "CREATE YOUR OWN FOOD GUIDE", subheadline: "Pin your favorite restaurants and create your own food guide"),
        SwipeItem(image: "onboarding-2", headline: "SHOW YOU THE LOCATION", subheadline: "Search and locate your favourite restaurant on Maps"),
        SwipeItem(image: "onboarding-3", headline: "DISCOVER GREAT RESTAURANTS", subheadline: "Find restaurants shared by your friends and other foodies")
    ]
    
    private var currentPageIndex = 0
    
    private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black // Set desired title color
            return label
        }()
        
        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .darkGray // Set desired description color
            label.numberOfLines = 0 // Allow multiple lines for longer descriptions
            return label
        }()
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 8 // Apply corner radius to the image view
            imageView.clipsToBounds = true // Clip image to the rounded corners
            return imageView
        }()
        
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Previous", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal) // Set desired text color
        button.backgroundColor = .gray // Set desired background color
        button.layer.cornerRadius = 20 // Apply corner radius
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // Set desired font
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal) // Set desired text color
        button.backgroundColor = .blue // Set desired background color
        button.layer.cornerRadius = 20 // Apply corner radius
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // Set desired font
        return button
    }()

    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal) // Set desired text color
        button.backgroundColor = .white // Set desired background color
        button.layer.cornerRadius = 20 // Apply corner radius
        button.layer.borderWidth = 0.5 // Add border
        button.layer.borderColor = UIColor.blue.cgColor // Set border color
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // Set desired font
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) // Add padding
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updatePage()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(imageView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(startButton)
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

            titleLabel.numberOfLines = 0 // Allow multiple lines
            titleLabel.setContentHuggingPriority(.required, for: .vertical) // Increase vertical content hugging priority
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        previousButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        previousButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: previousButton.topAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 16).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        nextButton.widthAnchor.constraint(equalTo: previousButton.widthAnchor).isActive = true
        
        startButton.topAnchor.constraint(equalTo: previousButton.topAnchor).isActive = true
        startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        previousButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        previousButton.layer.cornerRadius = 20
        nextButton.layer.cornerRadius = 20
        startButton.layer.cornerRadius = 20
        
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        updatePage() // Update the page to reflect initial values
    }

    private func updatePage() {
        let swipeItem = swipeItems[currentPageIndex]
        titleLabel.text = swipeItem.headline
        descriptionLabel.text = swipeItem.subheadline
        imageView.image = UIImage(named: swipeItem.image)
        
        previousButton.isHidden = currentPageIndex == 0
        nextButton.isHidden = currentPageIndex == swipeItems.count - 1
        startButton.isHidden = currentPageIndex < swipeItems.count - 1
        
        previousButton.isEnabled = true // Enable the previous button by default
        
        if currentPageIndex == 0 {
            previousButton.isEnabled = false // Disable previous button on the first onboarding screen
        }
    }
    
    @objc private func previousButtonTapped() {
        currentPageIndex -= 1
        updatePage()
    }
    
    @objc private func nextButtonTapped() {
        if currentPageIndex < swipeItems.count - 1 {
            currentPageIndex += 1
            updatePage()
        } else {
            let homeController = HomeController()
            homeController.modalPresentationStyle = .fullScreen
            present(homeController, animated: true, completion: nil)
        }
    }
    
    @objc private func startButtonTapped() {
        let homeController = HomeController()
        homeController.modalPresentationStyle = .fullScreen
        present(homeController, animated: true, completion: nil)
    }
}

