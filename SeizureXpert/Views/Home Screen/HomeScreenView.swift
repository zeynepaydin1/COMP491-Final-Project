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
                            Text(user.isDoctor ? "Neurologist | EEG Specialist" : "Patient") // Dynamic title based on user role
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

                Button(action: {
                                    handleLogout() // Call the logout function
                                }) {
                                    Text("Logout")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Colors.primary)
                                        .cornerRadius(10)
                                }
                                .padding()


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
                                    },
                                    onVisualizeTapped: {
                                        viewModel.selectedPatient = patient
                                        viewModel.navigateTo(.visualization)
                                    }
                                )
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                // Page Slider
                Picker("", selection: $selectedTab) {
                    Text("Home").tag(0)
                    Text("My Patients").tag(1)
                    Text("All Patients").tag(2)
                    Text("Profile").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedTab) { newValue in
                    switch newValue {
                    case 1:
                        viewModel.navigateTo(.myPatients)
                    case 2:
                        viewModel.navigateTo(.allPatients)
                    case 3:
                        viewModel.navigateTo(.profile)
                    default:
                        break
                    }
                }

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

                NavigationLink(
                    destination: {
                        if let patient = viewModel.selectedPatient {
                            AnyView(VisualizationView(patient: patient))
                        } else {
                            AnyView(EmptyView())
                        }
                    }(),
                    tag: HomeScreenViewModel.Destination.visualization,
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
        let mockLoginViewModel = LoginViewModel()
        mockLoginViewModel.currentUser = User(
            username: "dr.jane.doe",
            email: "jane.doe@example.com",
            name: "Jane Doe",
            isDoctor: true
        )
        mockLoginViewModel.loginSuccessful = true

        let mockViewModel = HomeScreenViewModel()
        mockViewModel.completedAnalyses = [
            SamplePatient(
                id: UUID().uuidString,
                name: "Jane",
                surname: "Smith",
                age: "23",
                gender: "Female",
                profileImageURL: "https://via.placeholder.com/150" // Example image URL
            ),
            SamplePatient(
                id: UUID().uuidString,
                name: "John",
                surname: "Doe",
                age: "23",
                gender: "Male",
                profileImageURL: "https://via.placeholder.com/150" // Example image URL
            )
        ]

        return HomeScreenView()
            .environmentObject(mockLoginViewModel)
    }
}



