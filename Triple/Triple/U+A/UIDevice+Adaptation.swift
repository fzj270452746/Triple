//
//  UIDevice+Adaptation.swift
//  Triple
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension UIDevice {
    static var isPadlockApparatus: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isHandheldGadget: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension UIScreen {
    static var isDiminutiveViewport: Bool {
        return UIScreen.main.bounds.height < 700
    }
    
    static var isIntermediateViewport: Bool {
        return UIScreen.main.bounds.height >= 700 && UIScreen.main.bounds.height < 900
    }
    
    static var isExpansiveViewport: Bool {
        return UIScreen.main.bounds.height >= 900
    }
}

extension UIViewController {
    var isHorizontallyPostured: Bool {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.interfaceOrientation.isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
    
    var isVerticallyPostured: Bool {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.interfaceOrientation.isPortrait ?? true
        } else {
            return UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
}

// MARK: - Responsive Geometry Calibrator
class ResponsiveGeometryCalibrator {
    
    static func computeTessellationDimension() -> CGFloat {
        if UIDevice.isPadlockApparatus {
            return 90
        } else if UIScreen.isDiminutiveViewport {
            return 60
        } else if UIScreen.isIntermediateViewport {
            return 70
        } else {
            return 80
        }
    }
    
    static func computeTypographicMagnitude(foundationSize: CGFloat) -> CGFloat {
        if UIDevice.isPadlockApparatus {
            return foundationSize * 1.3
        } else if UIScreen.isDiminutiveViewport {
            return foundationSize * 0.85
        } else {
            return foundationSize
        }
    }
    
    static func computeInterstitialGap(foundationGap: CGFloat) -> CGFloat {
        if UIDevice.isPadlockApparatus {
            return foundationGap * 1.5
        } else if UIScreen.isDiminutiveViewport {
            return foundationGap * 0.7
        } else {
            return foundationGap
        }
    }
    
    static func computeInteractiveElementDimension(foundationDimension: CGFloat) -> CGFloat {
        if UIDevice.isPadlockApparatus {
            return foundationDimension * 1.3
        } else if UIScreen.isDiminutiveViewport {
            return foundationDimension * 0.85
        } else {
            return foundationDimension
        }
    }
}
