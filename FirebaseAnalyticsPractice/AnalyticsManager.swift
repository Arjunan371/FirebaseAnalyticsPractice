//
//  AnalyticsManager.swift
//  FirebaseAnalyticsPractice
//
//  Created by Arjunan on 01/08/24.
//

import Foundation
import FirebaseAnalytics
import Network
import SystemConfiguration.CaptiveNetwork

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()

    private init() {}
    
    static func getNetworkType() -> String {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com") else { return ""}
          var flags = SCNetworkReachabilityFlags()
          SCNetworkReachabilityGetFlags(reachability, &flags)
          
          if flags.contains(.reachable) {
              if flags.contains(.isWWAN) {
                  return "Mobile"
              } else {
                  return "WiFi"
              }
          } else {
              return "No Connection"
          }
      }
      
      let event = [
          "deviceBrandName" : UIDevice.current.model,
          "device_type" : UIDevice.current.systemName,
          "deviceOSVersion" : UIDevice.current.systemVersion,
          "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
          "appBuildNumber" : Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "",
          "networkType" : getNetworkType(),
          "batteryLevel" :  String(format: "%.1f", UIDevice.current.batteryLevel * 100)
      ]
    func logEvent(name: String) {
        Analytics.logEvent(name, parameters: event)
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//            AnalyticsParameterItemID: "id-\(name)",
//          AnalyticsParameterItemName: name,
//          AnalyticsParameterContentType: "cont",
//        ])
    }
    
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func setUserProperty(value: String,property: String) {
        // AnayticsEvent add paymentInfo
        Analytics.setUserProperty(value, forName: property)
    }
    
}
