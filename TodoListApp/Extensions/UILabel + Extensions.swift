//
//  UILabel + Extensions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//
//  From site: https://www.gangofcoders.net/solution/how-can-i-create-a-uilabel-with-strikethrough-text/

import UIKit

extension UILabel {

func strikeThrough(_ isStrikeThrough:Bool) {
    if isStrikeThrough {
        if let lblText = self.text {
            let attributeString =  NSMutableAttributedString(string: lblText)
            
            attributeString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.thick.rawValue,
                range: NSMakeRange(0,attributeString.length)
            )
            attributeString.addAttribute(
                .foregroundColor,
                value: ColorTheme.Label.labelTertiary.uiColor,
                range: NSMakeRange(0,attributeString.length)
            )
            
            self.attributedText = attributeString
        }
    } else {
        if let attributedStringText = self.attributedText {
            let txt = attributedStringText.string
            self.attributedText = nil
            self.text = txt
            return
        }
    }
    }
}
