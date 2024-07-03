//
//  HueSlider.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 03.07.2024.
//

import SwiftUI

struct HueSlider: View {
    //MARK: Public Properties
    
    let width: CGFloat
    let height: CGFloat
    
    @Binding var hue: Double
    
    //MARK: Body
    
    var body: some View {
        ZStack{
            VStack {
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .gradientPalette, startPoint: .trailing, endPoint: .leading)
                    )
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture { location in
                            self.hue = location.x / width
                        }
                        .gesture(
                            DragGesture(coordinateSpace: .local)
                                .onChanged({ value in
                                    let gestureLocation = value.location
                    
                                    if gestureLocation.x > 0 && gestureLocation.x < width{
                                        self.hue = gestureLocation.x / width
                                    }
                                    
                                    if gestureLocation.x <= 0 {
                                        self.hue = 0
                                    }
                                    
                                    if gestureLocation.x >= width {
                                        self.hue = 1
                                    }
                    
                                })
                        )
                
            }
        }
    }
    //MARK: View Properties
}

#Preview {
    HueSlider(width: 300, height: 60, hue: .constant(0.0))
}
