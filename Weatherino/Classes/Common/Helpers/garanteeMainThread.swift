//
//  garanteeMainThread.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 28.02.2023.
//

import Foundation.NSThread

func garanteeMainThread(_ work: @escaping (() -> ()) ) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
