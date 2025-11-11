//
//  MahjongArcadeViewController+Actions.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension MahjongArcadeViewController {
    
    // MARK: - Button Actions
    @objc func toggleMagnitudeDisplayTapped() {
        shouldDisplayMagnitudes.toggle()
        
        let newTitle = shouldDisplayMagnitudes ? "👁 Hide Numbers" : "👁 Show Numbers"
        toggleMagnitudeButton.setTitle(newTitle, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.toggleMagnitudeButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.toggleMagnitudeButton.transform = .identity
            }
        }
        
        for tableView in columnViews {
            tableView.reloadData()
        }
    }
    
    @objc func retreatTapped() {
        terminateGameWithoutSaving()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension MahjongArcadeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vestigeColumns[tableView.tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VestigeTileCell", for: indexPath) as! VestigeTileCell
        let vestige = vestigeColumns[tableView.tag][indexPath.row]
        cell.configureWithVestige(vestige, showMagnitude: shouldDisplayMagnitudes)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptiveLayoutHelper.calculateTileSize() + 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        obliterateTileAtIndexPath(indexPath, in: tableView.tag)
    }
}

