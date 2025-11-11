//
//  TimeAttackViewController.swift
//  Triple
//
//  限时冲刺模式控制器
//

import UIKit

class TimeAttackViewController: BaseViewController {
    
    // MARK: - 属性
    let gameManager = GameManager()
    var columnViews: [UITableView] = []
    var columnBackgroundViews: [UIView] = []
    var shouldDisplayMagnitudes: Bool = true // Time Attack 默认显示数字
    var difficulty: TimeAttackDifficulty = .bronze
    
    let columnHues: [UIColor] = [
        UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 0.3),
        UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 0.3),
        UIColor(red: 0.3, green: 0.7, blue: 0.5, alpha: 0.3)
    ]
    
    // MARK: - UI组件
    lazy var timerLabel: UILabel = {
        let config = LabelConfig(
            text: "60.0",
            fontSize: 48,
            weight: .bold,
            color: .white,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 3), opacity: 0.9, radius: 5)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    lazy var scoreLabel: UILabel = {
        let config = LabelConfig(
            text: "Score: 0",
            fontSize: 24,
            weight: .bold,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 2), opacity: 0.8, radius: 4)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    lazy var targetLabel: UILabel = {
        let config = LabelConfig(
            text: "Target: 1000",
            fontSize: 18,
            weight: .medium,
            color: UIColor.white.withAlphaComponent(0.9),
            hasShadow: true
        )
        return UIFactory.createLabel(config: config)
    }()
    
    lazy var comboLabel: UILabel = {
        let config = LabelConfig(
            text: "",
            fontSize: 32,
            weight: .bold,
            color: UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0),
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 2), opacity: 0.9, radius: 4)
        )
        let label = UIFactory.createLabel(config: config)
        label.alpha = 0
        return label
    }()
    
    lazy var multiplierLabel: UILabel = {
        let config = LabelConfig(
            text: "×1.0",
            fontSize: 20,
            weight: .bold,
            color: UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        )
        let label = UIFactory.createLabel(config: config)
        label.alpha = 0
        return label
    }()
    
    lazy var columnsStackView: UIStackView = {
        return UIFactory.createStackView(axis: .horizontal, spacing: 12, distribution: .fillEqually)
    }()
    
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progressTintColor = UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1.0)
        progress.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progress.transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        return progress
    }()
    
    // MARK: - 初始化
    convenience init(difficulty: TimeAttackDifficulty) {
        self.init()
        self.difficulty = difficulty
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        showsBackButton = true
        gameManager.delegate = self
        setupUI()
        setupConstraints()
        updateTargetLabel()
        
        // 延迟开始游戏，显示倒计时
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.showCountdownAndStart()
        }
    }
    
    // MARK: - UI设置
    private func setupUI() {
        [timerLabel, scoreLabel, targetLabel, comboLabel, multiplierLabel, 
         columnsStackView, progressView].forEach { view.addSubview($0) }
        setupColumnViews()
        
        // 确保返回按钮在最上层
        if showsBackButton {
            view.bringSubviewToFront(backButton)
        }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let spacing = AdaptiveLayoutHelper.calculateSpacing(base: 15)
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 8),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            targetLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 4),
            targetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            progressView.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing * 2),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing * 2),
            
            comboLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            comboLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            multiplierLabel.topAnchor.constraint(equalTo: comboLabel.bottomAnchor, constant: 2),
            multiplierLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            columnsStackView.topAnchor.constraint(equalTo: multiplierLabel.bottomAnchor, constant: spacing),
            columnsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            columnsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            columnsStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -spacing)
        ])
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
    
    // MARK: - 游戏控制
    private func showCountdownAndStart() {
        let countdown = ["3", "2", "1", "GO!"]
        var index = 0
        
        let countdownLabel = UILabel()
        countdownLabel.font = UIFont.boldSystemFont(ofSize: 80)
        countdownLabel.textColor = .white
        countdownLabel.textAlignment = .center
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdownLabel)
        LayoutManager.centerInSuperview(countdownLabel, in: view)
        
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] timer in
            guard index < countdown.count else {
                timer.invalidate()
                UIView.animate(withDuration: 0.3, animations: {
                    countdownLabel.alpha = 0
                }) { _ in
                    countdownLabel.removeFromSuperview()
                }
                self?.startGame()
                return
            }
            
            countdownLabel.text = countdown[index]
            countdownLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            countdownLabel.alpha = 0
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, 
                          initialSpringVelocity: 0.8, options: .curveEaseOut) {
                countdownLabel.transform = .identity
                countdownLabel.alpha = 1
            }
            
            index += 1
        }
    }
    
    private func startGame() {
        let config = GameConfiguration.timeAttack(difficulty: difficulty)
        gameManager.startGame(configuration: config)
    }
    
    func updateTargetLabel() {
        targetLabel.text = "Target: \(difficulty.targetScore)"
        timerLabel.text = String(format: "%.1f", difficulty.timeLimit)
    }
    
    func updateProgressBar() {
        let progress = Float(gameManager.currentScore) / Float(difficulty.targetScore)
        progressView.setProgress(min(progress, 1.0), animated: true)
        
        if progress >= 1.0 {
            progressView.progressTintColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        }
    }
    
    override func handleBackAction() {
        let confirmAction = UIAlertAction(title: "Quit", style: .destructive) { [weak self] _ in
            self?.gameManager.endGame(saveRecord: false)
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Continue", style: .cancel)
        
        showAlert(title: "Quit Game?", message: "Your progress will not be saved.", 
                 actions: [confirmAction, cancelAction])
    }
}

// MARK: - TableView数据源和代理
extension TimeAttackViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameManager.getTiles(for: tableView.tag).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VestigeTileCell", for: indexPath) as! VestigeTileCell
        let tiles = gameManager.getTiles(for: tableView.tag)
        if indexPath.row < tiles.count {
            cell.configureWithVestige(tiles[indexPath.row], showMagnitude: shouldDisplayMagnitudes)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptiveLayoutHelper.calculateTileSize() + 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = gameManager.handleTileSelection(at: indexPath, column: tableView.tag)
    }
}

