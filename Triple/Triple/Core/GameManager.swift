//
//  GameManager.swift
//  Triple
//
//  游戏管理器 - 统一管理游戏逻辑
//

import UIKit

/// 游戏管理器 - 处理游戏核心逻辑
class GameManager {
    
    // MARK: - 属性
    weak var delegate: GameManagerDelegate?
    
    private(set) var isGameActive = false
    private(set) var currentScore: Int = 0
    private(set) var gameConfiguration: GameConfiguration?
    private var gameStartTime: Date?
    
    // Time Attack 特有属性
    private(set) var remainingTime: TimeInterval = 0
    private var countdownTimer: Timer?
    private var comboSystem = ComboSystem()
    
    private var columnData: [[VestigeTileModel]] = [[], [], []]
    private var tileTimers: [Timer?] = [nil, nil, nil]
    private var columnRefilling: [Bool] = [false, false, false] // 标记列是否正在补充牌
    
    private let tileRepository = VestigeRepository.sharedDepot
    private let columnCount = 3
    private let initialTileCount = 2
    private let maxTilesPerColumn = 12 // 每列最多12个牌，超过则游戏结束
    
    // MARK: - 游戏控制
    func startGame(configuration: GameConfiguration) {
        resetGameState()
        gameConfiguration = configuration
        isGameActive = true
        currentScore = 0
        gameStartTime = Date()
        
        // Time Attack 模式初始化
        if configuration.mode == .timeAttack, let difficulty = configuration.timeAttackDifficulty {
            remainingTime = difficulty.timeLimit
            startCountdown()
        }
        
        for i in 0..<columnCount {
            addInitialTiles(to: i)
        }
        
        startTileGeneration()
        delegate?.gameDidStart()
    }
    
    // 兼容旧接口
    func startGame(velocity: ArchiveRecordModel.GameVelocity) {
        startGame(configuration: .classic(velocity: velocity))
    }
    
    func endGame(saveRecord: Bool = true) {
        isGameActive = false
        stopTileGeneration()
        stopCountdown()
        
        if saveRecord, let startTime = gameStartTime, let config = gameConfiguration {
            let duration = Date().timeIntervalSince(startTime)
            let record = ArchiveRecordModel(
                archiveScore: currentScore,
                archiveTimestamp: Date(),
                archiveDuration: duration,
                archiveVelocity: config.velocity
            )
            ArchivePersistence.sharedCurator.conserveArchive(record)
        }
        
        let result = generateGameResult()
        delegate?.gameDidEnd(result: result)
    }
    
    private func generateGameResult() -> GameResult {
        let mode = gameConfiguration?.mode ?? .classic
        var achievements: [String] = []
        
        if mode == .timeAttack {
            // Time Attack 成就
            if let difficulty = gameConfiguration?.timeAttackDifficulty {
                if currentScore >= difficulty.targetScore {
                    achievements.append("🎯 Target Achieved!")
                }
                
                let percentage = Double(currentScore) / Double(difficulty.targetScore) * 100
                if percentage >= 150 {
                    achievements.append("⭐ Outstanding! 150%+")
                } else if percentage >= 120 {
                    achievements.append("✨ Excellent! 120%+")
                }
            }
            
            if comboSystem.maxCombo >= 10 {
                achievements.append("🔥 Combo Master! ×\(comboSystem.maxCombo)")
            }
        }
        
        return GameResult(
            score: currentScore,
            mode: mode,
            maxCombo: comboSystem.maxCombo,
            achievements: achievements,
            isTargetAchieved: checkTargetAchieved()
        )
    }
    
    private func checkTargetAchieved() -> Bool {
        guard let config = gameConfiguration, 
              config.mode == .timeAttack,
              let difficulty = config.timeAttackDifficulty else {
            return false
        }
        return currentScore >= difficulty.targetScore
    }
    
    // MARK: - 数据访问
    func getTiles(for column: Int) -> [VestigeTileModel] {
        guard column < columnCount else { return [] }
        return columnData[column]
    }
    
    func getColumnCount() -> Int {
        return columnCount
    }
    
