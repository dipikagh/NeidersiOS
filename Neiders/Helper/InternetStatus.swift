//
//  InternetStatus.swift
//  TCSTransit
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation
import Network

class InternetStatus {
    
    // MARK: - Properties
    
    static let shared = InternetStatus()
    
    var monitor: NWPathMonitor?
    
    var isMonitoring = false
    
    var didStartMonitoringHandler: (() -> Void)?
    
    var didStopMonitoringHandler: (() -> Void)?
    
    var netStatusChangeHandler: ((_ path: NWPath) -> Void)?
    
    
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    
    var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    
    
    var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    
    // MARK: - Init & Deinit
    
    private init() {
        
    }
    
    
    deinit {
        stopMonitoring()
    }
    
    
    // MARK: - Method Implementation
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Internet.Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { (path) in
            self.netStatusChangeHandler?(path)
        }
        
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
    
}
