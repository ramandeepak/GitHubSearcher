//
//  BindingViewProtocol.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/6/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

enum ViewType {
    case table(indexPathsToReload: [IndexPath]?)
    case other
}

protocol BindingView: class {
    func refresh(type: ViewType)
}
