//
//  SceneDelegate.swift
//  PopcornPalooza
//
//  Created by Maxim Potapov on 12.10.2023.
//

import UIKit
import SwiftyBeaver

let log = SwiftyBeaver.self

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  private var appCoordinator: AppCoordinator?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    configureLogger()
    let window = UIWindow(windowScene: windowScene)
    self.window = window
    appCoordinator = AppCoordinator(window: window)
    appCoordinator?.start()
    
    KeychainManager.shared.storeAccessToken(token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZGNiOWRlMTE1OWU5OTVkYTMzY2NmYjY1OWQ0ZGEyYiIsInN1YiI6IjY1MjgyMTdmMzc4MDYyMDExYzA5MzA3MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.zK_4lb5GJxJFjolG1s6GQtKrOmnfDElrqp937XIO8sY")
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }

  private func configureLogger() {
    let console = ConsoleDestination()
    console.format = "Beawer - $C $DHH:mm:ss$d $F $M"
    log.addDestination(console)
  }
}

