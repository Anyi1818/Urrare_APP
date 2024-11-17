import SwiftUI

struct ProfileView: View {
    @State private var therapistEmail = ""

    var body: some View {
        VStack {
            Text("Therapist Email")
                .font(.headline)
                .padding(.top)

            TextField("Enter therapist email", text: $therapistEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Submit") {
                // Will implement in the future
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

