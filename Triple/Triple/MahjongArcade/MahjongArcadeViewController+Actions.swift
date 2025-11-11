//
//  MahjongArcadeViewController+Actions.swift
//  Triple
//
//  重构后的操作扩展
//

import UIKit

// MARK: - TableView数据源和代理
extension MahjongArcadeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameManager.getTiles(for: tableView.tag).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VestigeTileCell", for: indexPath) as! VestigeTileCell
        let tiles = gameManager.getTiles(for: tableView.tag)
        if indexPath.row < tiles.count {
            cell.configureWithVestige(tiles[indexPath.row], showMagnitude: shouldDisplayMagnitudes)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptiveLayoutHelper.calculateTileSize() + 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = gameManager.handleTileSelection(at: indexPath, column: tableView.tag)
    }
}

// MARK: - 游戏管理器代理
extension MahjongArcadeViewController: GameManagerDelegate {
    
    func gameDidStart() {
        columnViews.forEach { $0.reloadData() }
    }
    
    func gameDidEnd(result: GameResult) {
        showGameOverDialog(score: result.score)
    }
    
    func scoreDidUpdate(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
        animateScoreUpdate()
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
        animateColumnClear(column)
    }
    
    func didSelectInvalidTile() {
        let okAction = UIAlertAction(title: "OK", style: .default)
        showAlert(title: "Invalid Selection", 
                 message: "You must select the tile with the highest value in the column!",
                 actions: [okAction])
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    // MARK: - Time Attack 回调（经典模式不使用）
    func timeDidUpdate(remainingTime: TimeInterval) {
        // 经典模式不需要实现
    }
    
    func comboDidUpdate(combo: Int, multiplier: Double) {
        // 经典模式不需要实现
    }
    
    func bonusTimeAdded(seconds: TimeInterval) {
        // 经典模式不需要实现
    }
    
    func finalCountdownStarted() {
        // 经典模式不需要实现
    }
}

