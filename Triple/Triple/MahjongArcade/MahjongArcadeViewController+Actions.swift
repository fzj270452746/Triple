//
//  MahjongArcadeViewController+Actions.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension MysticalTessellationOrchestrationController {
    
    // MARK: - Button Interaction Handlers
    @objc func actuatePotencyVisibilityToggle() {
        shouldExhibitNumericalPotencies.toggle()
        
        let updatedInscription = shouldExhibitNumericalPotencies ? "👁 Hide Numbers" : "👁 Show Numbers"
        potencyVisibilityToggleActuator.setTitle(updatedInscription, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.potencyVisibilityToggleActuator.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.potencyVisibilityToggleActuator.transform = .identity
            }
        }
        
        for visualizationTable in cascadeVisualizationTables {
            visualizationTable.reloadData()
        }
    }
    
    @objc func executeRegressionNavigation() {
        terminateCeremonyWithoutPreservation()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Delegation & Data Provisioning
extension MysticalTessellationOrchestrationController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verticalTessellationCascades[tableView.tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let capsule = tableView.dequeueReusableCell(withIdentifier: "EnigmaticTessellationCapsule", for: indexPath) as! EnigmaticTessellationCapsule
        let tessellation = verticalTessellationCascades[tableView.tag][indexPath.row]
        capsule.configureCapsuleWithTessellation(tessellation, exhibitPotency: shouldExhibitNumericalPotencies)
        return capsule
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ResponsiveGeometryCalibrator.computeTessellationDimension() + 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        eradicateTessellationAtCoordinate(indexPath, within: tableView.tag)
    }
}