    func getCurrentCombo() -> Int {
        return comboSystem.currentCombo
    }
    
    func getComboMultiplier() -> Double {
        return comboSystem.multiplier
    }
    
    func getComboText() -> String {
        return comboSystem.getComboText()
    }
    
    // MARK: - 牌操作
    func handleTileSelection(at indexPath: IndexPath, column: Int) -> Bool {
        guard isGameActive, column < columnCount else { return false }
        let tiles = columnData[column]
        guard indexPath.row < tiles.count else { return false }
        
        let tile = tiles[indexPath.row]
        
        if tile.isSpecialObliterator {
            return handleSpecialTile(tile, at: indexPath.row, in: column)
        } else {
            return handleNormalTile(tile, at: indexPath.row, in: column)
        }
    }
    
    private func handleNormalTile(_ tile: VestigeTileModel, at index: Int, in column: Int) -> Bool {
        guard isMaxValueTile(tile, in: column) else {
            delegate?.didSelectInvalidTile()
            comboSystem.resetCombo()
            delegate?.comboDidUpdate(combo: 0, multiplier: 1.0)
            return false
        }
        
        let value = tile.vestigeMagnitude
        let indicesToRemove = findMatchingTiles(value: value, in: column)
        
        removeTiles(at: indicesToRemove, from: column)
        
        // Time Attack 模式：连击系统
        if gameConfiguration?.mode == .timeAttack {
            comboSystem.addCombo()
            let baseScore = value * 10 * indicesToRemove.count
            let finalScore = Int(Double(baseScore) * comboSystem.multiplier)
            addScore(finalScore)
            delegate?.comboDidUpdate(combo: comboSystem.currentCombo, multiplier: comboSystem.multiplier)
            
            // 每消除10个牌增加5秒
            if currentScore % 100 == 0 && currentScore > 0 {
                addBonusTime(5)
            }
        } else {
            addScore(value * 10 * indicesToRemove.count)
        }
        
        if columnData[column].isEmpty {
            scheduleColumnRefill(column)
        }
        
        return true
    }
    
    private func handleSpecialTile(_ tile: VestigeTileModel, at index: Int, in column: Int) -> Bool {
        guard let type = tile.obliteratorType else { return false }
        
        removeTiles(at: [index], from: column)
        
        switch type {
        case .obliterateSingle:
            clearColumn(column, pointsPerTile: 5)
        case .obliterateAll:
            clearAllColumns(pointsPerTile: 8)
        }
        
        return true
    }
    
    private func clearColumn(_ column: Int, pointsPerTile: Int) {
        let count = columnData[column].count
        columnData[column].removeAll()
        addScore(count * pointsPerTile)
        delegate?.columnDidClear(column)
        scheduleColumnRefill(column)
    }
    
    private func clearAllColumns(pointsPerTile: Int) {
        var totalTiles = 0
        for i in 0..<columnCount {
            totalTiles += columnData[i].count
            columnData[i].removeAll()
            delegate?.columnDidClear(i)
        }
        addScore(totalTiles * pointsPerTile)
        
        for i in 0..<columnCount {
            scheduleColumnRefill(i)
        }
    }
    
    // MARK: - 私有方法
    private func resetGameState() {
        currentScore = 0
        gameStartTime = nil
        comboSystem = ComboSystem()
        for i in 0..<columnCount {
            columnData[i].removeAll()
            columnRefilling[i] = false
        }
        stopTileGeneration()
    }
    
    private func addInitialTiles(to column: Int) {
        for _ in 0..<initialTileCount {
            let tile = tileRepository.fetchArbitraryVestige()
            columnData[column].insert(tile, at: 0)
        }
        delegate?.tilesDidAdd(in: column, at: Array(0..<initialTileCount))
    }
    
