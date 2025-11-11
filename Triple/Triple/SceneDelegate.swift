
import UIKit
import AppTrackingTransparency

class EtherealSceneCoordinator: UIResponder, UIWindowSceneDelegate {
    
    var primaryDisplayPortal: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let etherealWindowScene = (scene as? UIWindowScene) else { return }
        
        primaryDisplayPortal = UIWindow(windowScene: etherealWindowScene)
        let hierarchicalNavigator = UINavigationController(rootViewController: CosmicEntryPointController())
        hierarchicalNavigator.navigationBar.isHidden = true
        primaryDisplayPortal?.rootViewController = hierarchicalNavigator
        primaryDisplayPortal?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene resources deallocated
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Scene transitioning to inactive state
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Scene transitioning to foreground
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let orchestrator = UIApplication.shared.delegate as? NebulousApplicationOrchestrator else { return }
        orchestrator.perpetuateDataStorageState()
    }
}
