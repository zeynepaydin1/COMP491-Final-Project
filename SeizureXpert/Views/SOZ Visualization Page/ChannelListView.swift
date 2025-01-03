import SwiftUI

struct ChannelListView: View {
    @StateObject var viewModel: ChannelListViewModel

    // This state drives navigation to TSVInfoView
    @State private var showTSVView = false

    var body: some View {
        ZStack {
            // Background Color
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Patient: \(viewModel.patient.name) \(viewModel.patient.surname)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("EEG File: \(viewModel.file.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                )
                .padding(.horizontal)

                // Error or Loading States
                if let error = viewModel.executionError {
                    VStack {
                        Text("Error")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Text(error)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else if viewModel.isLoading {
                    VStack {
                        ProgressView("Loading Channels...")
                            .padding()
                        Text("Please wait while we retrieve and parse the channel file.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                } else if viewModel.channelNames.isEmpty {
                    Text("No channels found.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    // Main content after channels are loaded
                    VStack {
                        // Select/Deselect All Buttons
                        HStack(spacing: 16) {
                            Button(action: {
                                viewModel.selectAllChannels()
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                    Text("Select All")
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                                .shadow(color: Color.blue.opacity(0.3), radius: 3, x: 0, y: 2)
                            }

                            Button(action: {
                                viewModel.deselectAllChannels()
                            }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                    Text("Deselect All")
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(.red)
                                .cornerRadius(12)
                                .shadow(color: Color.red.opacity(0.3), radius: 3, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal)

                        // Channel List with Multi-Select
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.channelNames, id: \.self) { channel in
                                    HStack {
                                        Image(systemName: viewModel.selectedChannels.contains(channel) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(viewModel.selectedChannels.contains(channel) ? .blue : .gray)
                                            .font(.title3)

                                        Text(channel)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                            .truncationMode(.tail)

                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.secondarySystemBackground))
                                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                    )
                                    .onTapGesture {
                                        viewModel.toggleSelection(for: channel)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Predict Button
                        Button(action: {
                            viewModel.predict()
                        }) {
                            HStack {
                                if viewModel.isPredicting {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                } else {
                                    Image(systemName: "play.circle.fill")
                                        .font(.title3)
                                    Text("Predict")
                                        .font(.headline)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.selectedChannels.isEmpty ? Color.gray.opacity(0.2) : Color.green.opacity(0.2))
                            .foregroundColor(viewModel.selectedChannels.isEmpty ? .gray : .green)
                            .cornerRadius(12)
                            .shadow(color: viewModel.selectedChannels.isEmpty ? Color.clear : Color.green.opacity(0.3), radius: 3, x: 0, y: 2)
                        }
                        .disabled(viewModel.selectedChannels.isEmpty || viewModel.isPredicting)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("Channels")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchChannels()
        }
        // 1) Observe changes to `predictionResult`
        .onChange(of: viewModel.predictionResult) { newValue in
            // If a new prediction result arrives, trigger navigation
            if newValue != nil {
                showTSVView = true
            }
        }
        // 2) NavigationLink that becomes active when showTSVView = true
        NavigationLink(
            destination: TSVInfoView(viewModel: viewModel),
            isActive: $showTSVView
        ) {
            EmptyView()
        }
    }
}
