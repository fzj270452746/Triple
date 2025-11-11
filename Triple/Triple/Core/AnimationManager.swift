//
//  AnimationManager.swift
//  Triple
//
//  动画管理器 - 统一管理动画效果
//

import UIKit

/// 动画管理器 - 提供可复用的动画效果
class AnimationManager {
    
    // MARK: - 缩放动画
    static func scaleAnimation(for view: UIView, scale: CGFloat = 1.2, duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            UIView.animate(withDuration: duration) {
                view.transform = .identity
            } completion: { _ in
                completion?()
            }
        }
    }
    
    // MARK: - 淡入动画
    static func fadeIn(_ view: UIView, duration: TimeInterval = 0.3, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        view.alpha = 0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn) {
            view.alpha = 1
        } completion: { _ in
            completion?()
        }
    }
    
    // MARK: - 淡出动画
    static func fadeOut(_ view: UIView, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0
        }) { _ in
            completion?()
        }
    }
    
    // MARK: - 弹簧动画
    static func springAnimation(for view: UIView, damping: CGFloat = 0.7, velocity: CGFloat = 0.5, 
                               duration: TimeInterval = 0.8, delay: TimeInterval = 0,
                               animations: @escaping () -> Void, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, 
                      initialSpringVelocity: velocity, options: .curveEaseOut) {
            animations()
        } completion: { _ in
            completion?()
        }
    }
    
    // MARK: - 从上方滑入
    static func slideFromTop(_ view: UIView, distance: CGFloat = 50, duration: TimeInterval = 0.8, 
                            delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: -distance)
        
        springAnimation(for: view, duration: duration, delay: delay, animations: {
            view.alpha = 1
            view.transform = .identity
        }, completion: completion)
    }
    
    // MARK: - 从左侧滑入
    static func slideFromLeft(_ view: UIView, distance: CGFloat = 100, duration: TimeInterval = 0.8,
                             delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: -distance, y: 0)
        
        springAnimation(for: view, duration: duration, delay: delay, animations: {
            view.alpha = 1
            view.transform = .identity
        }, completion: completion)
    }
    
    // MARK: - 从右侧滑入
    static func slideFromRight(_ view: UIView, distance: CGFloat = 100, duration: TimeInterval = 0.8,
                              delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: distance, y: 0)
        
        springAnimation(for: view, duration: duration, delay: delay, animations: {
            view.alpha = 1
            view.transform = .identity
        }, completion: completion)
    }
    
    // MARK: - 缩放淡入
    static func scaleAndFadeIn(_ view: UIView, fromScale: CGFloat = 0.5, duration: TimeInterval = 0.8,
                              delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
        
        springAnimation(for: view, damping: 0.6, velocity: 0.8, duration: duration, delay: delay, animations: {
            view.alpha = 1
            view.transform = .identity
        }, completion: completion)
    }
    
    // MARK: - 缩放淡出
    static func scaleAndFadeOut(_ view: UIView, toScale: CGFloat = 1.3, duration: TimeInterval = 0.3,
                               completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            view.transform = CGAffineTransform(scaleX: toScale, y: toScale)
            view.alpha = 0
        }) { _ in
            view.transform = .identity
            view.alpha = 1
            completion?()
        }
    }
    
    // MARK: - 抖动动画
    static func shake(_ view: UIView, intensity: CGFloat = 10, duration: TimeInterval = 0.5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.values = [-intensity, intensity, -intensity, intensity, -intensity/2, intensity/2, 0]
        view.layer.add(animation, forKey: "shake")
    }
    
    // MARK: - 脉冲动画
    static func pulse(_ view: UIView, scale: CGFloat = 1.1, duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            UIView.animate(withDuration: duration) {
                view.transform = .identity
            }
        }
    }
}

