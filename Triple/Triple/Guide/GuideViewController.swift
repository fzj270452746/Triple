//
//  GuideViewController.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class PedagogicalInstructionCompendiumController: UIViewController {
    
    let etherealBackdropImagery: UIImageView = {
        let imageryView = UIImageView()
        imageryView.image = UIImage(named: "tripleImage")
        imageryView.contentMode = .scaleAspectFill
        imageryView.translatesAutoresizingMaskIntoConstraints = false
        return imageryView
    }()
    
    let obscuringTintedVeil: UIView = {
        let veilView = UIView()
        veilView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        veilView.translatesAutoresizingMaskIntoConstraints = false
        return veilView
    }()
    
    let compendiumHeadlineInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.text = "How to Play"
        inscriptionLabel.font = UIFont.boldSystemFont(ofSize: 36)
        inscriptionLabel.textColor = .white
        inscriptionLabel.textAlignment = .center
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        inscriptionLabel.layer.shadowColor = UIColor.black.cgColor
        inscriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        inscriptionLabel.layer.shadowOpacity = 0.9
        inscriptionLabel.layer.shadowRadius = 5
        return inscriptionLabel
    }()
    
    let verticalScrollableViewport: UIScrollView = {
        let scrollableViewport = UIScrollView()
        scrollableViewport.translatesAutoresizingMaskIntoConstraints = false
        scrollableViewport.showsVerticalScrollIndicator = true
        scrollableViewport.indicatorStyle = .white
        return scrollableViewport
    }()
    
    let contentAggregationStack: UIStackView = {
        let stackAggregation = UIStackView()
        stackAggregation.axis = .vertical
        stackAggregation.spacing = 20
        stackAggregation.translatesAutoresizingMaskIntoConstraints = false
        stackAggregation.layoutMargins = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        stackAggregation.isLayoutMarginsRelativeArrangement = true
        return stackAggregation
    }()
    
    let regressionNavigationTrigger: UIButton = {
        let triggerButton = UIButton(type: .system)
        triggerButton.setTitle("← Back", for: .normal)
        triggerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        triggerButton.setTitleColor(.white, for: .normal)
        triggerButton.backgroundColor = UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 0.8)
        triggerButton.layer.cornerRadius = 20
        triggerButton.translatesAutoresizingMaskIntoConstraints = false
        triggerButton.layer.shadowColor = UIColor.black.cgColor
        triggerButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        triggerButton.layer.shadowOpacity = 0.6
        triggerButton.layer.shadowRadius = 3
        return triggerButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orchestrateVisualizationHierarchy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func orchestrateVisualizationHierarchy() {
        view.addSubview(etherealBackdropImagery)
        view.addSubview(obscuringTintedVeil)
        view.addSubview(compendiumHeadlineInscription)
        view.addSubview(verticalScrollableViewport)
        view.addSubview(regressionNavigationTrigger)
        
        verticalScrollableViewport.addSubview(contentAggregationStack)
        
        regressionNavigationTrigger.addTarget(self, action: #selector(executeRegressionNavigation), for: .touchUpInside)
        
        establishGeometricConstraints()
        populateInstructionalContent()
    }
    
    func establishGeometricConstraints() {
        let protectedRegion = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            etherealBackdropImagery.topAnchor.constraint(equalTo: view.topAnchor),
            etherealBackdropImagery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            etherealBackdropImagery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            etherealBackdropImagery.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            obscuringTintedVeil.topAnchor.constraint(equalTo: view.topAnchor),
            obscuringTintedVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            obscuringTintedVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            obscuringTintedVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            regressionNavigationTrigger.topAnchor.constraint(equalTo: protectedRegion.topAnchor, constant: 10),
            regressionNavigationTrigger.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            regressionNavigationTrigger.widthAnchor.constraint(equalToConstant: 100),
            regressionNavigationTrigger.heightAnchor.constraint(equalToConstant: 40),
            
            compendiumHeadlineInscription.topAnchor.constraint(equalTo: regressionNavigationTrigger.bottomAnchor, constant: 20),
            compendiumHeadlineInscription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            verticalScrollableViewport.topAnchor.constraint(equalTo: compendiumHeadlineInscription.bottomAnchor, constant: 20),
            verticalScrollableViewport.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalScrollableViewport.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalScrollableViewport.bottomAnchor.constraint(equalTo: protectedRegion.bottomAnchor, constant: -20),
            
            contentAggregationStack.topAnchor.constraint(equalTo: verticalScrollableViewport.topAnchor),
            contentAggregationStack.leadingAnchor.constraint(equalTo: verticalScrollableViewport.leadingAnchor),
            contentAggregationStack.trailingAnchor.constraint(equalTo: verticalScrollableViewport.trailingAnchor),
            contentAggregationStack.bottomAnchor.constraint(equalTo: verticalScrollableViewport.bottomAnchor),
            contentAggregationStack.widthAnchor.constraint(equalTo: verticalScrollableViewport.widthAnchor)
        ])
    }
    
    func populateInstructionalContent() {
        let instructionalSegments: [(String, String)] = [
            ("🎯 Objective", "Eliminate mahjong tiles by selecting the highest value tile in each column before they reach the bottom of the container."),
            
            ("🎮 Game Mechanics", "• Three columns of mahjong tiles descend from top to bottom\n• Each column starts with 2 tiles\n• New tiles appear periodically at the top\n• When tiles reach the container edge, the game ends"),
            
            ("🎴 How to Eliminate Tiles", "• Tap any tile in a column to eliminate it\n• You can ONLY eliminate the tile with the HIGHEST value in that column\n• Successfully eliminated tiles earn you points\n• If a column becomes empty, 2 new tiles will appear"),
            
            ("🔧 Special Tools", "• Delete One (deleteOne icon): Removes all tiles from a selected column\n• Delete All (deleteAll icon): Clears all tiles from all three columns\n• Use these tools strategically to prevent game over"),
            
            ("⚡️ Game Modes", "• Fast Mode: Tiles descend quickly for intense gameplay\n• Slow Mode: Tiles descend slowly for relaxed gameplay\n• Choose your preferred speed at the start of each game"),
            
            ("🏆 Scoring System", "• Eliminating a tile: +10 points × tile value\n• Using Delete One tool: +5 points per tile\n• Using Delete All tool: +8 points per tile\n• Higher scores unlock better rankings in Records"),
        ]
        
        for (headlineText, contentText) in instructionalSegments {
            let segmentEncapsulation = fabricateInstructionalSegment(headline: headlineText, content: contentText)
            contentAggregationStack.addArrangedSubview(segmentEncapsulation)
        }
    }
    
    func fabricateInstructionalSegment(headline: String, content: String) -> UIView {
        let encapsulationContainer = UIView()
        encapsulationContainer.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        encapsulationContainer.layer.cornerRadius = 15
        encapsulationContainer.layer.borderWidth = 2
        encapsulationContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        encapsulationContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let headlineInscription = UILabel()
        headlineInscription.text = headline
        headlineInscription.font = UIFont.boldSystemFont(ofSize: 22)
        headlineInscription.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        headlineInscription.numberOfLines = 0
        headlineInscription.translatesAutoresizingMaskIntoConstraints = false
        headlineInscription.layer.shadowColor = UIColor.black.cgColor
        headlineInscription.layer.shadowOffset = CGSize(width: 0, height: 1)
        headlineInscription.layer.shadowOpacity = 0.8
        headlineInscription.layer.shadowRadius = 2
        
        let contentInscription = UILabel()
        contentInscription.text = content
        contentInscription.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentInscription.textColor = .white
        contentInscription.numberOfLines = 0
        contentInscription.translatesAutoresizingMaskIntoConstraints = false
        contentInscription.layer.shadowColor = UIColor.black.cgColor
        contentInscription.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentInscription.layer.shadowOpacity = 0.6
        contentInscription.layer.shadowRadius = 2
        
        encapsulationContainer.addSubview(headlineInscription)
        encapsulationContainer.addSubview(contentInscription)
        
        NSLayoutConstraint.activate([
            headlineInscription.topAnchor.constraint(equalTo: encapsulationContainer.topAnchor, constant: 15),
            headlineInscription.leadingAnchor.constraint(equalTo: encapsulationContainer.leadingAnchor, constant: 15),
            headlineInscription.trailingAnchor.constraint(equalTo: encapsulationContainer.trailingAnchor, constant: -15),
            
            contentInscription.topAnchor.constraint(equalTo: headlineInscription.bottomAnchor, constant: 10),
            contentInscription.leadingAnchor.constraint(equalTo: encapsulationContainer.leadingAnchor, constant: 15),
            contentInscription.trailingAnchor.constraint(equalTo: encapsulationContainer.trailingAnchor, constant: -15),
            contentInscription.bottomAnchor.constraint(equalTo: encapsulationContainer.bottomAnchor, constant: -15)
        ])
        
        return encapsulationContainer
    }
    
    @objc func executeRegressionNavigation() {
        navigationController?.popViewController(animated: true)
    }
}
