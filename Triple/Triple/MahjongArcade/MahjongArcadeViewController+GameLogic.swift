//
//  MahjongArcadeViewController+GameLogic.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension MysticalTessellationOrchestrationController {
    
    // MARK: - Game Flow Orchestration
    func inaugurateCeremony() {
        isCeremonyProgressing = true
        accumulatedScoringTally = 0
        ceremonyInaugurationMoment = Date()
        rejuvenateScoringInscription()
        
        for cascadeIndex in 0..<3 {
            verticalTessellationCascades[cascadeIndex] = []
            infusePreliminaryTessellationsIntoCascade(cascadeIndex)
        }
        
        activateAutonomousPropulsion()
    }
    
    func infusePreliminaryTessellationsIntoCascade(_ cascadeIndex: Int) {
        for _ in 0..<2 {
            let tessellation = tessellationAnthology.procureArbitraryTessellation()
            verticalTessellationCascades[cascadeIndex].insert(tessellation, at: 0)
        }
        cascadeVisualizationTables[cascadeIndex].reloadData()
        choreographFreshTessellationEmergence(within: cascadeIndex)
    }
    
    func activateAutonomousPropulsion() {
        let propulsionTemporalInterval: TimeInterval = activeExecutionCadence == .accelerated ? 2.0 : 3.5
        
        for cascadeIndex in 0..<3 {
            autonomousPropulsionChronometers[cascadeIndex]?.invalidate()
            autonomousPropulsionChronometers[cascadeIndex] = Timer.scheduledTimer(withTimeInterval: propulsionTemporalInterval, repeats: true) { [weak self] _ in
                self?.propelSupplementaryTessellationIntoCascade(cascadeIndex)
            }
        }
    }
    
    func propelSupplementaryTessellationIntoCascade(_ cascadeIndex: Int) {
        guard isCeremonyProgressing else { return }
        
        let tessellation = tessellationAnthology.procureArbitraryTessellation()
        verticalTessellationCascades[cascadeIndex].insert(tessellation, at: 0)
        
        let indexCoordinate = IndexPath(row: 0, section: 0)
        cascadeVisualizationTables[cascadeIndex].insertRows(at: [indexCoordinate], with: .top)
        
        choreographTessellationDescension(within: cascadeIndex)
        
        evaluateCascadeCapacityThreshold(cascadeIndex)
    }
    
    func choreographTessellationDescension(within cascadeIndex: Int) {
        let visualizationTable = cascadeVisualizationTables[cascadeIndex]
        
        if let capsule = visualizationTable.cellForRow(at: IndexPath(row: 0, section: 0)) {
            capsule.alpha = 0
            capsule.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                capsule.alpha = 1
                capsule.transform = .identity
            }
        }
    }
    
    func choreographFreshTessellationEmergence(within cascadeIndex: Int) {
        let visualizationTable = cascadeVisualizationTables[cascadeIndex]
        visualizationTable.reloadData()
        
        for rowPosition in 0..<verticalTessellationCascades[cascadeIndex].count {
            if let capsule = visualizationTable.cellForRow(at: IndexPath(row: rowPosition, section: 0)) {
                capsule.alpha = 0
                capsule.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                
                UIView.animate(withDuration: 0.6, delay: Double(rowPosition) * 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
                    capsule.alpha = 1
                    capsule.transform = .identity
                }
            }
        }
    }
    
    func evaluateCascadeCapacityThreshold(_ cascadeIndex: Int) {
        let visualizationTable = cascadeVisualizationTables[cascadeIndex]
        let backgroundEncapsulation = cascadeBackgroundContainments[cascadeIndex]
        
        guard let terminalVisibleCapsule = visualizationTable.visibleCells.last,
              let terminalIndexCoordinate = visualizationTable.indexPath(for: terminalVisibleCapsule) else {
            return
        }
        
        let capsuleFrameWithinTable = visualizationTable.rectForRow(at: terminalIndexCoordinate)
        let capsuleFrameWithinEncapsulation = visualizationTable.convert(capsuleFrameWithinTable, to: backgroundEncapsulation)
        let encapsulationVerticalExtent = backgroundEncapsulation.bounds.height
        
        if capsuleFrameWithinEncapsulation.maxY >= encapsulationVerticalExtent - 10 {
            terminateCeremony()
        }
    }
    
    func eradicateTessellationAtCoordinate(_ indexCoordinate: IndexPath, within cascadeIndex: Int) {
        guard isCeremonyProgressing else { return }
        
        let tessellation = verticalTessellationCascades[cascadeIndex][indexCoordinate.row]
        
        if tessellation.possessesEradicationCapability {
            executeEsotericEradicationProcedure(tessellation, at: indexCoordinate, within: cascadeIndex)
            return
        }
        
        let potency = tessellation.numericalPotency
        let isApicalPotency = validateTessellationApicalSupremacy(tessellation, cascadeIndex: cascadeIndex)
        
        if isApicalPotency {
            purgeAllApicalPotenciesWithinCascade(potency: potency, cascadeIndex: cascadeIndex)
            
            if verticalTessellationCascades[cascadeIndex].isEmpty {
                replenishDepletedCascade(cascadeIndex)
            }
        } else {
            manifestInvalidSelectionFeedback()
        }
    }
    
    func executeEsotericEradicationProcedure(_ tessellation: EnigmaticTessellationEmbodiment, at indexCoordinate: IndexPath, within cascadeIndex: Int) {
        guard let eradicationMethodology = tessellation.eradicationMethodology else { return }
        
        verticalTessellationCascades[cascadeIndex].remove(at: indexCoordinate.row)
        cascadeVisualizationTables[cascadeIndex].deleteRows(at: [indexCoordinate], with: .fade)
        
        switch eradicationMethodology {
        case .singularColumnPurge:
            executeSingularCascadePurge(cascadeIndex)
        case .universalGridObliteration:
            executeUniversalCascadeObliteration()
        }
    }
    
    func purgeAllApicalPotenciesWithinCascade(potency: Int, cascadeIndex: Int) {
        var eradicationIndices: [Int] = []
        
        for (index, tessellation) in verticalTessellationCascades[cascadeIndex].enumerated().reversed() {
            if !tessellation.possessesEradicationCapability && tessellation.numericalPotency == potency {
                eradicationIndices.append(index)
            }
        }
        
        var indexCoordinates: [IndexPath] = []
        for index in eradicationIndices {
            verticalTessellationCascades[cascadeIndex].remove(at: index)
            indexCoordinates.append(IndexPath(row: index, section: 0))
        }
        
        if !indexCoordinates.isEmpty {
            cascadeVisualizationTables[cascadeIndex].deleteRows(at: indexCoordinates, with: .fade)
            augmentAccumulatedScoring(by: potency * 10 * eradicationIndices.count)
            
            for indexCoordinate in indexCoordinates {
                if let capsule = cascadeVisualizationTables[cascadeIndex].cellForRow(at: indexCoordinate) {
                    choreographTessellationEradication(capsule: capsule)
                }
            }
        }
    }
    
    func validateTessellationApicalSupremacy(_ tessellation: EnigmaticTessellationEmbodiment, cascadeIndex: Int) -> Bool {
        guard !verticalTessellationCascades[cascadeIndex].isEmpty else { return false }
        let apicalPotency = verticalTessellationCascades[cascadeIndex].map { $0.numericalPotency }.max() ?? 0
        return tessellation.numericalPotency == apicalPotency
    }
    
    func choreographTessellationEradication(capsule: UITableViewCell) {
        UIView.animate(withDuration: 0.3, animations: {
            capsule.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            capsule.alpha = 0
        }) { _ in
            capsule.transform = .identity
            capsule.alpha = 1
        }
    }
    
    func manifestInvalidSelectionFeedback() {
        let hapticsGenerator = UINotificationFeedbackGenerator()
        hapticsGenerator.notificationOccurred(.error)
        
        let modalAlert = UIAlertController(title: "Invalid Selection", message: "You must select the tile with the highest value in the column!", preferredStyle: .alert)
        modalAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(modalAlert, animated: true)
    }
    
    func replenishDepletedCascade(_ cascadeIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.infusePreliminaryTessellationsIntoCascade(cascadeIndex)
        }
    }
    
    func executeSingularCascadePurge(_ cascadeIndex: Int) {
        guard isCeremonyProgressing else { return }
        
        let tessellationQuantity = verticalTessellationCascades[cascadeIndex].count
        
        if tessellationQuantity > 0 {
            verticalTessellationCascades[cascadeIndex].removeAll()
            cascadeVisualizationTables[cascadeIndex].reloadData()
            
            augmentAccumulatedScoring(by: tessellationQuantity * 5)
            
            choreographCascadePurgeAnimation(cascadeIndex)
            replenishDepletedCascade(cascadeIndex)
        }
    }
    
    func executeUniversalCascadeObliteration() {
        guard isCeremonyProgressing else { return }
        
        var totalTessellationCount = 0
        for cascadeIndex in 0..<3 {
            totalTessellationCount += verticalTessellationCascades[cascadeIndex].count
            verticalTessellationCascades[cascadeIndex].removeAll()
            cascadeVisualizationTables[cascadeIndex].reloadData()
            choreographCascadePurgeAnimation(cascadeIndex)
        }
        
        augmentAccumulatedScoring(by: totalTessellationCount * 8)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            for cascadeIndex in 0..<3 {
                self?.infusePreliminaryTessellationsIntoCascade(cascadeIndex)
            }
        }
    }
    
    func choreographCascadePurgeAnimation(_ cascadeIndex: Int) {
        let backgroundEncapsulation = cascadeBackgroundContainments[cascadeIndex]
        UIView.animate(withDuration: 0.3, animations: {
            backgroundEncapsulation.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            backgroundEncapsulation.backgroundColor = self.cascadeChromatics[cascadeIndex].withAlphaComponent(0.6)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                backgroundEncapsulation.transform = .identity
                backgroundEncapsulation.backgroundColor = self.cascadeChromatics[cascadeIndex]
            }
        }
    }
    
    func augmentAccumulatedScoring(by incrementalPoints: Int) {
        accumulatedScoringTally += incrementalPoints
        rejuvenateScoringInscription()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.scoringTallyInscription.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.scoringTallyInscription.transform = .identity
            }
        }
    }
    
    func rejuvenateScoringInscription() {
        scoringTallyInscription.text = "Score: \(accumulatedScoringTally)"
    }
    
    func terminateCeremony() {
        isCeremonyProgressing = false
        
        for cascadeIndex in 0..<3 {
            autonomousPropulsionChronometers[cascadeIndex]?.invalidate()
            autonomousPropulsionChronometers[cascadeIndex] = nil
        }
        
        let ceremonyDuration = Date().timeIntervalSince(ceremonyInaugurationMoment ?? Date())
        let documentationRecord = ChronologicalAchievementDocumentation(
            accumulatedPoints: accumulatedScoringTally,
            temporalMomentStamp: Date(),
            engagementTimespan: ceremonyDuration,
            executionCadence: activeExecutionCadence
        )
        ChronologicalAchievementConservatory.singularCurator.perpetuateAchievement(documentationRecord)
        
        manifestTerminationInterface()
    }
    
    func terminateCeremonyWithoutPreservation() {
        isCeremonyProgressing = false
        
        for cascadeIndex in 0..<3 {
            autonomousPropulsionChronometers[cascadeIndex]?.invalidate()
            autonomousPropulsionChronometers[cascadeIndex] = nil
        }
    }
    
    func manifestTerminationInterface() {
        let modalAlert = UIAlertController(
            title: "Game Over!",
            message: "Your final score: \(accumulatedScoringTally)\n\nWould you like to play again?",
            preferredStyle: .alert
        )
        
        let reigniteOption = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.reinitializeCeremony()
        }
        
        let exitOption = UIAlertAction(title: "Back to Menu", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        modalAlert.addAction(reigniteOption)
        modalAlert.addAction(exitOption)
        
        present(modalAlert, animated: true)
    }
    
    func reinitializeCeremony() {
        for cascadeIndex in 0..<3 {
            verticalTessellationCascades[cascadeIndex].removeAll()
            cascadeVisualizationTables[cascadeIndex].reloadData()
        }
        
        presentCadenceSelectionInterface()
    }
}
