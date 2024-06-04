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
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack{
            Divider()
                .frame(minHeight: 3)
                .overlay(RoundedRectangle(cornerRadius: 25)
                    .fill(.primary))
                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(selectedTab == tab ? 1.35 : 1.0)
//                        .foregroundColor(selectedTab == tab ? .teal : .white)
                        .font(.system(size: 20, weight: .black))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 80)
            .background(.background)
        }
    }
}

#Preview {
    NavBarView(selectedTab: .constant(.house))
}
