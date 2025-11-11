//
//  MahjongArcadeViewController.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class MahjongArcadeViewController: UIViewController {
    
    // MARK: - Properties
    var vestigeRepository = VestigeRepository.sharedDepot
    var currentVelocity: ArchiveRecordModel.GameVelocity = .sluggish
    var currentTally: Int = 0
    var gameCommencedAt: Date?
    var isGameProceeding = false
    
    var vestigeColumns: [[VestigeTileModel]] = [[], [], []]
    var columnViews: [UITableView] = []
    var columnBackgroundViews: [UIView] = []
    var vestigePropulsionTimers: [Timer?] = [nil, nil, nil]
    var shouldDisplayMagnitudes: Bool = false
    
    let columnHues: [UIColor] = [
        UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 0.3),
        UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 0.3),
        UIColor(red: 0.3, green: 0.7, blue: 0.5, alpha: 0.3)
    ]
    
    // MARK: - UI Components
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
    
    let tallyLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 4
        return label
    }()
    
    let obliterateOneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "deleteOne"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 4
        return button
    }()
    
    let toggleMagnitudeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("👁 Show Numbers", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 0.85)
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 4
        return button
    }()
    
    let columnsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        establishInterface()
        presentVelocitySelectionPrompt()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

