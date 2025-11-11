//
//  MahjongArcadeViewController+Setup.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension MysticalTessellationOrchestrationController {
    
    // MARK: - Interface Orchestration
    func orchestrateVisualizationHierarchy() {
        view.addSubview(etherealBackdropImagery)
        view.addSubview(obscuringTintedVeil)
        view.addSubview(scoringTallyInscription)
        view.addSubview(cascadesAggregationStack)
        view.addSubview(potencyVisibilityToggleActuator)
        view.addSubview(regressionNavigationTrigger)
        
        establishGeometricConstraints()
        fabricateCascadeVisualizationInfrastructure()
        assignInteractionHandlers()
    }
    
    func establishGeometricConstraints() {
        let protectedRegion = view.safeAreaLayoutGuide
        let interstitialMeasurement = ResponsiveGeometryCalibrator.computeInterstitialGap(foundationGap: 20)
        
        NSLayoutConstraint.activate([
            etherealBackdropImagery.topAnchor.constraint(equalTo: view.topAnchor),
            etherealBackdropImagery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            etherealBackdropImagery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            etherealBackdropImagery.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            obscuringTintedVeil.topAnchor.constraint(equalTo: view.topAnchor),
            obscuringTintedVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            obscuringTintedVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            obscuringTintedVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scoringTallyInscription.topAnchor.constraint(equalTo: regressionNavigationTrigger.bottomAnchor, constant: 20),
            scoringTallyInscription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cascadesAggregationStack.topAnchor.constraint(equalTo: scoringTallyInscription.bottomAnchor, constant: interstitialMeasurement),
            cascadesAggregationStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: interstitialMeasurement),
            cascadesAggregationStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -interstitialMeasurement),
            cascadesAggregationStack.bottomAnchor.constraint(equalTo: potencyVisibilityToggleActuator.topAnchor, constant: -interstitialMeasurement),
            
            potencyVisibilityToggleActuator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            potencyVisibilityToggleActuator.bottomAnchor.constraint(equalTo: protectedRegion.bottomAnchor, constant: -interstitialMeasurement),
            potencyVisibilityToggleActuator.widthAnchor.constraint(equalToConstant: ResponsiveGeometryCalibrator.computeInteractiveElementDimension(foundationDimension: 160)),
            potencyVisibilityToggleActuator.heightAnchor.constraint(equalToConstant: 44),
            
            regressionNavigationTrigger.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: interstitialMeasurement),
            regressionNavigationTrigger.topAnchor.constraint(equalTo: protectedRegion.topAnchor, constant: 10),
            regressionNavigationTrigger.widthAnchor.constraint(equalToConstant: 100),
            regressionNavigationTrigger.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        scoringTallyInscription.font = UIFont.boldSystemFont(ofSize: ResponsiveGeometryCalibrator.computeTypographicMagnitude(foundationSize: 28))
        regressionNavigationTrigger.titleLabel?.font = UIFont.boldSystemFont(ofSize: ResponsiveGeometryCalibrator.computeTypographicMagnitude(foundationSize: 18))
        potencyVisibilityToggleActuator.titleLabel?.font = UIFont.boldSystemFont(ofSize: ResponsiveGeometryCalibrator.computeTypographicMagnitude(foundationSize: 16))
    }
    
    func fabricateCascadeVisualizationInfrastructure() {
        for cascadeIndex in 0..<3 {
            let encapsulationContainer = UIView()
            encapsulationContainer.backgroundColor = cascadeChromatics[cascadeIndex]
            encapsulationContainer.layer.cornerRadius = 15
            encapsulationContainer.layer.borderWidth = 2
            encapsulationContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            encapsulationContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let tessellationTable = UITableView()
            tessellationTable.backgroundColor = .clear
            tessellationTable.separatorStyle = .none
            tessellationTable.delegate = self
            tessellationTable.dataSource = self
            tessellationTable.tag = cascadeIndex
            tessellationTable.register(EnigmaticTessellationCapsule.self, forCellReuseIdentifier: "EnigmaticTessellationCapsule")
            tessellationTable.translatesAutoresizingMaskIntoConstraints = false
            tessellationTable.showsVerticalScrollIndicator = false
            tessellationTable.allowsSelection = true
            tessellationTable.isScrollEnabled = false
            
            encapsulationContainer.addSubview(tessellationTable)
            cascadesAggregationStack.addArrangedSubview(encapsulationContainer)
            
            NSLayoutConstraint.activate([
                tessellationTable.topAnchor.constraint(equalTo: encapsulationContainer.topAnchor, constant: 8),
                tessellationTable.leadingAnchor.constraint(equalTo: encapsulationContainer.leadingAnchor, constant: 8),
                tessellationTable.trailingAnchor.constraint(equalTo: encapsulationContainer.trailingAnchor, constant: -8),
                tessellationTable.bottomAnchor.constraint(equalTo: encapsulationContainer.bottomAnchor, constant: -8)
            ])
            
            cascadeVisualizationTables.append(tessellationTable)
            cascadeBackgroundContainments.append(encapsulationContainer)
        }
    }
    
    func assignInteractionHandlers() {
        potencyVisibilityToggleActuator.addTarget(self, action: #selector(actuatePotencyVisibilityToggle), for: .touchUpInside)
        regressionNavigationTrigger.addTarget(self, action: #selector(executeRegressionNavigation), for: .touchUpInside)
    }
    
    func presentCadenceSelectionInterface() {
        let modalPromptController = UIAlertController(title: "Select Game Speed", message: "Choose the velocity at which tiles descend", preferredStyle: .alert)
        
        let acceleratedOption = UIAlertAction(title: "⚡️ Fast", style: .default) { [weak self] _ in
            self?.activeExecutionCadence = .accelerated
            self?.inaugurateCeremony()
        }
        
        let deceleratedOption = UIAlertAction(title: "🐢 Slow", style: .default) { [weak self] _ in
            self?.activeExecutionCadence = .decelerated
            self?.inaugurateCeremony()
        }
        
        modalPromptController.addAction(acceleratedOption)
        modalPromptController.addAction(deceleratedOption)
        present(modalPromptController, animated: true)
    }
}
