//
//  LayoutManager.swift
//  Triple
//
//  约束管理器 - 统一管理布局约束
//

import UIKit

/// 布局管理器 - 简化约束创建
class LayoutManager {
    
    // MARK: - 全屏填充约束
    static func fillSuperview(_ view: UIView, in superview: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    // MARK: - 居中约束
    static func centerInSuperview(_ view: UIView, in superview: UIView, offset: CGPoint = .zero) {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y)
        ])
    }
    
    // MARK: - 尺寸约束
    static func setSize(_ view: UIView, width: CGFloat? = nil, height: CGFloat? = nil) {
        if let w = width {
            view.widthAnchor.constraint(equalToConstant: w).isActive = true
        }
        if let h = height {
            view.heightAnchor.constraint(equalToConstant: h).isActive = true
        }
    }
    
    // MARK: - 边距约束
    static func applyEdgeInsets(_ view: UIView, in superview: UIView, insets: UIEdgeInsets) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    // MARK: - 安全区域边距约束
    static func applySafeAreaInsets(_ view: UIView, in parentView: UIView, insets: UIEdgeInsets) {
        let safeArea = parentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    // MARK: - 垂直排列约束
    static func stackVertically(views: [UIView], in superview: UIView, spacing: CGFloat, topOffset: CGFloat = 0) {
        guard views.count > 0 else { return }
        
        if let first = views.first {
            first.topAnchor.constraint(equalTo: superview.topAnchor, constant: topOffset).isActive = true
        }
        
        for i in 0..<views.count - 1 {
            views[i + 1].topAnchor.constraint(equalTo: views[i].bottomAnchor, constant: spacing).isActive = true
        }
    }
}

