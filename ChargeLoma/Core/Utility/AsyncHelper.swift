//
//  AsyncHelper.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation

public enum GCD {
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
    
    public var queue: DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
        case .userInteractive:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        case .userInitiated:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        case .utility:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
        case .background:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        }
    }
}

public typealias Dispatch = DispatchWorkItem

public func dispatch(_ gcd:GCD, in seconds:Double? = nil, block: @escaping () -> Void) -> Dispatch {
    // If seconds is provided.
    if let seconds = seconds {
        let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
        let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
        return at(time, block: block, queue: gcd.queue)
    }
    // Otherwise
    return asyncNow(block, queue: gcd.queue)
}

fileprivate func asyncNow(_ block: @escaping ()->(), queue: DispatchQueue) -> Dispatch {
    let o = DispatchWorkItem(qos: queue.qos, flags: .inheritQoS, block: block)
    queue.async(execute: o)
    return o
}

fileprivate func at(_ time: DispatchTime, block: @escaping ()->(), queue: DispatchQueue) -> Dispatch {
    // See Async.async() for comments
    let r = DispatchWorkItem(qos: queue.qos, flags: .inheritQoS, block: block)
    queue.asyncAfter(deadline: time, execute: r)
    return r
}
