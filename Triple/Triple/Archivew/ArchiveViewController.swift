//
//  ArchiveViewController.swift
//  Triple
//
//  重构后的游戏记录控制器
//

import UIKit

class ArchiveViewController: BaseViewController {
    
    // MARK: - 属性
    private var archiveRecords: [ArchiveRecordModel] = []
    
    // MARK: - UI组件
    private lazy var titleLabel: UILabel = {
        let config = LabelConfig(
            text: "Game Records",
            fontSize: 32,
            weight: .bold,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 3), opacity: 0.9, radius: 5)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var recordsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArchiveRecordCell.self, forCellReuseIdentifier: "ArchiveRecordCell")
        return tableView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let config = LabelConfig(
            text: "No game records yet.\nStart playing to create records!",
            fontSize: 18,
            weight: .medium,
            numberOfLines: 0,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 2), opacity: 0.8, radius: 4)
        )
        let label = UIFactory.createLabel(config: config)
        label.isHidden = true
        return label
    }()
    
    private lazy var obliterateAllButton: UIButton = {
        let config = ButtonConfig(
            title: "🗑 Delete All",
            fontSize: 18,
            titleColor: .white,
            backgroundColor: UIColor.red.withAlphaComponent(0.7),
            cornerRadius: 25,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 3), opacity: 0.6, radius: 4)
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(obliterateAllTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        showsBackButton = true
        setupUI()
        setupConstraints()
        retrieveArchives()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveArchives()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        [titleLabel, recordsTableView, emptyStateLabel, obliterateAllButton].forEach { view.addSubview($0) }
        
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
            
            recordsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            recordsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recordsTableView.bottomAnchor.constraint(equalTo: obliterateAllButton.topAnchor, constant: -20),
            
            obliterateAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            obliterateAllButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
        ])
        
        LayoutManager.setSize(obliterateAllButton, width: 180, height: 50)
        LayoutManager.centerInSuperview(emptyStateLabel, in: view)
        
        NSLayoutConstraint.activate([
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - 数据操作
    private func retrieveArchives() {
        archiveRecords = ArchivePersistence.sharedCurator.retrieveArchives()
        recordsTableView.reloadData()
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        let isEmpty = archiveRecords.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        obliterateAllButton.isHidden = isEmpty
    }
    
    @objc private func obliterateAllTapped() {
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            ArchivePersistence.sharedCurator.obliterateAllArchives()
            self?.retrieveArchives()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        showAlert(title: "Delete All Records?", message: "This action cannot be undone.", 
                 actions: [confirmAction, cancelAction])
    }
}

// MARK: - TableView DataSource & Delegate
extension ArchiveViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveRecordCell", for: indexPath) as! ArchiveRecordCell
        let record = archiveRecords[indexPath.row]
        cell.configureWithRecord(record, rank: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ArchivePersistence.sharedCurator.obliterateArchive(at: indexPath.row)
            retrieveArchives()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
}

// MARK: - 游戏记录单元格
class ArchiveRecordCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let config = ContainerConfig(
            backgroundColor: UIColor.white.withAlphaComponent(0.15),
            cornerRadius: 15,
            borderWidth: 2,
            borderColor: UIColor.white.withAlphaComponent(0.3)
        )
        return UIFactory.createContainerView(config: config)
    }()
    
    private lazy var rankLabel: UILabel = {
        let config = LabelConfig(
            fontSize: 40,
            weight: .bold,
            color: UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0),
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 2), opacity: 0.8, radius: 3)
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var scoreLabel: UILabel = {
        let config = LabelConfig(fontSize: 24, weight: .bold, alignment: .left)
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var velocityLabel: UILabel = {
        let config = LabelConfig(
            fontSize: 16,
            weight: .medium,
            color: UIColor.white.withAlphaComponent(0.9),
            alignment: .left
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var durationLabel: UILabel = {
        let config = LabelConfig(
            fontSize: 16,
            weight: .medium,
            color: UIColor.white.withAlphaComponent(0.9),
            alignment: .left
        )
        return UIFactory.createLabel(config: config)
    }()
    
    private lazy var timestampLabel: UILabel = {
        let config = LabelConfig(
            fontSize: 14,
            weight: .regular,
            color: UIColor.white.withAlphaComponent(0.7),
            alignment: .right
        )
        return UIFactory.createLabel(config: config)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        [rankLabel, scoreLabel, velocityLabel, durationLabel, timestampLabel].forEach {
            containerView.addSubview($0)
        }
        
        LayoutManager.applyEdgeInsets(containerView, in: contentView, insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        LayoutManager.setSize(rankLabel, width: 60)
        
        NSLayoutConstraint.activate([
            rankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            rankLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            scoreLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 15),
            scoreLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            velocityLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            velocityLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 5),
            
            durationLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            durationLabel.topAnchor.constraint(equalTo: velocityLabel.bottomAnchor, constant: 5),
            
            timestampLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            timestampLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configureWithRecord(_ record: ArchiveRecordModel, rank: Int) {
        rankLabel.text = "\(rank)"
        scoreLabel.text = "Score: \(record.archiveScore)"
        velocityLabel.text = "Speed: \(record.archiveVelocity.rawValue)"
        durationLabel.text = formatDuration(record.archiveDuration)
        timestampLabel.text = formatDate(record.archiveTimestamp)
        rankLabel.textColor = getRankColor(for: rank)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "Duration: \(minutes)m \(seconds)s"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func getRankColor(for rank: Int) -> UIColor {
        switch rank {
        case 1: return UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)  // 金色
        case 2: return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0) // 银色
        case 3: return UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0) // 铜色
        default: return .white
        }
    }
}

