//
//  TripleDatas.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import Foundation
import UIKit

// MARK: - Enigmatic Tessellation Embodiment
struct EnigmaticTessellationEmbodiment {
    let iconographicRepresentation: UIImage
    let numericalPotency: Int
    let taxonomicClassification: TaxonomicDivision
    let possessesEradicationCapability: Bool
    let eradicationMethodology: AnnihilationTechnique?
    
    enum TaxonomicDivision: String {
        case datong
        case wanyi
        case xiaotiao
        case esoteric
    }
    
    enum AnnihilationTechnique {
        case singularColumnPurge
        case universalGridObliteration
    }
    
    init(iconographicRepresentation: UIImage, numericalPotency: Int, taxonomicClassification: TaxonomicDivision) {
        self.iconographicRepresentation = iconographicRepresentation
        self.numericalPotency = numericalPotency
        self.taxonomicClassification = taxonomicClassification
        self.possessesEradicationCapability = false
        self.eradicationMethodology = nil
    }
    
    init(esotericIcon: UIImage, annihilationApproach: AnnihilationTechnique) {
        self.iconographicRepresentation = esotericIcon
        self.numericalPotency = 0
        self.taxonomicClassification = .esoteric
        self.possessesEradicationCapability = true
        self.eradicationMethodology = annihilationApproach
    }
}

// MARK: - Chronological Achievement Documentation
struct ChronologicalAchievementDocumentation: Codable {
    let accumulatedPoints: Int
    let temporalMomentStamp: Date
    let engagementTimespan: TimeInterval
    let executionCadence: ExecutionCadence
    
    enum ExecutionCadence: String, Codable {
        case accelerated = "Fast"
        case decelerated = "Slow"
    }
}

// MARK: - Tessellation Anthology Emporium
class TessellationAnthologyEmporium {
    static let singularInstance = TessellationAnthologyEmporium()
    
    let datongCollectionArray: [EnigmaticTessellationEmbodiment]
    let wanyiCollectionArray: [EnigmaticTessellationEmbodiment]
    let xiaotiaoCollectionArray: [EnigmaticTessellationEmbodiment]
    let amalgamatedCollectionRepository: [EnigmaticTessellationEmbodiment]
    
    init() {
        datongCollectionArray = (1...9).map { index in
            EnigmaticTessellationEmbodiment(
                iconographicRepresentation: UIImage(named: "datong \(index)")!,
                numericalPotency: index,
                taxonomicClassification: .datong
            )
        }
        
        wanyiCollectionArray = (1...9).map { index in
            EnigmaticTessellationEmbodiment(
                iconographicRepresentation: UIImage(named: "wanyi \(index)")!,
                numericalPotency: index,
                taxonomicClassification: .wanyi
            )
        }
        
        xiaotiaoCollectionArray = (1...9).map { index in
            EnigmaticTessellationEmbodiment(
                iconographicRepresentation: UIImage(named: "xiaotiao \(index)")!,
                numericalPotency: index,
                taxonomicClassification: .xiaotiao
            )
        }
        
        amalgamatedCollectionRepository = datongCollectionArray + wanyiCollectionArray + xiaotiaoCollectionArray
    }
    
    func procureArbitraryTessellation() -> EnigmaticTessellationEmbodiment {
        let stochasticValue = Int.random(in: 1...100)
        
        if stochasticValue <= 5 {
            return EnigmaticTessellationEmbodiment(
                esotericIcon: UIImage(named: "deleteOne")!,
                annihilationApproach: .singularColumnPurge
            )
        } else if stochasticValue <= 8 {
            return EnigmaticTessellationEmbodiment(
                esotericIcon: UIImage(named: "deleteAll")!,
                annihilationApproach: .universalGridObliteration
            )
        } else {
            return amalgamatedCollectionRepository.randomElement()!
        }
    }
}

// MARK: - Chronological Achievement Conservatory
class ChronologicalAchievementConservatory {
    static let singularCurator = ChronologicalAchievementConservatory()
    private let permanentStorageIdentifier = "MahjongArchiveRecords"
    
    func perpetuateAchievement(_ documentation: ChronologicalAchievementDocumentation) {
        var existingDocumentations = retrievePerpetuatedAchievements()
        existingDocumentations.append(documentation)
        existingDocumentations.sort { $0.accumulatedPoints > $1.accumulatedPoints }
        
        if let serializedData = try? JSONEncoder().encode(existingDocumentations) {
            UserDefaults.standard.set(serializedData, forKey: permanentStorageIdentifier)
        }
    }
    
    func retrievePerpetuatedAchievements() -> [ChronologicalAchievementDocumentation] {
        guard let persistedData = UserDefaults.standard.data(forKey: permanentStorageIdentifier),
              let decodedDocumentations = try? JSONDecoder().decode([ChronologicalAchievementDocumentation].self, from: persistedData) else {
            return []
        }
        return decodedDocumentations
    }
    
    func eradicateSpecificAchievement(at indexPosition: Int) {
        var existingDocumentations = retrievePerpetuatedAchievements()
        guard indexPosition < existingDocumentations.count else { return }
        existingDocumentations.remove(at: indexPosition)
        
        if let serializedData = try? JSONEncoder().encode(existingDocumentations) {
            UserDefaults.standard.set(serializedData, forKey: permanentStorageIdentifier)
        }
    }
    
    func annihilateAllPerpetuatedAchievements() {
        UserDefaults.standard.removeObject(forKey: permanentStorageIdentifier)
    }
}
