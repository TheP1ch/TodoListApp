//
//  ToolbarContent.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 01.07.2024.
//

import SwiftUI

struct HeadBarContent: ToolbarContent {
    @Binding var isSaveDisabled: Bool
    
    var saveAction: () -> Void
    var cancelAction: () -> Void
    
    
    

}

