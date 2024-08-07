//
//  ColorPicker.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 03.07.2024.
//

import SwiftUI

struct ColorPicker: View {
    // MARK: Public Properties

    @Binding var itemColor: Color

    @Binding var newColor: Color

    // MARK: Private Properties

    @State private var hue: Double = 0

    @State private var saturation: Double = 1

    @State private var brightness: Double = 1

    // MARK: Body

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    colorPeakerHeader
                    HueSlider(
                        width: proxy.size.width < 25 ? 0 : proxy.size.width - 25,
                        height: proxy.size.width / 6,
                        hue: $hue
                    )
                        .padding()
                    saturationSlider
                    brightnessSlider
                }
                .background(ColorTheme.Back.backSecondary.color)
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
            }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 24))
        .scrollContentBackground(.hidden)
        .background(ColorTheme.Back.backPrimary.color)
        .onChange(of: hue) { _, new in
            newColor = Color(hue: new, saturation: saturation, brightness: brightness)
        }
        .onChange(of: saturation) { _, new in
            newColor = Color(hue: hue, saturation: new, brightness: brightness)
        }
        .onChange(of: brightness) { _, new in
            newColor = Color(hue: hue, saturation: saturation, brightness: new)
        }
    }

    // MARK: View Properties

    private var colorPeakerHeader: some View {
        HStack {
            Circle()
                .fill(newColor)
                .frame(width: 40, height: 40)
            Text(newColor.toHex())
                .font(AppFont.title.font)
                .foregroundColor(ColorTheme.Label.labelTertiary.color)
            Spacer()
        }.padding()
    }

    private var saturationSlider: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Насыщенность:")
            Slider(value: $saturation, in: 0...1)
        }.padding()
    }

    private var brightnessSlider: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Яркость:")

            Slider(value: $brightness, in: 0...1)
        }.padding()
    }
}

#Preview {
    ColorPicker(itemColor: .constant(.red), newColor: .constant(.red))
}
