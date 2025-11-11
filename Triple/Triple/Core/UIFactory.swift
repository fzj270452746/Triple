//
//  UIFactory.swift
//  Triple
//
//  重构后的UI组件工厂类
//

import UIKit

/// UI组件工厂 - 统一创建和配置UI元素
class UIFactory {
    
    // MARK: - 图片视图
    static func createBackgroundImageView(named imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    // MARK: - 遮罩视图
    static func createDimmerOverlay(alpha: CGFloat = 0.3) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // MARK: - 标签
    static func createLabel(config: LabelConfig) -> UILabel {
        let label = UILabel()
        label.text = config.text
        label.font = UIFont.systemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: config.fontSize), 
                                       weight: config.weight)
        label.textColor = config.color
        label.textAlignment = config.alignment
        label.numberOfLines = config.numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if config.hasShadow {
            applyShadow(to: label.layer, config: config.shadowConfig)
        }
        
        return label
    }
    
    // MARK: - 按钮
    static func createButton(config: ButtonConfig) -> UIButton {
        let button = UIButton(type: config.buttonType)
        button.setTitle(config.title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: AdaptiveLayoutHelper.calculateFontSize(base: config.fontSize))
        button.setTitleColor(config.titleColor, for: .normal)
        button.backgroundColor = config.backgroundColor
        button.layer.cornerRadius = config.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = config.image {
            button.setImage(image, for: .normal)
        }
        
        if config.hasShadow {
            applyShadow(to: button.layer, config: config.shadowConfig)
        }
        
        return button
    }
    
    // MARK: - 容器视图
    static func createContainerView(config: ContainerConfig) -> UIView {
        let view = UIView()
        view.backgroundColor = config.backgroundColor
        view.layer.cornerRadius = config.cornerRadius
        view.layer.borderWidth = config.borderWidth
        view.layer.borderColor = config.borderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // MARK: - StackView
    static func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    // MARK: - 阴影工具
    static func applyShadow(to layer: CALayer, config: ShadowConfig) {
        layer.shadowColor = config.color.cgColor
        layer.shadowOffset = config.offset
        layer.shadowOpacity = config.opacity
        layer.shadowRadius = config.radius
    }
}

// MARK: - 配置结构体
struct LabelConfig {
    var text: String = ""
    var fontSize: CGFloat = 16
    var weight: UIFont.Weight = .regular
    var color: UIColor = .white
    var alignment: NSTextAlignment = .center
    var numberOfLines: Int = 1
    var hasShadow: Bool = false
    var shadowConfig: ShadowConfig = ShadowConfig()
}

struct ButtonConfig {
    var title: String = ""
    var fontSize: CGFloat = 18
    var titleColor: UIColor = .white
    var backgroundColor: UIColor = .clear
    var cornerRadius: CGFloat = 20
    var buttonType: UIButton.ButtonType = .system
    var image: UIImage? = nil
    var hasShadow: Bool = false
    var shadowConfig: ShadowConfig = ShadowConfig()
}

struct ContainerConfig {
    var backgroundColor: UIColor = .clear
    var cornerRadius: CGFloat = 15
    var borderWidth: CGFloat = 0
    var borderColor: UIColor = .clear
}

struct ShadowConfig {
    var color: UIColor = .black
    var offset: CGSize = CGSize(width: 0, height: 2)
    var opacity: Float = 0.6
    var radius: CGFloat = 3
}

