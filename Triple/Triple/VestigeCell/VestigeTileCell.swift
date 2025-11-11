//
//  VestigeTileCell.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class VestigeTileCell: UITableViewCell {
    
    let vestigeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 3
        return imageView
    }()
    
    let magnitudeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        establishCellInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func establishCellInterface() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(vestigeImageView)
        contentView.addSubview(magnitudeLabel)
        
        let tileSize = AdaptiveLayoutHelper.calculateTileSize()
        let labelSize: CGFloat = UIDevice.isIPadDevice ? 35 : 30
        
        NSLayoutConstraint.activate([
            vestigeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vestigeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            vestigeImageView.widthAnchor.constraint(equalToConstant: tileSize * 0.85),
            vestigeImageView.heightAnchor.constraint(equalToConstant: tileSize * 0.85),
            
            magnitudeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            magnitudeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            magnitudeLabel.widthAnchor.constraint(equalToConstant: labelSize),
            magnitudeLabel.heightAnchor.constraint(equalToConstant: labelSize)
        ])
        
        magnitudeLabel.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 24))
    }
    
    func configureWithVestige(_ vestige: VestigeTileModel, showMagnitude: Bool) {
        vestigeImageView.image = vestige.vestigeImage
        
        if vestige.isSpecialObliterator {
            magnitudeLabel.isHidden = true
        } else {
            magnitudeLabel.text = "\(vestige.vestigeMagnitude)"
            magnitudeLabel.isHidden = !showMagnitude
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vestigeImageView.image = nil
        magnitudeLabel.text = ""
    }
}

