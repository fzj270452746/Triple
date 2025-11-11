//
//  MahjongArcadeViewController+Setup.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension MahjongArcadeViewController {
    
    // MARK: - Interface Setup
    func establishInterface() {
        view.addSubview(backgroundImageView)
        view.addSubview(dimmerOverlay)
        view.addSubview(tallyLabel)
        view.addSubview(columnsStackView)
        view.addSubview(toggleMagnitudeButton)
        view.addSubview(retreatButton)
        
        establishConstraints()
        fabricateColumnViews()
        attachActionHandlers()
    }
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let spacing = AdaptiveLayoutHelper.calculateSpacing(base: 20)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dimmerOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            dimmerOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmerOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmerOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tallyLabel.topAnchor.constraint(equalTo: retreatButton.bottomAnchor, constant: 20),
            tallyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            columnsStackView.topAnchor.constraint(equalTo: tallyLabel.bottomAnchor, constant: spacing),
            columnsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            columnsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            columnsStackView.bottomAnchor.constraint(equalTo: toggleMagnitudeButton.topAnchor, constant: -spacing),
            
            toggleMagnitudeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleMagnitudeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -spacing),
            toggleMagnitudeButton.widthAnchor.constraint(equalToConstant: AdaptiveLayoutHelper.calculateButtonSize(base: 160)),
            toggleMagnitudeButton.heightAnchor.constraint(equalToConstant: 44),
            
            retreatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            retreatButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            retreatButton.widthAnchor.constraint(equalToConstant: 100),
            retreatButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        tallyLabel.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 28))
        retreatButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 18))
        toggleMagnitudeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 16))
    }
    
    func fabricateColumnViews() {
        for index in 0..<3 {
            let containerView = UIView()
            containerView.backgroundColor = columnHues[index]
            containerView.layer.cornerRadius = 15
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            let tableView = UITableView()
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tag = index
            tableView.register(VestigeTileCell.self, forCellReuseIdentifier: "VestigeTileCell")
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.showsVerticalScrollIndicator = false
            tableView.allowsSelection = true
            tableView.isScrollEnabled = false
            
            containerView.addSubview(tableView)
            columnsStackView.addArrangedSubview(containerView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
            ])
            
            columnViews.append(tableView)
            columnBackgroundViews.append(containerView)
        }
    }
    
    func attachActionHandlers() {
        toggleMagnitudeButton.addTarget(self, action: #selector(toggleMagnitudeDisplayTapped), for: .touchUpInside)
        retreatButton.addTarget(self, action: #selector(retreatTapped), for: .touchUpInside)
    }
    
    func presentVelocitySelectionPrompt() {
        let alertController = UIAlertController(title: "Select Game Speed", message: "Choose the velocity at which tiles descend", preferredStyle: .alert)
        
        let briskAction = UIAlertAction(title: "⚡️ Fast", style: .default) { [weak self] _ in
            self?.currentVelocity = .brisk
            self?.commenceGame()
        }
        
        let sluggishAction = UIAlertAction(title: "🐢 Slow", style: .default) { [weak self] _ in
            self?.currentVelocity = .sluggish
            self?.commenceGame()
        }
        
        alertController.addAction(briskAction)
        alertController.addAction(sluggishAction)
        present(alertController, animated: true)
    }
}

