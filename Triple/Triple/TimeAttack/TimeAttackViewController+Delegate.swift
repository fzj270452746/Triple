//
//  TimeAttackViewController+Delegate.swift
//  Triple
//
//  游戏管理器代理实现
//

import UIKit

extension TimeAttackViewController: GameManagerDelegate {
    
    func gameDidStart() {
        columnViews.forEach { $0.reloadData() }
    }
    
    func gameDidEnd(result: GameResult) {
        showGameResult(result)
    }
    
    func scoreDidUpdate(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
        AnimationManager.pulse(scoreLabel, scale: 1.15, duration: 0.2)
        updateProgressBar()
    }
    
    func tilesDidAdd(in column: Int, at indices: [Int]) {
        let tableView = columnViews[column]
        let indexPaths = indices.map { IndexPath(row: $0, section: 0) }
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: indexPaths, with: .top)
        }, completion: { [weak self] _ in
            self?.animateTileAppearance(in: column, at: indices)
        })
    }
    
    func tilesDidRemove(in column: Int, at indices: [Int]) {
        let tableView = columnViews[column]
        let indexPaths = indices.map { IndexPath(row: $0, section: 0) }
        
        tableView.performBatchUpdates({
            tableView.deleteRows(at: indexPaths, with: .fade)
        }, completion: nil)
    }
    
    func columnDidClear(_ column: Int) {
        columnViews[column].reloadData()
        AnimationManager.pulse(columnBackgroundViews[column], scale: 1.1, duration: 0.3)
    }
    
    func didSelectInvalidTile() {
        let okAction = UIAlertAction(title: "OK", style: .default)
        showAlert(title: "Invalid Selection", 
                 message: "Select the highest value tile!",
                 actions: [okAction])
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    // MARK: - Time Attack 特有回调
    func timeDidUpdate(remainingTime: TimeInterval) {
        let minutes = Int(remainingTime) / 60
        let seconds = remainingTime.truncatingRemainder(dividingBy: 60)
        
        if remainingTime > 10 {
            timerLabel.text = String(format: "%d:%05.2f", minutes, seconds)
            timerLabel.textColor = .white
        } else {
            // 最后10秒变红并闪烁
            timerLabel.text = String(format: "%.1f", remainingTime)
            timerLabel.textColor = .red
            
            if Int(remainingTime * 2) % 2 == 0 {
                AnimationManager.pulse(timerLabel, scale: 1.2, duration: 0.3)
            }
        }
    }
    
    func comboDidUpdate(combo: Int, multiplier: Double) {
        if combo >= 3 {
            comboLabel.text = "COMBO ×\(combo)"
            multiplierLabel.text = String(format: "×%.1f", multiplier)
            
            UIView.animate(withDuration: 0.3) {
                self.comboLabel.alpha = 1
                self.multiplierLabel.alpha = 1
            }
            
            AnimationManager.pulse(comboLabel, scale: 1.2, duration: 0.3)
            
            // 连击数越高颜色越亮
            if combo >= 10 {
                comboLabel.textColor = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
            } else if combo >= 5 {
                comboLabel.textColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
            } else {
                comboLabel.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.comboLabel.alpha = 0
                self.multiplierLabel.alpha = 0
            }
        }
    }
    
    func bonusTimeAdded(seconds: TimeInterval) {
        // 显示时间奖励动画
        let bonusLabel = UILabel()
        bonusLabel.text = "+\(Int(seconds))s"
        bonusLabel.font = UIFont.boldSystemFont(ofSize: 32)
        bonusLabel.textColor = UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1.0)
        bonusLabel.textAlignment = .center
        bonusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bonusLabel)
        
        NSLayoutConstraint.activate([
            bonusLabel.centerXAnchor.constraint(equalTo: timerLabel.centerXAnchor),
            bonusLabel.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor)
        ])
        
        bonusLabel.alpha = 0
        bonusLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, animations: {
            bonusLabel.alpha = 1
            bonusLabel.transform = .identity
            bonusLabel.center.y -= 50
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                bonusLabel.alpha = 0
            }) { _ in
                bonusLabel.removeFromSuperview()
            }
        }
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    func finalCountdownStarted() {
        // 最后10秒特效
        UIView.animate(withDuration: 0.3, delay: 0, options: [.repeat, .autoreverse]) {
            self.view.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    // MARK: - 辅助方法
    func animateTileAppearance(in column: Int, at indices: [Int]) {
        let tableView = columnViews[column]
        
        for row in indices {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) else { continue }
            AnimationManager.scaleAndFadeIn(cell, fromScale: 0.5, duration: 0.5, delay: Double(row) * 0.1)
        }
    }
    
    func showGameResult(_ result: GameResult) {
        let resultVC = TimeAttackResultViewController(result: result, difficulty: difficulty)
        resultVC.modalPresentationStyle = .fullScreen
        present(resultVC, animated: true)
    }
}

