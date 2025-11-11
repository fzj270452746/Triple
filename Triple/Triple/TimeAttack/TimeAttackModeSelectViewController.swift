//
//  TimeAttackModeSelectViewController.swift
//  Triple
//
//  Time Attack 难度选择界面
//

import UIKit

class TimeAttackModeSelectViewController: BaseViewController {
    
    // MARK: - UI组件
    private lazy var titleLabel: UILabel = {
        let config = LabelConfig(
            text: "⏱️ Time Attack",
            fontSize: 42,
            weight: .bold,
            numberOfLines: 0,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 4), opacity: 0.9, radius: 6)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let config = LabelConfig(
            text: "Get the highest score within the time limit!\nChoose your difficulty:",
            fontSize: 18,
            weight: .medium,
            color: UIColor.white.withAlphaComponent(0.9),
            numberOfLines: 0
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var difficultyStack: UIStackView = {
        return UIFactory.createStackView(axis: .vertical, spacing: 20)
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        showsBackButton = true
        setupUI()
        setupConstraints()
        setupDifficultyButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateEntrance()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        [titleLabel, descriptionLabel, difficultyStack].forEach { view.addSubview($0) }
        
        // 确保返回按钮在最上层
        if showsBackButton {
            view.bringSubviewToFront(backButton)
        }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let spacing = AdaptiveLayoutHelper.calculateSpacing(base: 20)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            
            difficultyStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: spacing * 2),
            difficultyStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing * 2),
            difficultyStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing * 2)
        ])
    }
    
    private let difficulties: [TimeAttackDifficulty] = [.bronze, .silver, .gold]
    
    private func setupDifficultyButtons() {
        for difficulty in difficulties {
            let button = createDifficultyButton(for: difficulty)
            difficultyStack.addArrangedSubview(button)
        }
    }
    
    private func createDifficultyButton(for difficulty: TimeAttackDifficulty) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // 背景容器
        let bgConfig = ContainerConfig(
            backgroundColor: UIColor.white.withAlphaComponent(0.15),
            cornerRadius: 20,
            borderWidth: 3,
            borderColor: getDifficultyColor(difficulty).withAlphaComponent(0.6)
        )
        let background = UIFactory.createContainerView(config: bgConfig)
        
        // 图标标签
        let iconLabel = UILabel()
        iconLabel.text = difficulty.icon
        iconLabel.font = UIFont.systemFont(ofSize: 60)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 难度名称
        let nameLabel = UILabel()
        nameLabel.text = difficulty.displayName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 描述
        let descLabel = UILabel()
        descLabel.text = difficulty.description
        descLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        descLabel.numberOfLines = 2
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(background)
        background.addSubview(iconLabel)
        background.addSubview(nameLabel)
        background.addSubview(descLabel)
        
        LayoutManager.fillSuperview(background, in: container)
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 25),
            iconLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 20),
            
            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
            descLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -20),
            
            container.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(difficultyButtonTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.tag = difficulties.firstIndex(of: difficulty) ?? 0
        
        // 添加触摸反馈
        container.isUserInteractionEnabled = true
        
        return container
    }
    
    private func getDifficultyColor(_ difficulty: TimeAttackDifficulty) -> UIColor {
        switch difficulty {
        case .bronze: return UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0)
        case .silver: return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        case .gold: return UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        }
    }
    
    private func animateEntrance() {
        AnimationManager.slideFromTop(titleLabel, delay: 0.1)
        AnimationManager.slideFromTop(descriptionLabel, delay: 0.3)
        
        for (index, view) in difficultyStack.arrangedSubviews.enumerated() {
            AnimationManager.slideFromLeft(view, delay: 0.5 + Double(index) * 0.15)
        }
    }
    
    // MARK: - 操作
    @objc private func difficultyButtonTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let difficulties: [TimeAttackDifficulty] = [.bronze, .silver, .gold]
        let difficulty = difficulties[view.tag]
        
        AnimationManager.pulse(view, scale: 0.95, duration: 0.2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.startGame(with: difficulty)
        }
    }
    
    private func startGame(with difficulty: TimeAttackDifficulty) {
        let timeAttackVC = TimeAttackViewController(difficulty: difficulty)
        navigationController?.pushViewController(timeAttackVC, animated: true)
    }
}

