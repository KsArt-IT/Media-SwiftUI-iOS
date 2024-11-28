//
//  AlertModifier.swift
//  Media-SUI
//
//  Created by KsArT on 28.11.2024.
//

import SwiftUI

// Модификатор для отображения Alert
struct AlertRenameModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var name: String
    var action: () -> Void
    
    @State private var showContent: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            hideAlert()
                        }
                    }
                if showContent {
                    VStack(spacing: 0) {
                        Text("Edit Name")
                            .font(.headline)
                            .padding(.top)
                        
                        TextField("Enter new name", text: $name)
                            .minimumScaleFactor(0.3)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Divider()
                        
                        HStack(alignment: .center) {
                            Button("Cancel") {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.red)
                            
                            Divider()
                                .frame(idealHeight: 30, maxHeight: 50)

                            Button("OK") {
                                withAnimation {
                                    hideAlert()
                                }
                                action()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                    .padding(.horizontal)
                    .transition(.scale)
                    .animation(.spring(), value: isPresented)
                }
            }
        }
        .onChange(of: isPresented) {
            if isPresented {
                withAnimation {
                    showContent = true
                }
            }
        }
    }
    
    private func hideAlert() {
        showContent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
        }
    }
}

// Расширение для удобного использования модификатора
extension View {
    func alertRename(
        isPresented: Binding<Bool>,
        name: Binding<String>,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(
            AlertRenameModifier(
                isPresented: isPresented,
                name: name,
                action: action
            )
        )
    }
}
