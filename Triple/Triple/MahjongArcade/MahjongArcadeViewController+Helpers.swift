//
//  MahjongArcadeViewController+Helpers.swift
//  Triple
//
//  辅助方法扩展
//

import UIKit

extension MahjongArcadeViewController {
    
    // MARK: - 游戏流程
    func showVelocitySelection() {
        let briskAction = UIAlertAction(title: "⚡️ Fast", style: .default) { [weak self] _ in
            self?.gameManager.startGame(velocity: .brisk)
        }
        
        let sluggishAction = UIAlertAction(title: "🐢 Slow", style: .default) { [weak self] _ in
            self?.gameManager.startGame(velocity: .sluggish)
        }
        
        showAlert(title: "Select Game Speed", message: "Choose the velocity at which tiles descend", 
                 actions: [briskAction, sluggishAction])
    }
    
    func showGameOverDialog(score: Int) {
        let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.resetAndRestart()
        }
        
        let exitAction = UIAlertAction(title: "Back to Menu", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        showAlert(title: "Game Over!", message: "Your final score: \(score)\n\nWould you like to play again?",
                 actions: [restartAction, exitAction])
    }
    
    private func resetAndRestart() {
        for i in 0..<3 {
            columnViews[i].reloadData()
        }
        showVelocitySelection()
    }
    
    // MARK: - 按钮操作
    @objc func toggleMagnitudeDisplayTapped() {
        shouldDisplayMagnitudes.toggle()
        
        let newTitle = shouldDisplayMagnitudes ? "👁 Hide Numbers" : "👁 Show Numbers"
        toggleMagnitudeButton.setTitle(newTitle, for: .normal)
        
        AnimationManager.pulse(toggleMagnitudeButton)
        
        columnViews.forEach { $0.reloadData() }
    }
    
    // MARK: - 动画
    func animateTileAppearance(in column: Int, at indices: [Int]) {
        let tableView = columnViews[column]
        
        for row in indices {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) else { continue }
            AnimationManager.scaleAndFadeIn(cell, fromScale: 0.5, duration: 0.5, delay: Double(row) * 0.1)
        }
    }
    
    func animateTileRemoval(cell: UITableViewCell) {
        AnimationManager.scaleAndFadeOut(cell, toScale: 1.3, duration: 0.3)
    }
    
    func animateScoreUpdate() {
        AnimationManager.pulse(scoreLabel, scale: 1.2)
    }
    
    func animateColumnClear(_ column: Int) {
        let container = columnBackgroundViews[column]
        AnimationManager.pulse(container, scale: 1.1, duration: 0.3)
    }
}

