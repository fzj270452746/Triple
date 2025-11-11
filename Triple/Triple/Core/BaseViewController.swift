//
//  BaseViewController.swift
//  Triple
//
//  基础视图控制器 - 提供通用功能
//

import UIKit

/// 基础视图控制器 - 所有视图控制器的基类
class BaseViewController: UIViewController {
    
    // MARK: - 通用UI组件
    lazy var backgroundImageView: UIImageView = {
        return UIFactory.createBackgroundImageView(named: "tripleImage")
    }()
    
    lazy var dimmerOverlay: UIView = {
        return UIFactory.createDimmerOverlay(alpha: 0.3)
    }()
    
    lazy var backButton: UIButton = {
        let config = ButtonConfig(
            title: "← Back",
            fontSize: 18,
            titleColor: .white,
            backgroundColor: UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 0.8),
            cornerRadius: 20,
            hasShadow: true,
            shadowConfig: ShadowConfig(offset: CGSize(width: 0, height: 2), opacity: 0.6, radius: 3)
        )
        let button = UIFactory.createButton(config: config)
        button.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 属性
    var showsBackButton: Bool = false {
        didSet {
            if showsBackButton && !backButtonAdded {
                setupBackButton()
            }
        }
    }
    var hidesNavigationBar: Bool = true
    private var backButtonAdded = false
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hidesNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        // 确保返回按钮在最上层
        if showsBackButton && backButtonAdded {
            view.bringSubviewToFront(backButton)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if hidesNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    // MARK: - 设置方法
    private func setupBackground() {
        view.addSubview(backgroundImageView)
        view.addSubview(dimmerOverlay)
        
        LayoutManager.fillSuperview(backgroundImageView, in: view)
        LayoutManager.fillSuperview(dimmerOverlay, in: view)
    }
    
    private func setupBackButton() {
        guard !backButtonAdded else { return }
        
        view.addSubview(backButton)
        backButtonAdded = true
        
        let safeArea = view.safeAreaLayoutGuide
        let spacing = AdaptiveLayoutHelper.calculateSpacing(base: 20)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            backButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - 操作
    @objc dynamic func handleBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 工具方法
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func showConfirmAlert(title: String, message: String, onConfirm: @escaping () -> Void) {
        let confirm = UIAlertAction(title: "OK", style: .default) { _ in onConfirm() }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        showAlert(title: title, message: message, actions: [confirm, cancel])
    }
}

