//
//  Home.swift
//  SafariTabBarUI
//
//  Created by 张亚飞 on 2021/6/21.
//

import SwiftUI

struct Home: View {
    
    var proxy: GeometryProxy
    
    @StateObject var bottomBarModel = BottomBarViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    //keyboard fous state...
    @FocusState var showKeyboard : Bool
    
    var body: some View {
        
        
        ZStack {
            
            let bottomEdge = proxy.safeAreaInsets.bottom
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    
                    ForEach(1...6, id: \.self) { index in
                        
                        Image("p\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.size.width - 30, height: 250)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .padding(.bottom, 70)
                .modifier(OffsetModifier())
                .environmentObject(bottomBarModel)
                
            }
            // to start form 0
            // just set coordinaate space for scrollview
            .coordinateSpace(name: "TabScroll")
//            .overlay(Text("\(bottomBarModel.offset)"))
            
            //searchView
            VStack {
                
                HStack {
                    
                    Button {
                        
                    } label: {
                        
                        Image(systemName: "book")
                            .font(.title)
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                    
                    Button("Cancle") {
                        
                        //closing keyboard
                        showKeyboard.toggle()
                    }
                    .foregroundStyle(.primary)
                    
                }
                //max height for bottom bar adjustment
                .frame(maxHeight: 40)
                //padding bottom bootombar size...
                .padding(.bottom, 70)
                
                
                //now  you extra content
                if showKeyboard {
                    
                    Text("Favourite's")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.top)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .opacity(showKeyboard ? 1 : 0)
            
            
            
            
            //you can alse use
            //swiftui 3.0
            //safeareaview
            //but since when the search field clicked a new page will be visible..
            //so it will not be perfect
            
            //BottomBar
            BottomBar(showKeyboard: _showKeyboard)
                .environmentObject(bottomBarModel)
                .padding(.top, 50)
                .offset(y: bottomBarModel.tabState == .floating ? 0 : bottomEdge)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BottomBar: View {
    
    @EnvironmentObject var bottomBarModel: BottomBarViewModel
    
    @Namespace var animation
    
    @FocusState var showKeyboard : Bool
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: bottomBarModel.tabState == .floating ? 12 : 0)
                .fill(.regularMaterial)
                .colorScheme(bottomBarModel.tabState == .floating  ? .dark : .light)
            
            HStack(spacing: 15) {
                
                if bottomBarModel.tabState == .floating  {
                    
                    Button {
                        
                    } label: {
                        
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    .padding(.trailing, 10)
                    
                    Button {
                        
                    } label: {
                        
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                
                
                HStack {
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    if bottomBarModel.tabState == .floating {
                        
                        TextField("", text: $bottomBarModel.searchText)
                            .matchedGeometryEffect(id: "SearchField", in: animation)
                            .focused($showKeyboard)
                            .submitLabel(.go)
                        
                    } else {
                        
                        TextField("", text: $bottomBarModel.searchText)
                            .matchedGeometryEffect(id: "SearchField", in: animation)
//                            .focused($showKeyboard)
                    }
                    
                    
                    
                    Image(systemName: "lock")
                        .symbolVariant(.fill)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                }
                .offset(y: bottomBarModel.tabState == .floating ? 0 : -10)
                .frame(maxWidth: bottomBarModel.tabState == .floating ? nil : 200)
                
               
                if bottomBarModel.tabState == .floating {
                    
                    Button {
                        
                    } label: {
                        
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    
                    Button {
                        
                    } label: {
                        
                        Image(systemName: "square.on.square")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .colorScheme(bottomBarModel.tabState == .floating ? .dark : .light)
            .padding(.horizontal, 20)
            
        }
        .frame(height: 60)
        .padding([.horizontal], bottomBarModel.tabState == .expanded ? 0 : 15)
        .frame(maxHeight: .infinity, alignment: showKeyboard ? .top : .bottom)
        .onTapGesture {
            
            withAnimation(.easeOut.speed(1.5)) {
                bottomBarModel.tabState = .floating
            }
        }
        .animation(.easeOut, value: showKeyboard)
    }
}


//offset Modifier
struct OffsetModifier: ViewModifier {
    
    @EnvironmentObject var bottomBarModel: BottomBarViewModel
    
    func body(content: Content) -> some View {
        
        content.overlay(
        
            GeometryReader { proxy -> Color in

                let minY = proxy.frame(in: .named("TabScroll")).minY
                
                DispatchQueue.main.async {
                    
                    // checking and toggling states...
                    
                    // durationOffse....
                    let durationOffset: CGFloat = 35
                    
                    
                    if minY < bottomBarModel.offset {
                        
//                        print("up")
                        if bottomBarModel.offset  < 0 && -minY > (bottomBarModel.lastStoreOffset + durationOffset){
                            
                            withAnimation(.easeInOut.speed(1.5)) {
                                //updating state
                                bottomBarModel.tabState = .expanded
                            }
                            
                            bottomBarModel.lastStoreOffset = -bottomBarModel.offset
                        }
                    }
                    
                    
                    if minY > bottomBarModel.offset && -minY < (bottomBarModel.lastStoreOffset - durationOffset){
                        
//                        print("dowun")
                        withAnimation(.easeInOut.speed(1.5)) {
                            //updating state
                            bottomBarModel.tabState = .floating
                        }
                        
                        //storing last offset...
                        bottomBarModel.lastStoreOffset = -bottomBarModel.offset
                    }
                    
                    
                    bottomBarModel.offset = minY
                }
                
                return Color.clear
            }
            
            ,alignment: .top
        )
    }
}
