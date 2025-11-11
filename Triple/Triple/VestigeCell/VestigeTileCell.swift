//
//  VestigeTileCell.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class EnigmaticTessellationCapsule: UITableViewCell {
    
    let iconographicPortrait: UIImageView = {
        let portraitView = UIImageView()
        portraitView.contentMode = .scaleAspectFit
        portraitView.translatesAutoresizingMaskIntoConstraints = false
        portraitView.layer.cornerRadius = 10
        portraitView.clipsToBounds = true
        portraitView.layer.shadowColor = UIColor.black.cgColor
        portraitView.layer.shadowOffset = CGSize(width: 0, height: 2)
        portraitView.layer.shadowOpacity = 0.5
        portraitView.layer.shadowRadius = 3
        return portraitView
    }()
    
    let potencyIndicatorGlyph: UILabel = {
        let glyphLabel = UILabel()
        glyphLabel.font = UIFont.boldSystemFont(ofSize: 24)
        glyphLabel.textColor = .white
        glyphLabel.textAlignment = .center
        glyphLabel.translatesAutoresizingMaskIntoConstraints = false
        glyphLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        glyphLabel.layer.cornerRadius = 15
        glyphLabel.clipsToBounds = true
        return glyphLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        orchestrateCapsuleArchitecture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func orchestrateCapsuleArchitecture() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(iconographicPortrait)
        contentView.addSubview(potencyIndicatorGlyph)
        
        let tessellationMeasurement = ResponsiveGeometryCalibrator.computeTessellationDimension()
        let glyphMeasurement: CGFloat = UIDevice.isPadlockApparatus ? 35 : 30
        
        NSLayoutConstraint.activate([
            iconographicPortrait.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconographicPortrait.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconographicPortrait.widthAnchor.constraint(equalToConstant: tessellationMeasurement * 0.85),
            iconographicPortrait.heightAnchor.constraint(equalToConstant: tessellationMeasurement * 0.85),
            
            potencyIndicatorGlyph.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            potencyIndicatorGlyph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            potencyIndicatorGlyph.widthAnchor.constraint(equalToConstant: glyphMeasurement),
            potencyIndicatorGlyph.heightAnchor.constraint(equalToConstant: glyphMeasurement)
        ])
        
        potencyIndicatorGlyph.font = UIFont.boldSystemFont(ofSize: ResponsiveGeometryCalibrator.computeTypographicMagnitude(foundationSize: 24))
    }
    
    func configureCapsuleWithTessellation(_ tessellation: EnigmaticTessellationEmbodiment, exhibitPotency: Bool) {
        iconographicPortrait.image = tessellation.iconographicRepresentation
        
        if tessellation.possessesEradicationCapability {
            potencyIndicatorGlyph.isHidden = true
        } else {
            potencyIndicatorGlyph.text = "\(tessellation.numericalPotency)"
            potencyIndicatorGlyph.isHidden = !exhibitPotency
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconographicPortrait.image = nil
        potencyIndicatorGlyph.text = ""
    }
}
