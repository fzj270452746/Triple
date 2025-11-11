//
//  TripleDatas.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import Foundation
import UIKit

// MARK: - Vestige Model (Mahjong Tile Model)
struct VestigeTileModel {
    let vestigeImage: UIImage
    let vestigeMagnitude: Int
    let vestigeCategory: TileCategory
    let isSpecialObliterator: Bool
    let obliteratorType: ObliteratorType?
    
    enum TileCategory: String {
        case datong
        case wanyi
        case xiaotiao
        case special
    }
    
    enum ObliteratorType {
        case obliterateSingle
        case obliterateAll
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

// MARK: - Vestige Repository
class VestigeRepository {
    static let sharedDepot = VestigeRepository()
    
    let datongVestiges: [VestigeTileModel]
    let wanyiVestiges: [VestigeTileModel]
    let xiaotiaoVestiges: [VestigeTileModel]
    let aggregatedVestiges: [VestigeTileModel]
    
    init() {
        datongVestiges = [
            VestigeTileModel(vestigeImage: UIImage(named: "datong 1")!, vestigeMagnitude: 1, vestigeCategory: .datong),
            VestigeTileModel(vestigeImage: UIImage(named: "datong 2")!, vestigeMagnitude: 2, vestigeCategory: .datong),
            VestigeTileModel(vestigeImage: UIImage(named: "datong 3")!, vestigeMagnitude: 3, vestigeCategory: .datong),
            VestigeTileModel(vestigeImage: UIImage(named: "datong 4")!, vestigeMagnitude: 4, vestigeCategory: .datong),
            VestigeTileModel(vestigeImage: UIImage(named: "datong 5")!, vestigeMagnitude: 5, vestigeCategory: .datong),
            VestigeTileModel(vestigeImage: UIImage(named: "datong 6")!, vestigeMagnitude: 6, vestigeCategory: .datong),
            VestigeTileModel(vestigeImage: UIImage(named: "datong 7")!, vestigeMagnitude: 7, vestigeCategory: .datong),
            VestigeTileModel(vestigeImage: UIImage(named: "datong 8")!, vestigeMagnitude: 8, vestigeCategory: .datong),
            VestigeTileModel(vestigeImage: UIImage(named: "datong 9")!, vestigeMagnitude: 9, vestigeCategory: .datong)
        ]
        
        wanyiVestiges = [
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 1")!, vestigeMagnitude: 1, vestigeCategory: .wanyi),
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 2")!, vestigeMagnitude: 2, vestigeCategory: .wanyi),
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 3")!, vestigeMagnitude: 3, vestigeCategory: .wanyi),
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 4")!, vestigeMagnitude: 4, vestigeCategory: .wanyi),
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 5")!, vestigeMagnitude: 5, vestigeCategory: .wanyi),
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 6")!, vestigeMagnitude: 6, vestigeCategory: .wanyi),
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 7")!, vestigeMagnitude: 7, vestigeCategory: .wanyi),
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 8")!, vestigeMagnitude: 8, vestigeCategory: .wanyi),
            VestigeTileModel(vestigeImage: UIImage(named: "wanyi 9")!, vestigeMagnitude: 9, vestigeCategory: .wanyi)
        ]
        
        xiaotiaoVestiges = [
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 1")!, vestigeMagnitude: 1, vestigeCategory: .xiaotiao),
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 2")!, vestigeMagnitude: 2, vestigeCategory: .xiaotiao),
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 3")!, vestigeMagnitude: 3, vestigeCategory: .xiaotiao),
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 4")!, vestigeMagnitude: 4, vestigeCategory: .xiaotiao),
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 5")!, vestigeMagnitude: 5, vestigeCategory: .xiaotiao),
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 6")!, vestigeMagnitude: 6, vestigeCategory: .xiaotiao),
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 7")!, vestigeMagnitude: 7, vestigeCategory: .xiaotiao),
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 8")!, vestigeMagnitude: 8, vestigeCategory: .xiaotiao),
            VestigeTileModel(vestigeImage: UIImage(named: "xiaotiao 9")!, vestigeMagnitude: 9, vestigeCategory: .xiaotiao)
        ]
        
        aggregatedVestiges = datongVestiges + wanyiVestiges + xiaotiaoVestiges
    }
    
    func fetchArbitraryVestige() -> VestigeTileModel {
        let randomValue = Int.random(in: 1...100)
        
        if randomValue <= 5 {
            return VestigeTileModel(specialImage: UIImage(named: "deleteOne")!, obliteratorType: .obliterateSingle)
        } else if randomValue <= 8 {
            return VestigeTileModel(specialImage: UIImage(named: "deleteAll")!, obliteratorType: .obliterateAll)
        } else {
            return aggregatedVestiges.randomElement()!
        }
    }
}

// MARK: - Archive Persistence
class ArchivePersistence {
    static let sharedCurator = ArchivePersistence()
    let archiveKey = "MahjongArchiveRecords"
    
    func conserveArchive(_ archive: ArchiveRecordModel) {
        var archives = retrieveArchives()
        archives.append(archive)
        archives.sort { $0.archiveScore > $1.archiveScore }
        
        if let encodedData = try? JSONEncoder().encode(archives) {
            UserDefaults.standard.set(encodedData, forKey: archiveKey)
        }
    }
    
    func retrieveArchives() -> [ArchiveRecordModel] {
        guard let data = UserDefaults.standard.data(forKey: archiveKey),
              let archives = try? JSONDecoder().decode([ArchiveRecordModel].self, from: data) else {
            return []
        }
        return archives
    }
    
    func obliterateArchive(at index: Int) {
        var archives = retrieveArchives()
        guard index < archives.count else { return }
        archives.remove(at: index)
        
        if let encodedData = try? JSONEncoder().encode(archives) {
            UserDefaults.standard.set(encodedData, forKey: archiveKey)
        }
    }
    
    func obliterateAllArchives() {
        UserDefaults.standard.removeObject(forKey: archiveKey)
    }
}

