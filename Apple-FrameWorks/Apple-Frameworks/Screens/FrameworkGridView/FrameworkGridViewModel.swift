//
//  FrameworkGridViewModel.swift
//  Apple-Frameworks
//
//   Created by Emre KARDAS on 11/4/24.
//

import SwiftUI

final class FrameworkGridViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
}
