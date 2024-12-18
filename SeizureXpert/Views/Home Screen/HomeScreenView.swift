import SwiftUI

struct HomeScreenView: View {
    @StateObject private var viewModel = HomeScreenViewModel()
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Doctor Profile Section
                HStack {
                    NavigationLink(
                        destination: ProfileView(),
                        tag: HomeScreenViewModel.Destination.profile,
                        selection: $viewModel.currentDestination
                    ) {
                        Image("doctor")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }

                    VStack(alignment: .leading) {
                        if let user = loginViewModel.currentUser {
                            Text("Dr. \(user.name)") // Display logged-in user's name
                                .font(Fonts.primary(size: 20, weight: .bold))
                                .foregroundColor(Colors.textPrimary)
                            Text(user.isDoctor ? "Neurologist | EEG Specialist" : "Patient")
                                .font(Fonts.body)
                                .foregroundColor(Colors.textSecondary)
                        } else {
                            Text("Loading...")
                                .font(Fonts.body)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()

                    Button(action: {
                        viewModel.navigateTo(.notifications)
                    }) {
                        Image(systemName: "bell")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Colors.primary)
                    }

                    Button(action: {
                        viewModel.navigateTo(.settings)
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Colors.primary)
                    }
                }
                .padding()

           /*     Button(action: {
                                    handleLogout()
                                }) {
                                    Text("Logout")
                                        .font(.headline)
                                        .foregroundColor(Colors.primary)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                                }
                                .padding()
            
            */

                // Analysis Table
                List {
                    Section(header: Text("Completed Analyses")) {
                        if viewModel.completedAnalyses.isEmpty {
                            Text("No completed analyses available.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.completedAnalyses) { patient in
                                AnalysisCellView(
                                    patient: patient,
                                    onInfoTapped: {
                                        print("Info tapped for \(patient.name)")
                                        viewModel.selectedPatient = patient
                                        viewModel.navigateTo(.patientDetail)
                                    },
                                    onVisualizeTapped: {
                                        print("Visualize tapped for \(patient.name)")
                                        viewModel.selectedPatient = patient
                                        viewModel.navigateTo(.visualization)
                                    }
                                )
                                .padding() // Add padding around each cell
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white)) // Rounded background
                                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2) // Add shadow for separation
                                .padding(.vertical, 5) // Space between rows
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())







                HStack(spacing: 16) { // Horizontal Stack with spacing
                    Button(action: {
                        viewModel.navigateTo(.myPatients)
                    }) {
                        Text("My Patients")
                            .font(.headline)
                            .foregroundColor(Colors.primary)
                            .padding()
                            .frame(maxWidth: UIScreen.main.bounds.width / 2.5)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                    }

                    Button(action: {
                        viewModel.navigateTo(.allPatients)
                    }) {
                        Text("All Patients")
                            .font(.headline)
                            .foregroundColor(Colors.primary)
                            .padding()
                            .frame(maxWidth: UIScreen.main.bounds.width / 2.5)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                
                
                // Navigation Links
                NavigationLink(
                    destination: NotificationsView(),
                    tag: HomeScreenViewModel.Destination.notifications,
                    selection: $viewModel.currentDestination
                ) { EmptyView() }

                NavigationLink(
                    destination: SettingsView(),
                    tag: HomeScreenViewModel.Destination.settings,
                    selection: $viewModel.currentDestination
                ) { EmptyView() }

                NavigationLink(
                    destination: MySamplePatientsView(),
                    tag: HomeScreenViewModel.Destination.myPatients,
                    selection: $viewModel.currentDestination
                ) { EmptyView() }

                NavigationLink(
                    destination: AllPatientsView(),
                    tag: HomeScreenViewModel.Destination.allPatients,
                    selection: $viewModel.currentDestination
                ) { EmptyView() }
              
                // Visualization Navigation Link
                NavigationLink(
                    destination: Group {
                        if let patient = viewModel.selectedPatient {
                            VisualizationView(patient: patient)
                        } else {
                            EmptyView()
                        }
                    },
                    tag: HomeScreenViewModel.Destination.visualization,
                    selection: $viewModel.currentDestination
                ) { EmptyView() }

                // Patient Detail Navigation Link
                NavigationLink(
                    destination: Group {
                        if let patient = viewModel.selectedPatient {
                            PatientDetailView(patient: patient)
                        } else {
                            EmptyView()
                        }
                    },
                    tag: HomeScreenViewModel.Destination.patientDetail,
                    selection: $viewModel.currentDestination
                ) { EmptyView() }

            }
            .background(Colors.background.ignoresSafeArea())
        }
    }

    private func handleLogout() {
            loginViewModel.logout { success in
                if success {
                    print("Logout successful.")
                } else {
                    print("Failed to logout.")
                }
            }
        }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LoginViewModel()
        viewModel.loginSuccessful = true // Simulate successful login
        viewModel.userType = .Doctor    // Set a user type
        viewModel.currentUser = User(username: "Dr. Smith", email: "drsmith@example.com", name: "John Smith", isDoctor: true) // Mock user data

        return HomeScreenView()
            .environmentObject(viewModel) // Inject the mocked LoginViewModel
            .previewDisplayName("Doctor Home Preview")
    }
}
