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
    @State private var upscaled: Double = 1 // target = 1.35
    @State private var downscaled: Double = 1 // target = 0.9
    
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        HStack{
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Group {
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .foregroundStyle(Color("BGCFlipped"))
                        .scaleEffect(selectedTab == tab ? upscaled : downscaled)
                        .font(.system(size: 25, weight: .black))
                        .frame(width: 100, height: 40)
                        .background(.clear)
                        .onAppear {
                            withAnimation(.spring(duration: 0.2)) {
                                upscaled = 1.35
                                downscaled = 0.9
                            }
                        }
                        .onDisappear {
                            upscaled = 1
                            downscaled = 1
                        }
                }
                .onTapGesture {
                    selectedTab = tab
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
