//
//  UIDevice+Adaptation.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension UIDevice {
    static var isIPadDevice: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhoneDevice: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension UIScreen {
    static var isCompactScreen: Bool {
        return UIScreen.main.bounds.height < 700
    }
    
    static var isMediumScreen: Bool {
        return UIScreen.main.bounds.height >= 700 && UIScreen.main.bounds.height < 900
    }
    
    static var isLargeScreen: Bool {
        return UIScreen.main.bounds.height >= 900
    }
}

extension UIViewController {
    var isLandscapeOrientation: Bool {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.interfaceOrientation.isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
    
    var isPortraitOrientation: Bool {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.interfaceOrientation.isPortrait ?? true
        } else {
            return UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
}

// MARK: - Adaptive Layout Helper
class AdaptiveLayoutHelper {
    
    static func calculateTileSize() -> CGFloat {
        if UIDevice.isIPadDevice {
            return 90
        } else if UIScreen.isCompactScreen {
            return 60
        } else if UIScreen.isMediumScreen {
            return 70
        } else {
            return 80
        }
    }
    
    static func calculateFontSize(base: CGFloat) -> CGFloat {
        if UIDevice.isIPadDevice {
            return base * 1.3
        } else if UIScreen.isCompactScreen {
            return base * 0.85
        } else {
            return base
        }
    }
    
    static func calculateSpacing(base: CGFloat) -> CGFloat {
        if UIDevice.isIPadDevice {
            return base * 1.5
        } else if UIScreen.isCompactScreen {
            return base * 0.7
        } else {
            return base
        }
    }
    
    static func calculateButtonSize(base: CGFloat) -> CGFloat {
        if UIDevice.isIPadDevice {
            return base * 1.3
        } else if UIScreen.isCompactScreen {
            return base * 0.85
        } else {
            return base
        }
    }
}

