//
//  VestigeTileCell.swift
//  Triple
//
//  重构后的麻将牌单元格
//

import UIKit

class VestigeTileCell: UITableViewCell {
    
    private lazy var vestigeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        UIFactory.applyShadow(to: imageView.layer, config: ShadowConfig(opacity: 0.5, radius: 3))
        return imageView
    }()
    
    private lazy var magnitudeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: 24))
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
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        [vestigeImageView, magnitudeLabel].forEach { contentView.addSubview($0) }
        
        let tileSize = AdaptiveLayoutHelper.calculateTileSize()
        let labelSize: CGFloat = UIDevice.isIPadDevice ? 35 : 30
        
        LayoutManager.centerInSuperview(vestigeImageView, in: contentView)
        LayoutManager.setSize(vestigeImageView, width: tileSize * 0.85, height: tileSize * 0.85)
        LayoutManager.setSize(magnitudeLabel, width: labelSize, height: labelSize)
        
        NSLayoutConstraint.activate([
            magnitudeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            magnitudeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
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

