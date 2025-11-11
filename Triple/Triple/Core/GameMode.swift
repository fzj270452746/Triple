//
//  GameMode.swift
//  Triple
//
//  游戏模式定义
//

import Foundation

// MARK: - 游戏模式
enum GameMode {
    case classic        // 经典模式
    case timeAttack     // 限时冲刺
    
    var displayName: String {
        switch self {
        case .classic: return "Classic Mode"
        case .timeAttack: return "Time Attack"
        }
    }
    
    var description: String {
        switch self {
        case .classic:
            return "Endless gameplay until columns are full"
        case .timeAttack:
            return "Get highest score within time limit"
        }
    }
}

// MARK: - 限时冲刺难度
enum TimeAttackDifficulty {
    case bronze     // 青铜：60秒，目标1000分
    case silver     // 白银：90秒，目标2000分
    case gold       // 黄金：120秒，目标3500分
    
    var timeLimit: TimeInterval {
        switch self {
        case .bronze: return 60
        case .silver: return 90
        case .gold: return 120
        }
    }
    
    var targetScore: Int {
        switch self {
        case .bronze: return 1000
        case .silver: return 2000
        case .gold: return 3500
        }
    }
    
    var displayName: String {
        switch self {
        case .bronze: return "Bronze"
        case .silver: return "Silver"
        case .gold: return "Gold"
        }
    }
    
    var description: String {
        switch self {
        case .bronze: return "\(Int(timeLimit))s | Target: \(targetScore)"
        case .silver: return "\(Int(timeLimit))s | Target: \(targetScore)"
        case .gold: return "\(Int(timeLimit))s | Target: \(targetScore)"
        }
    }
    
    var icon: String {
        switch self {
        case .bronze: return "🥉"
        case .silver: return "🥈"
        case .gold: return "🥇"
        }
    }
}

// MARK: - 游戏配置
struct GameConfiguration {
    let mode: GameMode
    let velocity: ArchiveRecordModel.GameVelocity
    let timeAttackDifficulty: TimeAttackDifficulty?
    
    init(mode: GameMode, velocity: ArchiveRecordModel.GameVelocity, timeAttackDifficulty: TimeAttackDifficulty? = nil) {
        self.mode = mode
        self.velocity = velocity
        self.timeAttackDifficulty = timeAttackDifficulty
    }
    
    // 便捷初始化 - 经典模式
    static func classic(velocity: ArchiveRecordModel.GameVelocity) -> GameConfiguration {
        return GameConfiguration(mode: .classic, velocity: velocity)
    }
    
    // 便捷初始化 - 限时冲刺
    static func timeAttack(difficulty: TimeAttackDifficulty) -> GameConfiguration {
        // Time Attack 默认使用brisk速度
        return GameConfiguration(mode: .timeAttack, velocity: .brisk, timeAttackDifficulty: difficulty)
    }
}

// MARK: - 连击系统
struct ComboSystem {
    private(set) var currentCombo: Int = 0
    private(set) var maxCombo: Int = 0
    private var lastActionTime: Date?
    private let comboTimeout: TimeInterval = 2.0 // 2秒内不操作断连击
    
    var multiplier: Double {
        switch currentCombo {
        case 0...2: return 1.0
        case 3...4: return 2.0
        case 5...7: return 3.0
        case 8...9: return 4.0
        default: return 5.0
        }
    }
    
    mutating func addCombo() {
        currentCombo += 1
        maxCombo = max(maxCombo, currentCombo)
        lastActionTime = Date()
    }
    
    mutating func resetCombo() {
        currentCombo = 0
    }
    
    mutating func checkTimeout() {
        guard let lastTime = lastActionTime else { return }
        if Date().timeIntervalSince(lastTime) > comboTimeout {
            resetCombo()
        }
    }
    
    func getComboText() -> String {
        if currentCombo >= 3 {
            return "COMBO ×\(currentCombo)"
        }
        return ""
    }
}

