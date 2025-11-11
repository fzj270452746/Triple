//
//  MahjongArcadeViewController.swift
//  Triple
//
//  重构后的游戏控制器
//

import UIKit

class MahjongArcadeViewController: BaseViewController {
    
    // MARK: - 属性
    let gameManager = GameManager()
    var columnViews: [UITableView] = []
    var columnBackgroundViews: [UIView] = []
    var shouldDisplayMagnitudes: Bool = false
    
    let columnHues: [UIColor] = [
        UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 0.3),
        UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 0.3),
        UIColor(red: 0.3, green: 0.7, blue: 0.5, alpha: 0.3)
    ]
    
    // MARK: - UI组件
    lazy var scoreLabel: UILabel = {
        let config = LabelConfig(
            text: "Score: 0",
            fontSize: 28,
            weight: .bold,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 2), opacity: 0.8, radius: 4)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    lazy var toggleMagnitudeButton: UIButton = {
        let config = ButtonConfig(
            title: "👁 Show Numbers",
            fontSize: 16,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 0.85),
            cornerRadius: 22,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 3), opacity: 0.6, radius: 4)
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(toggleMagnitudeDisplayTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var columnsStackView: UIStackView = {
        return UIFactory.createStackView(axis: .horizontal, spacing: 12, distribution: .fillEqually)
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        showsBackButton = true
        gameManager.delegate = self
        setupUI()
        setupConstraints()
        showVelocitySelection()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        [scoreLabel, columnsStackView, toggleMagnitudeButton].forEach { view.addSubview($0) }
        setupColumnViews()
        
        // 确保返回按钮在最上层
        if showsBackButton {
            view.bringSubviewToFront(backButton)
        }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let spacing = AdaptiveLayoutHelper.calculateSpacing(base: 20)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            columnsStackView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: spacing),
            columnsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            columnsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            columnsStackView.bottomAnchor.constraint(equalTo: toggleMagnitudeButton.topAnchor, constant: -spacing),
            
            toggleMagnitudeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleMagnitudeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -spacing)
        ])
        
        LayoutManager.setSize(toggleMagnitudeButton, width: AdaptiveLayoutHelper.calculateButtonSize(base: 160), height: 44)
    }
    
    private func setupColumnViews() {
        for i in 0..<3 {
            let container = createColumnContainer(index: i)
            let tableView = createColumnTableView(index: i)
            
            container.addSubview(tableView)
            columnsStackView.addArrangedSubview(container)
            
            LayoutManager.applyEdgeInsets(tableView, in: container, insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
            
            columnViews.append(tableView)
            columnBackgroundViews.append(container)
        }
    }
    
    private func createColumnContainer(index: Int) -> UIView {
        let config = ContainerConfig(
            backgroundColor: columnHues[index],
            cornerRadius: 15,
            borderWidth: 2,
            borderColor: UIColor.white.withAlphaComponent(0.5)
        )
        return UIFactory.createContainerView(config: config)
    }
    
    private func createColumnTableView(index: Int) -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = index
        tableView.register(VestigeTileCell.self, forCellReuseIdentifier: "VestigeTileCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        return tableView
    }
    
    // MARK: - 重写方法
    override func handleBackAction() {
        gameManager.endGame(saveRecord: false)
        super.handleBackAction()
    }
}

