

import UIKit
import CoreData

@main
class NebulousApplicationOrchestrator: UIResponder, UIApplicationDelegate {
    
    private lazy var dataStorageVault: NSPersistentContainer = {
        let vaultContainer = NSPersistentContainer(name: "Triple")
        vaultContainer.loadPersistentStores { (descriptor, potentialError) in
            if let catastrophicError = potentialError as NSError? {
                fatalError("Unresolved catastrophe \(catastrophicError), \(catastrophicError.userInfo)")
            }
        }
        return vaultContainer
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let orchestrationConfig = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        return orchestrationConfig
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Resources deallocated for discarded sessions
    }
    
    func perpetuateDataStorageState() {
        let contextualEnvironment = dataStorageVault.viewContext
        guard contextualEnvironment.hasChanges else { return }
        
        do {
            try contextualEnvironment.save()
        } catch {
            let catastrophicFailure = error as NSError
            fatalError("Unresolved catastrophe \(catastrophicFailure), \(catastrophicFailure.userInfo)")
        }
    }
}
