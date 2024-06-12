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
        HStack{
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Group {
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .foregroundStyle(Color("BGCFlipped"))
                        .scaleEffect(selectedTab == tab ? 1.35 : 0.9)
                        .font(.system(size: 25, weight: .black))
                        .frame(width: 100, height: 40)
                        .background(.clear)
                }
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.1)) {
                        selectedTab = tab
                    }
                }

            }
        }
        .frame(width: UIScreen.main.bounds.width - 50, height: 80)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

#Preview {
    NavBarView(selectedTab: .constant(.house))
}
