//
//  TripleDatas.swift
//  Triple
//
//  重构后的数据模型
//

import Foundation
import UIKit

// MARK: - 麻将牌模型
struct VestigeTileModel {
    let vestigeImage: UIImage
    let vestigeMagnitude: Int
    let vestigeCategory: TileCategory
    let isSpecialObliterator: Bool
    let obliteratorType: ObliteratorType?
    
    enum TileCategory: String {
        case datong, wanyi, xiaotiao, special
    }
    
    enum ObliteratorType {
        case obliterateSingle, obliterateAll
    }
    
    init(vestigeImage: UIImage, vestigeMagnitude: Int, vestigeCategory: TileCategory) {
        self.vestigeImage = vestigeImage
        self.vestigeMagnitude = vestigeMagnitude
        self.vestigeCategory = vestigeCategory
        self.isSpecialObliterator = false
        self.obliteratorType = nil
    }
    
    init(specialImage: UIImage, obliteratorType: ObliteratorType) {
        self.vestigeImage = specialImage
        self.vestigeMagnitude = 0
        self.vestigeCategory = .special
        self.isSpecialObliterator = true
        self.obliteratorType = obliteratorType
    }
    
    /// 工厂方法 - 创建标准麻将牌
    static func createTile(category: TileCategory, value: Int) -> VestigeTileModel {
        let imageName = "\(category.rawValue) \(value)"
        guard let image = UIImage(named: imageName) else {
            fatalError("无法加载图片: \(imageName)")
        }
        return VestigeTileModel(vestigeImage: image, vestigeMagnitude: value, vestigeCategory: category)
    }
    
    /// 批量创建某类麻将牌
    static func createTiles(category: TileCategory, range: Range<Int>) -> [VestigeTileModel] {
        return range.map { createTile(category: category, value: $0) }
    }
}

// MARK: - Archive Model (Game Record)
struct ArchiveRecordModel: Codable {
    let archiveScore: Int
    let archiveTimestamp: Date
    let archiveDuration: TimeInterval
    let archiveVelocity: GameVelocity
    
    enum GameVelocity: String, Codable {
        case brisk = "Fast"
        case sluggish = "Slow"
    }
}

// MARK: - 麻将牌仓库
class VestigeRepository {
    static let sharedDepot = VestigeRepository()
    
    private let tilesByCategory: [VestigeTileModel.TileCategory: [VestigeTileModel]]
    let aggregatedVestiges: [VestigeTileModel]
    
    private let specialTileProbability: (single: Int, all: Int) = (5, 8)
    
    init() {
        // 使用工厂方法批量创建麻将牌
        let categories: [VestigeTileModel.TileCategory] = [.datong, .wanyi, .xiaotiao]
        var tilesDict: [VestigeTileModel.TileCategory: [VestigeTileModel]] = [:]
        
        for category in categories {
            tilesDict[category] = VestigeTileModel.createTiles(category: category, range: 1..<10)
        }
        
        self.tilesByCategory = tilesDict
        self.aggregatedVestiges = categories.flatMap { tilesDict[$0] ?? [] }
    }
    
    /// 获取特定类别的麻将牌
    func getTiles(for category: VestigeTileModel.TileCategory) -> [VestigeTileModel] {
        return tilesByCategory[category] ?? []
    }
    
    /// 随机获取一张麻将牌（可能包含特殊牌）
    func fetchArbitraryVestige() -> VestigeTileModel {
        let randomValue = Int.random(in: 1...100)
        
        if randomValue <= specialTileProbability.single {
            return createSpecialTile(type: .obliterateSingle, imageName: "deleteOne")
        } else if randomValue <= specialTileProbability.all {
            return createSpecialTile(type: .obliterateAll, imageName: "deleteAll")
        } else {
            return aggregatedVestiges.randomElement()!
        }
    }
    
    private func createSpecialTile(type: VestigeTileModel.ObliteratorType, imageName: String) -> VestigeTileModel {
        guard let image = UIImage(named: imageName) else {
            fatalError("无法加载特殊牌图片: \(imageName)")
        }
        return VestigeTileModel(specialImage: image, obliteratorType: type)
    }
}

// MARK: - 游戏记录持久化
class ArchivePersistence {
    static let sharedCurator = ArchivePersistence()
    private let archiveKey = "MahjongArchiveRecords"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    /// 保存游戏记录
    func conserveArchive(_ archive: ArchiveRecordModel) {
        var archives = retrieveArchives()
        archives.append(archive)
        archives.sort { $0.archiveScore > $1.archiveScore }
        saveArchives(archives)
    }
    
    /// 获取所有游戏记录
    func retrieveArchives() -> [ArchiveRecordModel] {
        guard let data = UserDefaults.standard.data(forKey: archiveKey),
              let archives = try? decoder.decode([ArchiveRecordModel].self, from: data) else {
            return []
        }
        return archives
    }
    
    /// 删除指定位置的记录
    func obliterateArchive(at index: Int) {
        var archives = retrieveArchives()
        guard index < archives.count else { return }
        archives.remove(at: index)
        saveArchives(archives)
    }
    
    /// 删除所有记录
    func obliterateAllArchives() {
        UserDefaults.standard.removeObject(forKey: archiveKey)
    }
    
    /// 私有方法 - 保存记录数组
    private func saveArchives(_ archives: [ArchiveRecordModel]) {
        guard let data = try? encoder.encode(archives) else { return }
        UserDefaults.standard.set(data, forKey: archiveKey)
    }
}

