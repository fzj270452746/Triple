//
//  GuideViewController.swift
//  Triple
//
//  重构后的游戏指南控制器
//

import UIKit

class GuideViewController: BaseViewController {
    
    // MARK: - UI组件
    private lazy var titleLabel: UILabel = {
        let config = LabelConfig(
            text: "How to Play",
            fontSize: 36,
            weight: .bold,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 3), opacity: 0.9, radius: 5)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.indicatorStyle = .white
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIFactory.createStackView(axis: .vertical, spacing: 20)
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        showsBackButton = true
        setupUI()
        setupConstraints()
        populateGuideContent()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // 确保返回按钮在最上层
        if showsBackButton {
            view.bringSubviewToFront(backButton)
        }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
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
    
    // MARK: - 内容填充
    private func populateGuideContent() {
        let guideSections: [(String, String)] = [
            ("Objective", "Eliminate mahjong tiles by selecting the highest value tile in each column before they reach the bottom of the container."),
            ("Game Mechanics", "• Three columns of mahjong tiles descend from top to bottom\n• Each column starts with 2 tiles\n• New tiles appear periodically at the top\n• When tiles reach the container edge, the game ends"),
            ("How to Eliminate Tiles", "• Tap any tile in a column to eliminate it\n• You can ONLY eliminate the tile with the HIGHEST value in that column\n• Successfully eliminated tiles earn you points\n• If a column becomes empty, 2 new tiles will appear"),
            ("Special Tools", "• Delete One (deleteOne icon): Removes all tiles from a selected column\n• Delete All (deleteAll icon): Clears all tiles from all three columns\n• Use these tools strategically to prevent game over"),
            ("Game Modes", "• Fast Mode: Tiles descend quickly for intense gameplay\n• Slow Mode: Tiles descend slowly for relaxed gameplay\n• Choose your preferred speed at the start of each game"),
            ("Scoring System", "• Eliminating a tile: +10 points × tile value\n• Using Delete One tool: +5 points per tile\n• Using Delete All tool: +8 points per tile\n• Higher scores unlock better rankings in Records")
        ]
        
        guideSections.forEach { title, content in
            contentStackView.addArrangedSubview(createGuideSection(title: title, content: content))
        }
    }
    
    private func createGuideSection(title: String, content: String) -> UIView {
        let config = ContainerConfig(
            backgroundColor: UIColor.white.withAlphaComponent(0.15),
            cornerRadius: 15,
            borderWidth: 2,
            borderColor: UIColor.white.withAlphaComponent(0.3)
        )
        let container = UIFactory.createContainerView(config: config)
        
        let titleConfig = LabelConfig(
            text: title,
            fontSize: 22,
            weight: .bold,
            color: UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0),
            numberOfLines: 0,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 1), opacity: 0.8, radius: 2)
        )
        let titleLabel = UIFactory.createLabel(config: titleConfig)
        
        let contentConfig = LabelConfig(
            text: content,
            fontSize: 16,
            weight: .regular,
            color: .white,
            alignment: .left,
            numberOfLines: 0,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 1), opacity: 0.6, radius: 2)
        )
        let contentLabel = UIFactory.createLabel(config: contentConfig)
        
        container.addSubview(titleLabel)
        container.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15)
        ])
        
        return container
    }
}

