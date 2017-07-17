//
//  Coordinator.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    var children: [Coordinator] { get set }
    func start()
}
