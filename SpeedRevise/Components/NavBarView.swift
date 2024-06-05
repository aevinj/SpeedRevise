//
//  NavBar.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 29/05/2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case folder
    case person
}

struct NavBarView: View {
    @Binding var selectedTab: Tab
    @Environment(\.colorScheme) var colorScheme
    
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack{
            Divider()
                .frame(width: UIScreen.main.bounds.size.width-100, height: 3)
                .overlay(RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: "E6E6E6")))
                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .foregroundStyle(selectedTab == .house ? (colorScheme == .light ? Color.white : Color.black) : (colorScheme == .dark ? Color.white : Color.black))
                        .scaleEffect(selectedTab == tab ? 1.35 : 1.0)
                        .font(.system(size: 20, weight: .black))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .padding()
        }
        .padding(.top, 0)
        .frame(width: nil, height: 80)
    }
}

#Preview {
    NavBarView(selectedTab: .constant(.house))
}