    private func startTileGeneration() {
        let velocity = gameConfiguration?.velocity ?? .sluggish
        var interval: TimeInterval = velocity == .brisk ? 2.0 : 3.5
        
        // Time Attack 模式特殊牌出现率+20%
        if gameConfiguration?.mode == .timeAttack {
            interval *= 0.9 // 稍微加快速度
        }
        
        for i in 0..<columnCount {
            tileTimers[i] = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
                self?.addNewTile(to: i)
            }
        }
    }
    
    private func stopTileGeneration() {
        for i in 0..<columnCount {
            tileTimers[i]?.invalidate()
            tileTimers[i] = nil
        }
    }
    
    private func addNewTile(to column: Int) {
        guard isGameActive else { return }
        
        // 如果列正在补充中，跳过本次添加
        guard !columnRefilling[column] else { return }
        
        let tile = tileRepository.fetchArbitraryVestige()
        columnData[column].insert(tile, at: 0)
        delegate?.tilesDidAdd(in: column, at: [0])
        
        // 检查是否达到游戏结束条件（仅经典模式）
        if gameConfiguration?.mode == .classic {
            checkGameOverCondition(for: column)
        }
    }
    
    private func checkGameOverCondition(for column: Int) {
        // 如果任意一列的牌数超过限制，游戏结束
        if columnData[column].count >= maxTilesPerColumn {
            endGame(saveRecord: true)
        }
    }
    
    private func scheduleColumnRefill(_ column: Int) {
        columnRefilling[column] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.addInitialTiles(to: column)
            self.columnRefilling[column] = false
        }
    }
    
    private func isMaxValueTile(_ tile: VestigeTileModel, in column: Int) -> Bool {
        guard !columnData[column].isEmpty else { return false }
        let maxValue = columnData[column].map { $0.vestigeMagnitude }.max() ?? 0
        return tile.vestigeMagnitude == maxValue
    }
    
    private func findMatchingTiles(value: Int, in column: Int) -> [Int] {
        return columnData[column].enumerated().compactMap { index, tile in
            (!tile.isSpecialObliterator && tile.vestigeMagnitude == value) ? index : nil
        }.reversed()
    }
    
    private func removeTiles(at indices: [Int], from column: Int) {
        for index in indices.sorted(by: >) {
            guard index < columnData[column].count else { continue }
            columnData[column].remove(at: index)
        }
        delegate?.tilesDidRemove(in: column, at: indices)
    }
    
    private func addScore(_ points: Int) {
        currentScore += points
        delegate?.scoreDidUpdate(currentScore)
    }
    
    // MARK: - Time Attack 特有方法
    private func startCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 0.1
            
            // 检查连击超时
            self.comboSystem.checkTimeout()
            
            // 更新倒计时显示
            self.delegate?.timeDidUpdate(remainingTime: self.remainingTime)
            
            // 时间到
            if self.remainingTime <= 0 {
                self.remainingTime = 0
                self.endGame(saveRecord: true)
            }
            
            // 最后10秒加速
            if self.remainingTime <= 10 && self.remainingTime > 9.9 {
                self.increaseSpeedForFinalCountdown()
            }
        }
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    private func addBonusTime(_ seconds: TimeInterval) {
        remainingTime += seconds
        delegate?.bonusTimeAdded(seconds: seconds)
    }
    
    private func increaseSpeedForFinalCountdown() {
        // 最后10秒加快牌下落速度
        stopTileGeneration()
        
        for i in 0..<columnCount {
            tileTimers[i] = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { [weak self] _ in
                self?.addNewTile(to: i)
            }
        }
        
        delegate?.finalCountdownStarted()
    }
}

// MARK: - 游戏结果
struct GameResult {
    let score: Int
    let mode: GameMode
    let maxCombo: Int
    let achievements: [String]
    let isTargetAchieved: Bool
}

// MARK: - 游戏管理器协议
protocol GameManagerDelegate: AnyObject {
    func gameDidStart()
    func gameDidEnd(result: GameResult)
    func scoreDidUpdate(_ score: Int)
    func tilesDidAdd(in column: Int, at indices: [Int])
    func tilesDidRemove(in column: Int, at indices: [Int])
    func columnDidClear(_ column: Int)
    func didSelectInvalidTile()
    
    // Time Attack 特有回调
    func timeDidUpdate(remainingTime: TimeInterval)
    func comboDidUpdate(combo: Int, multiplier: Double)
    func bonusTimeAdded(seconds: TimeInterval)
    func finalCountdownStarted()
}

