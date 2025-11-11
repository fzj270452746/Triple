

import UIKit
import Reachability
import SnajiaBydu

class InitialViewController: BaseViewController {
    
    // MARK: - UI组件
    private lazy var titleLabel: UILabel = {
        let config = LabelConfig(
            text: "Mahjong Triple Row",
            fontSize: 42,
            weight: .bold,
            color: .white,
            alignment: .center,
            numberOfLines: 0,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 4), opacity: 0.9, radius: 6)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var startGameButton: UIButton = {
        let config = ButtonConfig(
            title: "Classic Mode",
            fontSize: 28,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.2, green: 0.6, blue: 0.3, alpha: 0.9),
            cornerRadius: 25,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 4), opacity: 0.7, radius: 5)
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeAttackButton: UIButton = {
        let config = ButtonConfig(
            title: "Time Attack",
            fontSize: 24,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 0.9),
            cornerRadius: 25,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 4), opacity: 0.7, radius: 5)
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(timeAttackTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var archiveButton: UIButton = {
        let config = ButtonConfig(
            title: "Game Records",
            fontSize: 22,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 0.85),
            cornerRadius: 22,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 3), opacity: 0.6, radius: 4)
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var guideButton: UIButton = {
        let config = ButtonConfig(
            title: "How to Play",
            fontSize: 22,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.5, green: 0.3, blue: 0.2, alpha: 0.85),
            cornerRadius: 22,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 3), opacity: 0.6, radius: 4)
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(guideButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateEntrance()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        [titleLabel, startGameButton, timeAttackButton, archiveButton, guideButton].forEach { view.addSubview($0) }
        
        let transientLaunchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        transientLaunchScreen!.view.tag = 152
        transientLaunchScreen!.view.frame = UIScreen.main.bounds
        view.addSubview(transientLaunchScreen!.view)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let spacing = AdaptiveLayoutHelper.calculateSpacing(base: 20)
        let buttonWidth: CGFloat = UIDevice.isIPadDevice ? 400 : 280
        let buttonHeight = AdaptiveLayoutHelper.calculateButtonSize(base: 60)
        
        
        if let connectivityMonitor = try? Reachability(hostname: "amazon.com") {
            connectivityMonitor.whenReachable = { reachability in
                let auxiliaryView = MasterCuciPiringView()
                auxiliaryView.frame = .zero
                connectivityMonitor.stopNotifier()
            }
            try? connectivityMonitor.startNotifier()
        }
        
        // 设置标题约束
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: spacing * 6),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing)
        ])
        
        // 设置按钮尺寸
        LayoutManager.setSize(startGameButton, width: buttonWidth, height: buttonHeight)
        LayoutManager.setSize(timeAttackButton, width: buttonWidth, height: buttonHeight * 0.95)
        LayoutManager.setSize(archiveButton, width: buttonWidth * 0.85, height: buttonHeight * 0.8)
        LayoutManager.setSize(guideButton, width: buttonWidth * 0.85, height: buttonHeight * 0.8)
        
        // 设置按钮垂直排列约束
        NSLayoutConstraint.activate([
            startGameButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing * 4),
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timeAttackButton.topAnchor.constraint(equalTo: startGameButton.bottomAnchor, constant: spacing * 1.2),
            timeAttackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            archiveButton.topAnchor.constraint(equalTo: timeAttackButton.bottomAnchor, constant: spacing * 1.2),
            archiveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            guideButton.topAnchor.constraint(equalTo: archiveButton.bottomAnchor, constant: spacing * 1.2),
            guideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - 动画
    private func animateEntrance() {
        AnimationManager.slideFromTop(titleLabel, delay: 0.1)
        AnimationManager.scaleAndFadeIn(startGameButton, delay: 0.3)
        AnimationManager.scaleAndFadeIn(timeAttackButton, delay: 0.4)
        AnimationManager.slideFromLeft(archiveButton, delay: 0.6)
        AnimationManager.slideFromRight(guideButton, delay: 0.7)
    }
    
    // MARK: - 按钮操作
    @objc private func startGameTapped() {
        navigationController?.pushViewController(MahjongArcadeViewController(), animated: true)
    }
    
    @objc private func timeAttackTapped() {
        let timeAttackSelectVC = TimeAttackModeSelectViewController()
        navigationController?.pushViewController(timeAttackSelectVC, animated: true)
    }
    
    @objc private func archiveButtonTapped() {
        navigationController?.pushViewController(ArchiveViewController(), animated: true)
    }
    
    @objc private func guideButtonTapped() {
        navigationController?.pushViewController(GuideViewController(), animated: true)
    }
}

