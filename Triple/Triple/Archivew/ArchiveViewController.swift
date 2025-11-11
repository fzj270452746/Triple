//
//  ArchiveViewController.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class ArchiveViewController: UIViewController {
    
    var archiveRecords: [ArchiveRecordModel] = []
    
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
        label.text = "Game Records"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 3)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 5
        return label
    }()
    
    let recordsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No game records yet.\nStart playing to create records!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 4
        label.isHidden = true
        return label
    }()
    
    let obliterateAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🗑 Delete All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 4
        return button
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
        retrieveArchives()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        retrieveArchives()
    }
    
    func establishInterface() {
        view.addSubview(backgroundImageView)
        view.addSubview(dimmerOverlay)
        view.addSubview(titleLabel)
        view.addSubview(recordsTableView)
        view.addSubview(emptyStateLabel)
        view.addSubview(obliterateAllButton)
        view.addSubview(retreatButton)
        
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(ArchiveRecordCell.self, forCellReuseIdentifier: "ArchiveRecordCell")
        
        obliterateAllButton.addTarget(self, action: #selector(obliterateAllTapped), for: .touchUpInside)
        retreatButton.addTarget(self, action: #selector(retreatTapped), for: .touchUpInside)
        
        establishConstraints()
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
            
            recordsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            recordsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recordsTableView.bottomAnchor.constraint(equalTo: obliterateAllButton.topAnchor, constant: -20),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            obliterateAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            obliterateAllButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            obliterateAllButton.widthAnchor.constraint(equalToConstant: 180),
            obliterateAllButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func retrieveArchives() {
        archiveRecords = ArchivePersistence.sharedCurator.retrieveArchives()
        recordsTableView.reloadData()
        updateEmptyState()
    }
    
    func updateEmptyState() {
        emptyStateLabel.isHidden = !archiveRecords.isEmpty
        obliterateAllButton.isHidden = archiveRecords.isEmpty
    }
    
    @objc func obliterateAllTapped() {
        let alertController = UIAlertController(title: "Delete All Records?", message: "This action cannot be undone.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            ArchivePersistence.sharedCurator.obliterateAllArchives()
            self?.retrieveArchives()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc func retreatTapped() {
        navigationController?.popViewController(animated: true)
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

// MARK: - Archive Record Cell
class ArchiveRecordCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 3
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let velocityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        establishCellInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func establishCellInterface() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(rankLabel)
        containerView.addSubview(scoreLabel)
        containerView.addSubview(velocityLabel)
        containerView.addSubview(durationLabel)
        containerView.addSubview(timestampLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            rankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            rankLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 60),
            
            scoreLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 15),
            scoreLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            velocityLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 15),
            velocityLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 5),
            
            durationLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 15),
            durationLabel.topAnchor.constraint(equalTo: velocityLabel.bottomAnchor, constant: 5),
            
            timestampLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            timestampLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configureWithRecord(_ record: ArchiveRecordModel, rank: Int) {
        rankLabel.text = "\(rank)"
        scoreLabel.text = "Score: \(record.archiveScore)"
        velocityLabel.text = "Speed: \(record.archiveVelocity.rawValue)"
        
        let minutes = Int(record.archiveDuration) / 60
        let seconds = Int(record.archiveDuration) % 60
        durationLabel.text = "Duration: \(minutes)m \(seconds)s"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        timestampLabel.text = dateFormatter.string(from: record.archiveTimestamp)
        
        if rank <= 3 {
            rankLabel.textColor = rank == 1 ? UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) :
                                  rank == 2 ? UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0) :
                                  UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0)
        } else {
            rankLabel.textColor = .white
        }
    }
}

