//
//  TimeAttackResultViewController.swift
//  Triple
//
//  Time Attack 结果界面
//

import UIKit

class TimeAttackResultViewController: BaseViewController {
    
    private let result: GameResult
    private let difficulty: TimeAttackDifficulty
    
    // MARK: - UI组件
    private lazy var titleLabel: UILabel = {
        let text = result.isTargetAchieved ? "🎉 SUCCESS!" : "Time's Up!"
        let config = LabelConfig(
            text: text,
            fontSize: 48,
            weight: .bold,
            color: result.isTargetAchieved ? 
                UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) : .white,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 4), opacity: 0.9, radius: 6)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var scoreLabel: UILabel = {
        let config = LabelConfig(
            text: "Score: \(result.score)",
            fontSize: 36,
            weight: .bold,
            hasShadow: true
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var targetLabel: UILabel = {
        let progress = Double(result.score) / Double(difficulty.targetScore) * 100
        let text = String(format: "Target: %d (%.1f%%)", difficulty.targetScore, progress)
        let config = LabelConfig(
            text: text,
            fontSize: 22,
            weight: .medium,
            color: UIColor.white.withAlphaComponent(0.9)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var comboLabel: UILabel = {
        let config = LabelConfig(
            text: "Max Combo: ×\(result.maxCombo)",
            fontSize: 24,
            weight: .bold,
            color: UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var achievementsStack: UIStackView = {
        return UIFactory.createStackView(axis: .vertical, spacing: 12)
    }()
    
    private lazy var retryButton: UIButton = {
        let config = ButtonConfig(
            title: "🔄 Retry",
            fontSize: 24,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 0.9),
            cornerRadius: 25,
            hasShadow: true
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeDifficultyButton: UIButton = {
        let config = ButtonConfig(
            title: "⚙️ Change Difficulty",
            fontSize: 20,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.5, green: 0.4, blue: 0.7, alpha: 0.85),
            cornerRadius: 22,
            hasShadow: true
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(changeDifficultyTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let config = ButtonConfig(
            title: "🏠 Back to Menu",
            fontSize: 20,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 0.85),
            cornerRadius: 22,
            hasShadow: true
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(backToMenuTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 初始化
    init(result: GameResult, difficulty: TimeAttackDifficulty) {
        self.result = result
        self.difficulty = difficulty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateAchievements()
        animateEntrance()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        [titleLabel, scoreLabel, targetLabel, comboLabel, achievementsStack,
         retryButton, changeDifficultyButton, menuButton].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let spacing = AdaptiveLayoutHelper.calculateSpacing(base: 20)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: spacing * 2),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            targetLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 12),
            targetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            comboLabel.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 12),
            comboLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            achievementsStack.topAnchor.constraint(equalTo: comboLabel.bottomAnchor, constant: spacing * 1.5),
            achievementsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing * 2),
            achievementsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing * 2),
            
            menuButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -spacing),
            menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            changeDifficultyButton.bottomAnchor.constraint(equalTo: menuButton.topAnchor, constant: -spacing),
            changeDifficultyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            retryButton.bottomAnchor.constraint(equalTo: changeDifficultyButton.topAnchor, constant: -spacing),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        LayoutManager.setSize(retryButton, width: 250, height: 60)
        LayoutManager.setSize(changeDifficultyButton, width: 280, height: 50)
        LayoutManager.setSize(menuButton, width: 280, height: 50)
    }
    
    private func populateAchievements() {
        if result.achievements.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "Keep practicing!"
            emptyLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            emptyLabel.textColor = UIColor.white.withAlphaComponent(0.7)
            emptyLabel.textAlignment = .center
            achievementsStack.addArrangedSubview(emptyLabel)
        } else {
            for achievement in result.achievements {
                let achievementView = createAchievementView(text: achievement)
                achievementsStack.addArrangedSubview(achievementView)
            }
        }
    }
    
    private func createAchievementView(text: String) -> UIView {
        let config = ContainerConfig(
            backgroundColor: UIColor.white.withAlphaComponent(0.2),
            cornerRadius: 15,
            borderWidth: 2,
            borderColor: UIColor.white.withAlphaComponent(0.4)
        )
        let container = UIFactory.createContainerView(config: config)
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        LayoutManager.applyEdgeInsets(label, in: container, insets: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
        
        return container
    }
    
    private func animateEntrance() {
        AnimationManager.scaleAndFadeIn(titleLabel, fromScale: 0.5, delay: 0.1)
        AnimationManager.slideFromTop(scoreLabel, delay: 0.3)
        AnimationManager.slideFromTop(targetLabel, delay: 0.4)
        AnimationManager.slideFromTop(comboLabel, delay: 0.5)
        
        for (index, view) in achievementsStack.arrangedSubviews.enumerated() {
            AnimationManager.slideFromLeft(view, delay: 0.6 + Double(index) * 0.1)
        }
        
        AnimationManager.slideFromRight(retryButton, delay: 0.9)
        AnimationManager.slideFromRight(changeDifficultyButton, delay: 1.0)
        AnimationManager.slideFromRight(menuButton, delay: 1.1)
    }
    
    // MARK: - 操作
    @objc private func retryTapped() {
        let timeAttackVC = TimeAttackViewController(difficulty: difficulty)
        if let nav = presentingViewController as? UINavigationController {
            dismiss(animated: true) {
                nav.pushViewController(timeAttackVC, animated: true)
            }
        }
    }
    
    @objc private func changeDifficultyTapped() {
        dismiss(animated: true) {
            if let nav = (self.presentingViewController as? UINavigationController) {
                nav.popViewController(animated: false)
            }
        }
    }
    
    @objc private func backToMenuTapped() {
        dismiss(animated: true) {
            if let nav = (self.presentingViewController as? UINavigationController) {
                nav.popToRootViewController(animated: true)
            }
        }
    }
}

