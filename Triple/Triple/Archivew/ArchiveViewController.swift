//
//  ArchiveViewController.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class ChronologicalAchievementRepositoryController: UIViewController {
    
    var perpetuatedAchievementDocumentations: [ChronologicalAchievementDocumentation] = []
    
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
    
    let repositoryHeadlineInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.text = "Game Records"
        inscriptionLabel.font = UIFont.boldSystemFont(ofSize: 32)
        inscriptionLabel.textColor = .white
        inscriptionLabel.textAlignment = .center
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        inscriptionLabel.layer.shadowColor = UIColor.black.cgColor
        inscriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        inscriptionLabel.layer.shadowOpacity = 0.9
        inscriptionLabel.layer.shadowRadius = 5
        return inscriptionLabel
    }()
    
    let documentationsVisualizationTable: UITableView = {
        let visualizationTable = UITableView(frame: .zero, style: .insetGrouped)
        visualizationTable.backgroundColor = .clear
        visualizationTable.translatesAutoresizingMaskIntoConstraints = false
        visualizationTable.separatorStyle = .none
        return visualizationTable
    }()
    
    let vacuityStateInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.text = "No game records yet.\nStart playing to create records!"
        inscriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        inscriptionLabel.textColor = .white
        inscriptionLabel.textAlignment = .center
        inscriptionLabel.numberOfLines = 0
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        inscriptionLabel.layer.shadowColor = UIColor.black.cgColor
        inscriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        inscriptionLabel.layer.shadowOpacity = 0.8
        inscriptionLabel.layer.shadowRadius = 4
        inscriptionLabel.isHidden = true
        return inscriptionLabel
    }()
    
    let universalEradicationActuator: UIButton = {
        let actuatorButton = UIButton(type: .system)
        actuatorButton.setTitle("🗑 Delete All", for: .normal)
        actuatorButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        actuatorButton.setTitleColor(.white, for: .normal)
        actuatorButton.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        actuatorButton.layer.cornerRadius = 25
        actuatorButton.translatesAutoresizingMaskIntoConstraints = false
        actuatorButton.layer.shadowColor = UIColor.black.cgColor
        actuatorButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        actuatorButton.layer.shadowOpacity = 0.6
        actuatorButton.layer.shadowRadius = 4
        return actuatorButton
    }()
    
    let regressionNavigationTrigger: UIButton = {
        let triggerButton = UIButton(type: .system)
        triggerButton.setTitle("← Back", for: .normal)
        triggerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        triggerButton.setTitleColor(.white, for: .normal)
        triggerButton.backgroundColor = UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 0.8)
        triggerButton.layer.cornerRadius = 20
        triggerButton.translatesAutoresizingMaskIntoConstraints = false
        triggerButton.layer.shadowColor = UIColor.black.cgColor
        triggerButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        triggerButton.layer.shadowOpacity = 0.6
        triggerButton.layer.shadowRadius = 3
        return triggerButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orchestrateVisualizationHierarchy()
        retrievePerpetuatedDocumentations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        retrievePerpetuatedDocumentations()
    }
    
    func orchestrateVisualizationHierarchy() {
        view.addSubview(etherealBackdropImagery)
        view.addSubview(obscuringTintedVeil)
        view.addSubview(repositoryHeadlineInscription)
        view.addSubview(documentationsVisualizationTable)
        view.addSubview(vacuityStateInscription)
        view.addSubview(universalEradicationActuator)
        view.addSubview(regressionNavigationTrigger)
        
        documentationsVisualizationTable.delegate = self
        documentationsVisualizationTable.dataSource = self
        documentationsVisualizationTable.register(ChronologicalAchievementDocumentationCapsule.self, forCellReuseIdentifier: "ChronologicalAchievementDocumentationCapsule")
        
        universalEradicationActuator.addTarget(self, action: #selector(executeUniversalEradication), for: .touchUpInside)
        regressionNavigationTrigger.addTarget(self, action: #selector(executeRegressionNavigation), for: .touchUpInside)
        
        establishGeometricConstraints()
    }
    
    func establishGeometricConstraints() {
        let protectedRegion = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            etherealBackdropImagery.topAnchor.constraint(equalTo: view.topAnchor),
            etherealBackdropImagery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            etherealBackdropImagery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            etherealBackdropImagery.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            obscuringTintedVeil.topAnchor.constraint(equalTo: view.topAnchor),
            obscuringTintedVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            obscuringTintedVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            obscuringTintedVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            regressionNavigationTrigger.topAnchor.constraint(equalTo: protectedRegion.topAnchor, constant: 10),
            regressionNavigationTrigger.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            regressionNavigationTrigger.widthAnchor.constraint(equalToConstant: 100),
            regressionNavigationTrigger.heightAnchor.constraint(equalToConstant: 40),
            
            repositoryHeadlineInscription.topAnchor.constraint(equalTo: regressionNavigationTrigger.bottomAnchor, constant: 20),
            repositoryHeadlineInscription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            documentationsVisualizationTable.topAnchor.constraint(equalTo: repositoryHeadlineInscription.bottomAnchor, constant: 20),
            documentationsVisualizationTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            documentationsVisualizationTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            documentationsVisualizationTable.bottomAnchor.constraint(equalTo: universalEradicationActuator.topAnchor, constant: -20),
            
            vacuityStateInscription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vacuityStateInscription.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vacuityStateInscription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            vacuityStateInscription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            universalEradicationActuator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            universalEradicationActuator.bottomAnchor.constraint(equalTo: protectedRegion.bottomAnchor, constant: -20),
            universalEradicationActuator.widthAnchor.constraint(equalToConstant: 180),
            universalEradicationActuator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func retrievePerpetuatedDocumentations() {
        perpetuatedAchievementDocumentations = ChronologicalAchievementConservatory.singularCurator.retrievePerpetuatedAchievements()
        documentationsVisualizationTable.reloadData()
        refreshVacuityStateVisibility()
    }
    
    func refreshVacuityStateVisibility() {
        vacuityStateInscription.isHidden = !perpetuatedAchievementDocumentations.isEmpty
        universalEradicationActuator.isHidden = perpetuatedAchievementDocumentations.isEmpty
    }
    
    @objc func executeUniversalEradication() {
        let modalAlert = UIAlertController(title: "Delete All Records?", message: "This action cannot be undone.", preferredStyle: .alert)
        
        let confirmationOption = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            ChronologicalAchievementConservatory.singularCurator.annihilateAllPerpetuatedAchievements()
            self?.retrievePerpetuatedDocumentations()
        }
        
        let cancellationOption = UIAlertAction(title: "Cancel", style: .cancel)
        
        modalAlert.addAction(confirmationOption)
        modalAlert.addAction(cancellationOption)
        
        present(modalAlert, animated: true)
    }
    
    @objc func executeRegressionNavigation() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Delegation & Data Provisioning
extension ChronologicalAchievementRepositoryController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perpetuatedAchievementDocumentations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let capsule = tableView.dequeueReusableCell(withIdentifier: "ChronologicalAchievementDocumentationCapsule", for: indexPath) as! ChronologicalAchievementDocumentationCapsule
        let documentation = perpetuatedAchievementDocumentations[indexPath.row]
        capsule.configureCapsuleWithDocumentation(documentation, hierarchicalRank: indexPath.row + 1)
        return capsule
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ChronologicalAchievementConservatory.singularCurator.eradicateSpecificAchievement(at: indexPath.row)
            retrievePerpetuatedDocumentations()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
}

// MARK: - Chronological Achievement Documentation Capsule
class ChronologicalAchievementDocumentationCapsule: UITableViewCell {
    
    let encapsulationContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let hierarchicalRankInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.font = UIFont.boldSystemFont(ofSize: 40)
        inscriptionLabel.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        inscriptionLabel.textAlignment = .center
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        inscriptionLabel.layer.shadowColor = UIColor.black.cgColor
        inscriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        inscriptionLabel.layer.shadowOpacity = 0.8
        inscriptionLabel.layer.shadowRadius = 3
        return inscriptionLabel
    }()
    
    let scoringTallyInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.font = UIFont.boldSystemFont(ofSize: 24)
        inscriptionLabel.textColor = .white
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return inscriptionLabel
    }()
    
    let executionCadenceInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        inscriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return inscriptionLabel
    }()
    
    let engagementTimespanInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        inscriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return inscriptionLabel
    }()
    
    let temporalMomentInscription: UILabel = {
        let inscriptionLabel = UILabel()
        inscriptionLabel.font = UIFont.systemFont(ofSize: 14)
        inscriptionLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        inscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return inscriptionLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        orchestrateCapsuleArchitecture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func orchestrateCapsuleArchitecture() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(encapsulationContainer)
        encapsulationContainer.addSubview(hierarchicalRankInscription)
        encapsulationContainer.addSubview(scoringTallyInscription)
        encapsulationContainer.addSubview(executionCadenceInscription)
        encapsulationContainer.addSubview(engagementTimespanInscription)
        encapsulationContainer.addSubview(temporalMomentInscription)
        
        NSLayoutConstraint.activate([
            encapsulationContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            encapsulationContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            encapsulationContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            encapsulationContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            hierarchicalRankInscription.leadingAnchor.constraint(equalTo: encapsulationContainer.leadingAnchor, constant: 15),
            hierarchicalRankInscription.centerYAnchor.constraint(equalTo: encapsulationContainer.centerYAnchor),
            hierarchicalRankInscription.widthAnchor.constraint(equalToConstant: 60),
            
            scoringTallyInscription.leadingAnchor.constraint(equalTo: hierarchicalRankInscription.trailingAnchor, constant: 15),
            scoringTallyInscription.topAnchor.constraint(equalTo: encapsulationContainer.topAnchor, constant: 12),
            
            executionCadenceInscription.leadingAnchor.constraint(equalTo: hierarchicalRankInscription.trailingAnchor, constant: 15),
            executionCadenceInscription.topAnchor.constraint(equalTo: scoringTallyInscription.bottomAnchor, constant: 5),
            
            engagementTimespanInscription.leadingAnchor.constraint(equalTo: hierarchicalRankInscription.trailingAnchor, constant: 15),
            engagementTimespanInscription.topAnchor.constraint(equalTo: executionCadenceInscription.bottomAnchor, constant: 5),
            
            temporalMomentInscription.trailingAnchor.constraint(equalTo: encapsulationContainer.trailingAnchor, constant: -15),
            temporalMomentInscription.bottomAnchor.constraint(equalTo: encapsulationContainer.bottomAnchor, constant: -12)
        ])
    }
    
    func configureCapsuleWithDocumentation(_ documentation: ChronologicalAchievementDocumentation, hierarchicalRank: Int) {
        hierarchicalRankInscription.text = "\(hierarchicalRank)"
        scoringTallyInscription.text = "Score: \(documentation.accumulatedPoints)"
        executionCadenceInscription.text = "Speed: \(documentation.executionCadence.rawValue)"
        
        let minutes = Int(documentation.engagementTimespan) / 60
        let seconds = Int(documentation.engagementTimespan) % 60
        engagementTimespanInscription.text = "Duration: \(minutes)m \(seconds)s"
        
        let temporalFormatter = DateFormatter()
        temporalFormatter.dateStyle = .short
        temporalFormatter.timeStyle = .short
        temporalMomentInscription.text = temporalFormatter.string(from: documentation.temporalMomentStamp)
        
        if hierarchicalRank <= 3 {
            hierarchicalRankInscription.textColor = hierarchicalRank == 1 ? UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) :
                                  hierarchicalRank == 2 ? UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0) :
                                  UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0)
        } else {
            hierarchicalRankInscription.textColor = .white
        }
    }
}
