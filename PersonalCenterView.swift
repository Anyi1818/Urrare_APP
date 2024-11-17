import SwiftUI

struct PersonalCenterView: View {
    @State private var therapistEmail: String = ""
    @State private var showToast = false

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.pink)
                    .padding(.top, -20)

                Text("Connect with Your Therapy Report")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 20)

 
            VStack(alignment: .leading, spacing: 10) {
                Text("Secure Connection:")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.leading, 8)

                Text("• Submit your therapist’s email address, your therapist will get an email requesting your consulting report.")
                    .padding(.leading, 8)
                Text("• Once both you and your therapist authorize, your therapist can upload your report to Urrare.")
                    .padding(.leading, 8)
                Text("• All information is securely encrypted and inaccessible to any third party.")
                    .padding(.leading, 8)

                
                Text("Smart Insights:")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.top, 15)
                    .padding(.leading, 8)

                Text("Urrare analyzes your report and creates personalized affirmations tailored just for you.")
                    .padding(.leading, 8)
            }
            .padding(.horizontal, 16)
            .font(.subheadline)

            
            Spacer().frame(height: 40)

            
            VStack(spacing: 10) {
                Text("I’m always here with you.")
                    .font(.subheadline)

                TextField("Enter therapist’s email", text: $therapistEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        showToast = false
                    }
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }

            
            if showToast {
                Text("This is a test feature and cannot submit at this time.")
                    .font(.footnote)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 10)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showToast)
            }
        }
        .padding(.top, -20) 
    }
}

struct PersonalCenterView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalCenterView()
    }
}
