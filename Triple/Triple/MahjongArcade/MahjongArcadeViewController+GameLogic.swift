//
//  MahjongArcadeViewController+GameLogic.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension MahjongArcadeViewController {
    
    // MARK: - Game Flow
    func commenceGame() {
        isGameProceeding = true
        currentTally = 0
        gameCommencedAt = Date()
        refreshTallyDisplay()
        
        for index in 0..<3 {
            vestigeColumns[index] = []
            appendInitialVestigesToColumn(index)
        }
        
        initiateVestigePropulsion()
    }
    
    func appendInitialVestigesToColumn(_ columnIndex: Int) {
        for _ in 0..<2 {
            let vestige = vestigeRepository.fetchArbitraryVestige()
            vestigeColumns[columnIndex].insert(vestige, at: 0)
        }
        columnViews[columnIndex].reloadData()
        animateNewVestigesAppearance(in: columnIndex)
    }
    
    func initiateVestigePropulsion() {
        let propulsionInterval: TimeInterval = currentVelocity == .brisk ? 2.0 : 3.5
        
        for index in 0..<3 {
            vestigePropulsionTimers[index]?.invalidate()
            vestigePropulsionTimers[index] = Timer.scheduledTimer(withTimeInterval: propulsionInterval, repeats: true) { [weak self] _ in
                self?.propelNewVestigeIntoColumn(index)
            }
        }
    }
    
    func propelNewVestigeIntoColumn(_ columnIndex: Int) {
        guard isGameProceeding else { return }
        
        let vestige = vestigeRepository.fetchArbitraryVestige()
        vestigeColumns[columnIndex].insert(vestige, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        columnViews[columnIndex].insertRows(at: [indexPath], with: .top)
        
        animateVestigeDescent(in: columnIndex)
        
        scrutinizeColumnCapacity(columnIndex)
    }
    
    func animateVestigeDescent(in columnIndex: Int) {
        let tableView = columnViews[columnIndex]
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
    }
    
    func animateNewVestigesAppearance(in columnIndex: Int) {
        let tableView = columnViews[columnIndex]
        tableView.reloadData()
        
        for row in 0..<vestigeColumns[columnIndex].count {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) {
                cell.alpha = 0
                cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                
                UIView.animate(withDuration: 0.6, delay: Double(row) * 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
                    cell.alpha = 1
                    cell.transform = .identity
                }
            }
        }
    }
    
    func scrutinizeColumnCapacity(_ columnIndex: Int) {
        let tableView = columnViews[columnIndex]
        let containerView = columnBackgroundViews[columnIndex]
        
        guard let lastVisibleCell = tableView.visibleCells.last,
              let lastIndexPath = tableView.indexPath(for: lastVisibleCell) else {
            return
        }
        
        let cellFrameInTableView = tableView.rectForRow(at: lastIndexPath)
        let cellFrameInContainer = tableView.convert(cellFrameInTableView, to: containerView)
        let containerBottom = containerView.bounds.height
        
        if cellFrameInContainer.maxY >= containerBottom - 10 {
            terminateGame()
        }
    }
    
    func obliterateTileAtIndexPath(_ indexPath: IndexPath, in columnIndex: Int) {
        guard isGameProceeding else { return }
        
        let vestige = vestigeColumns[columnIndex][indexPath.row]
        
        if vestige.isSpecialObliterator {
            handleSpecialObliteratorTile(vestige, at: indexPath, in: columnIndex)
            return
        }
        
        let magnitude = vestige.vestigeMagnitude
        let isMaximumMagnitude = isVestigeMaximumInColumn(vestige, columnIndex: columnIndex)
        
        if isMaximumMagnitude {
            removeAllMaximumMagnitudesInColumn(magnitude: magnitude, columnIndex: columnIndex)
            
            if vestigeColumns[columnIndex].isEmpty {
                replenishEmptyColumn(columnIndex)
            }
        } else {
            presentInvalidSelectionFeedback()
        }
    }
    
    func handleSpecialObliteratorTile(_ vestige: VestigeTileModel, at indexPath: IndexPath, in columnIndex: Int) {
        guard let obliteratorType = vestige.obliteratorType else { return }
        
        vestigeColumns[columnIndex].remove(at: indexPath.row)
        columnViews[columnIndex].deleteRows(at: [indexPath], with: .fade)
        
        switch obliteratorType {
        case .obliterateSingle:
            obliterateSingleColumnDirectly(columnIndex)
        case .obliterateAll:
            obliterateAllColumns()
        }
    }
    
    func removeAllMaximumMagnitudesInColumn(magnitude: Int, columnIndex: Int) {
        var indicesToRemove: [Int] = []
        
        for (index, vestige) in vestigeColumns[columnIndex].enumerated().reversed() {
            if !vestige.isSpecialObliterator && vestige.vestigeMagnitude == magnitude {
                indicesToRemove.append(index)
            }
        }
        
        var indexPaths: [IndexPath] = []
        for index in indicesToRemove {
            vestigeColumns[columnIndex].remove(at: index)
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        
        if !indexPaths.isEmpty {
            columnViews[columnIndex].deleteRows(at: indexPaths, with: .fade)
            augmentTally(by: magnitude * 10 * indicesToRemove.count)
            
            for indexPath in indexPaths {
                if let cell = columnViews[columnIndex].cellForRow(at: indexPath) {
                    animateVestigeObliteration(cell: cell)
                }
            }
        }
    }
    
    func isVestigeMaximumInColumn(_ vestige: VestigeTileModel, columnIndex: Int) -> Bool {
        guard !vestigeColumns[columnIndex].isEmpty else { return false }
        let maximumMagnitude = vestigeColumns[columnIndex].map { $0.vestigeMagnitude }.max() ?? 0
        return vestige.vestigeMagnitude == maximumMagnitude
    }
    
    func animateVestigeObliteration(cell: UITableViewCell) {
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            cell.alpha = 0
        }) { _ in
            cell.transform = .identity
            cell.alpha = 1
        }
    }
    
    func presentInvalidSelectionFeedback() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.error)
        
        let alertController = UIAlertController(title: "Invalid Selection", message: "You must select the tile with the highest value in the column!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func replenishEmptyColumn(_ columnIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.appendInitialVestigesToColumn(columnIndex)
        }
    }
    
    func obliterateSingleColumnDirectly(_ columnIndex: Int) {
        guard isGameProceeding else { return }
        
        let vestigeCount = vestigeColumns[columnIndex].count
        
        if vestigeCount > 0 {
            vestigeColumns[columnIndex].removeAll()
            columnViews[columnIndex].reloadData()
            
            augmentTally(by: vestigeCount * 5)
            
            animateColumnClearance(columnIndex)
            replenishEmptyColumn(columnIndex)
        }
    }
    
    func obliterateAllColumns() {
        guard isGameProceeding else { return }
        
        var totalVestiges = 0
        for index in 0..<3 {
            totalVestiges += vestigeColumns[index].count
            vestigeColumns[index].removeAll()
            columnViews[index].reloadData()
            animateColumnClearance(index)
        }
        
        augmentTally(by: totalVestiges * 8)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            for index in 0..<3 {
                self?.appendInitialVestigesToColumn(index)
            }
        }
    }
    
    func animateColumnClearance(_ columnIndex: Int) {
        let containerView = columnBackgroundViews[columnIndex]
        UIView.animate(withDuration: 0.3, animations: {
            containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            containerView.backgroundColor = self.columnHues[columnIndex].withAlphaComponent(0.6)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                containerView.transform = .identity
                containerView.backgroundColor = self.columnHues[columnIndex]
            }
        }
    }
    
    func augmentTally(by points: Int) {
        currentTally += points
        refreshTallyDisplay()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tallyLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.tallyLabel.transform = .identity
            }
        }
    }
    
    func refreshTallyDisplay() {
        tallyLabel.text = "Score: \(currentTally)"
    }
    
    func terminateGame() {
        isGameProceeding = false
        
        for index in 0..<3 {
            vestigePropulsionTimers[index]?.invalidate()
            vestigePropulsionTimers[index] = nil
        }
        
        let gameDuration = Date().timeIntervalSince(gameCommencedAt ?? Date())
        let archive = ArchiveRecordModel(archiveScore: currentTally, archiveTimestamp: Date(), archiveDuration: gameDuration, archiveVelocity: currentVelocity)
        ArchivePersistence.sharedCurator.conserveArchive(archive)
        
        presentGameOverPrompt()
    }
    
    func terminateGameWithoutSaving() {
        isGameProceeding = false
        
        for index in 0..<3 {
            vestigePropulsionTimers[index]?.invalidate()
            vestigePropulsionTimers[index] = nil
        }
    }
    
    func presentGameOverPrompt() {
        let alertController = UIAlertController(title: "Game Over!", message: "Your final score: \(currentTally)\n\nWould you like to play again?", preferredStyle: .alert)
        
        let playAgainAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.resetGame()
        }
        
        let exitAction = UIAlertAction(title: "Back to Menu", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(playAgainAction)
        alertController.addAction(exitAction)
        
        present(alertController, animated: true)
    }
    
    func resetGame() {
        for index in 0..<3 {
            vestigeColumns[index].removeAll()
            columnViews[index].reloadData()
        }
        
        presentVelocitySelectionPrompt()
    }
}

