//
//  ContentView.swift
//  SafariTabBarUI
//
//  Created by 张亚飞 on 2021/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        // since we need the bottom edge..
        // were using geomtry reader...
        
        GeometryReader { proxy  in
            Home(proxy: proxy)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
