//
//  SceneDelegate.swift
//  MavericardDeceptex
//
//  Created by Mavericard Deceptex on 2025/3/8.
//

import UIKit
import Adjust
import AppTrackingTransparency

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AdjustDelegate {

    var window: UIWindow?

    // MARK: - Scene Lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure the scene is a UIWindowScene and configure Adjust.
        guard let _ = (scene as? UIWindowScene) else { return }
        configureAdjust()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Start Adjust subsession and request ATT authorization.
        Adjust.trackSubsessionStart()
        requestTrackingAuthorizationIfNeeded()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // End Adjust subsession when the scene is about to move from active state.
        Adjust.trackSubsessionEnd()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called when transitioning from background to foreground.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called when transitioning from foreground to background.
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is being released by the system.
    }
    
    // MARK: - Adjust Configuration
    
    private func configureAdjust() {
        let token = "6muap19a6d8g"
        let environment = ADJEnvironmentProduction
        guard let adjustConfig = ADJConfig(appToken: token, environment: environment) else { return }
        adjustConfig.delegate = self
        adjustConfig.logLevel = ADJLogLevelVerbose
        Adjust.appDidLaunch(adjustConfig)
    }
    
    // MARK: - App Tracking Transparency

    private func requestTrackingAuthorizationIfNeeded() {
        // Delay the request slightly to ensure the app is active.
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    // You can handle the authorization status if needed.
                }
            }
        }
    }
    
    // MARK: - AdjustDelegate Methods
    
    func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {
        print("adjustEventTrackingSucceeded")
    }
    
    func adjustEventTrackingFailed(_ eventFailureResponseData: ADJEventFailure?) {
        print("adjustEventTrackingFailed")
    }
    
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        print("adjustAttributionChanged：\(attribution?.adid ?? "")")
    }
}
