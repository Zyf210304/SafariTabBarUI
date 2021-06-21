//
//  BottomBarViewModel.swift
//  SafariTabBarUI
//
//  Created by 张亚飞 on 2021/6/21.
//

import SwiftUI

class BottomBarViewModel: ObservableObject {
    
    @Published var searchText = "iJustine"
    
    @Published var offset: CGFloat = 0
    @Published var lastStoreOffset: CGFloat = 0
    @Published var tabState: BottomSate = .floating
}

enum BottomSate {
    
    case floating
    case expanded
}
