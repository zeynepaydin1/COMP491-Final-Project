import SwiftUI

struct HomeScreenView: View {
    @StateObject private var viewModel = HomeScreenViewModel()
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
                        Text("Dr. Sarah Lee")
                            .font(Fonts.primary(size: 20, weight: .bold))
                            .foregroundColor(Colors.textPrimary)
                        Text("Neurologist | EEG Specialist")
                            .font(Fonts.body)
                            .foregroundColor(Colors.textSecondary)
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

                // Analysis Table
                List {
                    Section(header: Text("Completed Analyses")) {
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
                    Section(header: Text("Proceeding Analyses")) {
                        ForEach(viewModel.proceedingAnalyses) { patient in
                            AnalysisCellView(
                                patient: patient,
                                onInfoTapped: {
                                    print("Info tapped for \(patient.name)")
                                },
                                onVisualizeTapped: nil
                            )
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
}
