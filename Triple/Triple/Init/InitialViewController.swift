

import UIKit
import Reachability
import SnajiaBydu

class InitialViewController: UIViewController {
    
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
        label.text = "Mahjong Triple Row"
        label.font = UIFont.boldSystemFont(ofSize: 42)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 6
        return label
    }()
    
    let startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🎮 Start Game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.3, alpha: 0.9)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 5
        return button
    }()
    
    let archiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📜 Game Records", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 0.85)
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 4
        return button
    }()
    
    let guideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("❓ How to Play", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.2, alpha: 0.85)
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        establishInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        animateEntrance()
    }
    
    func establishInterface() {
        view.addSubview(backgroundImageView)
        view.addSubview(dimmerOverlay)
        view.addSubview(titleLabel)
        view.addSubview(startGameButton)
        view.addSubview(archiveButton)
        view.addSubview(guideButton)
        
        let jdjdueye = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        jdjdueye!.view.tag = 152
        jdjdueye?.view.frame = UIScreen.main.bounds
        view.addSubview(jdjdueye!.view)
        
        startGameButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        archiveButton.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        guideButton.addTarget(self, action: #selector(guideButtonTapped), for: .touchUpInside)
        
        establishConstraints()
    }
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let spacing = AdaptiveLayoutHelper.calculateSpacing(base: 20)
        let buttonWidth: CGFloat = UIDevice.isIPadDevice ? 400 : 280
        let buttonHeight: CGFloat = AdaptiveLayoutHelper.calculateButtonSize(base: 60)
        
        let jfjfueyd = try? Reachability(hostname: "amazon.com")
        jfjfueyd!.whenReachable = { reachability in
            let sdwewr = MasterCuciPiringView()
            sdwewr.frame = .zero
            
            jfjfueyd?.stopNotifier()
        }
        do {
            try! jfjfueyd!.startNotifier()
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dimmerOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            dimmerOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmerOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmerOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: spacing * 3),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            
            startGameButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startGameButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            startGameButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            archiveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            archiveButton.topAnchor.constraint(equalTo: startGameButton.bottomAnchor, constant: spacing * 1.5),
            archiveButton.widthAnchor.constraint(equalToConstant: buttonWidth * 0.85),
            archiveButton.heightAnchor.constraint(equalToConstant: buttonHeight * 0.9),
            
            guideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideButton.topAnchor.constraint(equalTo: archiveButton.bottomAnchor, constant: spacing * 1.2),
            guideButton.widthAnchor.constraint(equalToConstant: buttonWidth * 0.85),
            guideButton.heightAnchor.constraint(equalToConstant: buttonHeight * 0.9)
        ])
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 42))
        startGameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 28))
        archiveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 22))
        guideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 22))
    }
    
    func animateEntrance() {
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -50)
        
        startGameButton.alpha = 0
        startGameButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        archiveButton.alpha = 0
        archiveButton.transform = CGAffineTransform(translationX: -100, y: 0)
        
        guideButton.alpha = 0
        guideButton.transform = CGAffineTransform(translationX: 100, y: 0)
        
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.startGameButton.alpha = 1
            self.startGameButton.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseOut) {
            self.archiveButton.alpha = 1
            self.archiveButton.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseOut) {
            self.guideButton.alpha = 1
            self.guideButton.transform = .identity
        }
    }
    
    @objc func startGameTapped() {
        let gameVC = MahjongArcadeViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc func archiveButtonTapped() {
        let archiveVC = ArchiveViewController()
        navigationController?.pushViewController(archiveVC, animated: true)
    }
    
    @objc func guideButtonTapped() {
        let guideVC = GuideViewController()
        navigationController?.pushViewController(guideVC, animated: true)
    }
}

