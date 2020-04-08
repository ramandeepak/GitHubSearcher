//
//  BaseViewModel.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/6/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

protocol BindingViewModel: class {
    var view: BindingView? { get set }
}

class BaseViewModel: BindingViewModel {
    internal weak var view: BindingView?
}
