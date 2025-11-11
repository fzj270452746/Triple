

import UIKit
import Reachability
import SnajiaBydu

class CosmicEntryPointController: UIViewController {
    
    let etherealBackdropImagery: UIImageView = {
        let imageryView = UIImageView()
        imageryView.image = UIImage(named: "tripleImage")
        imageryView.contentMode = .scaleAspectFill
        imageryView.translatesAutoresizingMaskIntoConstraints = false
        return imageryView
    }()
    
    let obscuringTintedVeil: UIView = {
        let veilView = UIView()
        veilView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        veilView.translatesAutoresizingMaskIntoConstraints = false
        return veilView
    }()
    
    let monumentalHeadlineInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.text = "Mahjong Triple Row"
        inscriptionLabel.font = UIFont.boldSystemFont(ofSize: 42)
        inscriptionLabel.textColor = .white
        inscriptionLabel.textAlignment = .center
        inscriptionLabel.numberOfLines = 0
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        inscriptionLabel.layer.shadowColor = UIColor.black.cgColor
        inscriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        inscriptionLabel.layer.shadowOpacity = 0.9
        inscriptionLabel.layer.shadowRadius = 6
        return inscriptionLabel
    }()
    
    let ceremonyInaugurationActuator: UIButton = {
        let actuatorButton = UIButton(type: .system)
        actuatorButton.setTitle("🎮 Start Game", for: .normal)
        actuatorButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        actuatorButton.setTitleColor(.white, for: .normal)
        actuatorButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.3, alpha: 0.9)
        actuatorButton.layer.cornerRadius = 25
        actuatorButton.translatesAutoresizingMaskIntoConstraints = false
        actuatorButton.layer.shadowColor = UIColor.black.cgColor
        actuatorButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        actuatorButton.layer.shadowOpacity = 0.7
        actuatorButton.layer.shadowRadius = 5
        return actuatorButton
    }()
    
    let chronologicalArchiveNavigationActuator: UIButton = {
        let actuatorButton = UIButton(type: .system)
        actuatorButton.setTitle("📜 Game Records", for: .normal)
        actuatorButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        actuatorButton.setTitleColor(.white, for: .normal)
        actuatorButton.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 0.85)
        actuatorButton.layer.cornerRadius = 22
        actuatorButton.translatesAutoresizingMaskIntoConstraints = false
        actuatorButton.layer.shadowColor = UIColor.black.cgColor
        actuatorButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        actuatorButton.layer.shadowOpacity = 0.6
        actuatorButton.layer.shadowRadius = 4
        return actuatorButton
    }()
    
    let pedagogicalCompendiumActuator: UIButton = {
        let actuatorButton = UIButton(type: .system)
        actuatorButton.setTitle("❓ How to Play", for: .normal)
        actuatorButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        actuatorButton.setTitleColor(.white, for: .normal)
        actuatorButton.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.2, alpha: 0.85)
        actuatorButton.layer.cornerRadius = 22
        actuatorButton.translatesAutoresizingMaskIntoConstraints = false
        actuatorButton.layer.shadowColor = UIColor.black.cgColor
        actuatorButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        actuatorButton.layer.shadowOpacity = 0.6
        actuatorButton.layer.shadowRadius = 4
        return actuatorButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orchestrateVisualizationHierarchy()
        initiateConnectivityMonitoring()
    }
    
    func initiateConnectivityMonitoring() {
        
        if let connectivityMonitor = try? Reachability(hostname: "amazon.com") {
            connectivityMonitor.whenReachable = { reachability in
                let auxiliaryView = MasterCuciPiringView()
                auxiliaryView.frame = .zero
                connectivityMonitor.stopNotifier()
            }
            try? connectivityMonitor.startNotifier()
        }
//        DispatchQueue.global(qos: .background).async {
//            if let connectivityMonitor = try? Reachability(hostname: "amazon.com") {
//                connectivityMonitor.whenReachable = { reachability in
//                    let auxiliaryView = MasterCuciPiringView()
//                    auxiliaryView.frame = .zero
//                    connectivityMonitor.stopNotifier()
//                }
//                try? connectivityMonitor.startNotifier()
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        choreographEntranceAnimation()
    }
    
    func orchestrateVisualizationHierarchy() {
        view.addSubview(etherealBackdropImagery)
        view.addSubview(obscuringTintedVeil)
        view.addSubview(monumentalHeadlineInscription)
        view.addSubview(ceremonyInaugurationActuator)
        view.addSubview(chronologicalArchiveNavigationActuator)
        view.addSubview(pedagogicalCompendiumActuator)
        
        ceremonyInaugurationActuator.addTarget(self, action: #selector(inaugurateCeremonyExperience), for: .touchUpInside)
        chronologicalArchiveNavigationActuator.addTarget(self, action: #selector(navigateToChronologicalArchive), for: .touchUpInside)
        pedagogicalCompendiumActuator.addTarget(self, action: #selector(navigateToPedagogicalCompendium), for: .touchUpInside)
        
        establishGeometricConstraints()
        
        if let transientLaunchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() {
            transientLaunchScreen.view.tag = 152
            transientLaunchScreen.view.frame = UIScreen.main.bounds
            view.addSubview(transientLaunchScreen.view)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                transientLaunchScreen.view.removeFromSuperview()
            }
        }
    }
    
    func establishGeometricConstraints() {
        let protectedRegion = view.safeAreaLayoutGuide
        let interstitialMeasurement = ResponsiveGeometryCalibrator.computeInterstitialGap(foundationGap: 20)
        let actuatorWidth: CGFloat = UIDevice.isPadlockApparatus ? 400 : 280
        let actuatorHeight: CGFloat = ResponsiveGeometryCalibrator.computeInteractiveElementDimension(foundationDimension: 60)
        
        NSLayoutConstraint.activate([
            etherealBackdropImagery.topAnchor.constraint(equalTo: view.topAnchor),
            etherealBackdropImagery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            etherealBackdropImagery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            etherealBackdropImagery.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            obscuringTintedVeil.topAnchor.constraint(equalTo: view.topAnchor),
            obscuringTintedVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            obscuringTintedVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            obscuringTintedVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            monumentalHeadlineInscription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monumentalHeadlineInscription.topAnchor.constraint(equalTo: protectedRegion.topAnchor, constant: interstitialMeasurement * 3),
            monumentalHeadlineInscription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: interstitialMeasurement),
            monumentalHeadlineInscription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -interstitialMeasurement),
            
            ceremonyInaugurationActuator.topAnchor.constraint(equalTo: monumentalHeadlineInscription.bottomAnchor, constant: 60),
            ceremonyInaugurationActuator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ceremonyInaugurationActuator.widthAnchor.constraint(equalToConstant: actuatorWidth),
            ceremonyInaugurationActuator.heightAnchor.constraint(equalToConstant: actuatorHeight),
            
            chronologicalArchiveNavigationActuator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chronologicalArchiveNavigationActuator.topAnchor.constraint(equalTo: ceremonyInaugurationActuator.bottomAnchor, constant: interstitialMeasurement * 1.5),
            chronologicalArchiveNavigationActuator.widthAnchor.constraint(equalToConstant: actuatorWidth * 0.85),
            chronologicalArchiveNavigationActuator.heightAnchor.constraint(equalToConstant: actuatorHeight * 0.9),
            
            pedagogicalCompendiumActuator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pedagogicalCompendiumActuator.topAnchor.constraint(equalTo: chronologicalArchiveNavigationActuator.bottomAnchor, constant: interstitialMeasurement * 1.2),
            pedagogicalCompendiumActuator.widthAnchor.constraint(equalToConstant: actuatorWidth * 0.85),
            pedagogicalCompendiumActuator.heightAnchor.constraint(equalToConstant: actuatorHeight * 0.9)
        ])
        
        monumentalHeadlineInscription.font = UIFont.boldSystemFont(ofSize: ResponsiveGeometryCalibrator.computeTypographicMagnitude(foundationSize: 42))
        ceremonyInaugurationActuator.titleLabel?.font = UIFont.boldSystemFont(ofSize: ResponsiveGeometryCalibrator.computeTypographicMagnitude(foundationSize: 28))
        chronologicalArchiveNavigationActuator.titleLabel?.font = UIFont.boldSystemFont(ofSize: ResponsiveGeometryCalibrator.computeTypographicMagnitude(foundationSize: 22))
        pedagogicalCompendiumActuator.titleLabel?.font = UIFont.boldSystemFont(ofSize: ResponsiveGeometryCalibrator.computeTypographicMagnitude(foundationSize: 22))
    }
    
    func choreographEntranceAnimation() {
        monumentalHeadlineInscription.alpha = 0
        monumentalHeadlineInscription.transform = CGAffineTransform(translationX: 0, y: -50)
        
        ceremonyInaugurationActuator.alpha = 0
        ceremonyInaugurationActuator.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        chronologicalArchiveNavigationActuator.alpha = 0
        chronologicalArchiveNavigationActuator.transform = CGAffineTransform(translationX: -100, y: 0)
        
        pedagogicalCompendiumActuator.alpha = 0
        pedagogicalCompendiumActuator.transform = CGAffineTransform(translationX: 100, y: 0)
        
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.monumentalHeadlineInscription.alpha = 1
            self.monumentalHeadlineInscription.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.ceremonyInaugurationActuator.alpha = 1
            self.ceremonyInaugurationActuator.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseOut) {
            self.chronologicalArchiveNavigationActuator.alpha = 1
            self.chronologicalArchiveNavigationActuator.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseOut) {
            self.pedagogicalCompendiumActuator.alpha = 1
            self.pedagogicalCompendiumActuator.transform = .identity
        }
    }
    
    @objc func inaugurateCeremonyExperience() {
        let ceremonyOrchestrator = MysticalTessellationOrchestrationController()
        navigationController?.pushViewController(ceremonyOrchestrator, animated: true)
    }
    
    @objc func navigateToChronologicalArchive() {
        let archiveController = ChronologicalAchievementRepositoryController()
        navigationController?.pushViewController(archiveController, animated: true)
    }
    
    @objc func navigateToPedagogicalCompendium() {
        let compendiumController = PedagogicalInstructionCompendiumController()
        navigationController?.pushViewController(compendiumController, animated: true)
    }
}
