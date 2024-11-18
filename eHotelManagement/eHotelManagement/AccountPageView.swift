//
//  AccountPageView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct AccountPageView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Logo()
                    .frame(height: 100)
                    .padding(.top, 40)
                
                VStack(spacing: 25) {
                    Text("Account Information")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    CustomTextField(icon: "person.fill", placeholder: "Name", text: $name)
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    CustomTextField(icon: "phone.fill", placeholder: "Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    CustomSecureField(icon: "lock.fill", placeholder: "Password", text: $password)
                    
                    // Sign Up Button
                    Button(action: {
                        // Sign Up action here
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    // Divider or "OR" Label
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        Text("OR")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    
                    // Google Sign-In Button
                    Button(action: {
                        // Google Sign-In action here
                    }) {
                        HStack {
                            Image(systemName: "globe") // Placeholder for Google logo
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign in with Google")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 40)
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct CustomSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 40)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct AccountPageView_Previews: PreviewProvider {
    static var previews: some View {
        AccountPageView()
    }
}
