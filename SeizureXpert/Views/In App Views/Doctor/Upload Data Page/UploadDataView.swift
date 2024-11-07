//
//  UploadDataView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 21.01.2024.
//
import SwiftUI
import PhotosUI
struct UploadDataView: View {
    @StateObject var viewModel = UploadDataViewModel()
    @State var videoState = false
    var body: some View {
        ZStack(alignment: .center) {
            BackgroundDS(color1: .cyan, color2: .white)
            VStack {
                Heading1TextWhite(text: "Data Upload")
                    .padding(.horizontal, -160)
                    .padding(.vertical, 10)
                VStack {
                    List {
                        Section(header: CaptionText(text: "Video Name")) {
                            TextField("Data Name", text: $viewModel.DataName)
                            TextField("Video Name", text: $viewModel.videoName)
                        }
                        Section(header: CaptionText(text: "Video Description")) {
                            TextField("Video Description", text: $viewModel.videoDescription)
                        }
                    } .frame(maxHeight: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                    VStack(spacing: 30) {
                        HStack(spacing: 20) {
                            PhotosPicker(selection: $viewModel.selectedItem,
                                         matching: .any(of: [.videos, .not(.images)])) {
                                ButtonView(title: "Select Video", color: Color.blue)
                                    .listRowBackground(Color.clear)
                            }
                            if videoState {
                                Image(systemName: "checkmark.rectangle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.green)
                            }
                        }
                        HStack(spacing: 20) {
                            // swiftlint:disable multiple_closures_with_trailing_closure
                            Button(action: {
                                Task {
                                    do { try await videoState = viewModel.uploadVideo() } catch { print("error") }
                                }
                            }) {
                                ButtonView(title: "Upload!", color: Color.blue)
                                    .listRowBackground(Color.clear)
                            }
                            // swiftlint:enable multiple_closures_with_trailing_closure
                            if viewModel.isUploading {
                                ProgressView()
                            }
                        }
                    }
                }
                Spacer()
                Spacer()
            }
        }
    }
}
#Preview {
    UploadDataView(viewModel: UploadDataViewModel())
}
