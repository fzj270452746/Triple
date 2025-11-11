//
//  GuideViewController.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class GuideViewController: UIViewController {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tripleImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dimmerOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How to Play"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 3)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 5
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.indicatorStyle = .white
        return scrollView
    }()
    
    let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let retreatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("← Back", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 0.8)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 3
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        establishInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func establishInterface() {
        view.addSubview(backgroundImageView)
        view.addSubview(dimmerOverlay)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        view.addSubview(retreatButton)
        
        scrollView.addSubview(contentStackView)
        
        retreatButton.addTarget(self, action: #selector(retreatTapped), for: .touchUpInside)
        
        establishConstraints()
        populateGuideContent()
    }
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dimmerOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            dimmerOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmerOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmerOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            retreatButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            retreatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            retreatButton.widthAnchor.constraint(equalToConstant: 100),
            retreatButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: retreatButton.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func populateGuideContent() {
        let sections: [(String, String)] = [
            ("🎯 Objective", "Eliminate mahjong tiles by selecting the highest value tile in each column before they reach the bottom of the container."),
            
            ("🎮 Game Mechanics", "• Three columns of mahjong tiles descend from top to bottom\n• Each column starts with 2 tiles\n• New tiles appear periodically at the top\n• When tiles reach the container edge, the game ends"),
            
            ("🎴 How to Eliminate Tiles", "• Tap any tile in a column to eliminate it\n• You can ONLY eliminate the tile with the HIGHEST value in that column\n• Successfully eliminated tiles earn you points\n• If a column becomes empty, 2 new tiles will appear"),
            
            ("🔧 Special Tools", "• Delete One (deleteOne icon): Removes all tiles from a selected column\n• Delete All (deleteAll icon): Clears all tiles from all three columns\n• Use these tools strategically to prevent game over"),
            
            ("⚡️ Game Modes", "• Fast Mode: Tiles descend quickly for intense gameplay\n• Slow Mode: Tiles descend slowly for relaxed gameplay\n• Choose your preferred speed at the start of each game"),
            
            ("🏆 Scoring System", "• Eliminating a tile: +10 points × tile value\n• Using Delete One tool: +5 points per tile\n• Using Delete All tool: +8 points per tile\n• Higher scores unlock better rankings in Records"),
            
          
        ]
        
        for (title, content) in sections {
            let sectionView = fabricateGuideSection(title: title, content: content)
            contentStackView.addArrangedSubview(sectionView)
        }
    }
    
    func fabricateGuideSection(title: String, content: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowRadius = 2
        
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.layer.shadowColor = UIColor.black.cgColor
        contentLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentLabel.layer.shadowOpacity = 0.6
        contentLabel.layer.shadowRadius = 2
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        ])
        
        return containerView
    }
    
    @objc func retreatTapped() {
        navigationController?.popViewController(animated: true)
    }
}

