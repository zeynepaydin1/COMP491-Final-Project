import Foundation
import SwiftUI

class UploadEEGDataViewModel: ObservableObject {
    @Published var selectedFileURL: URL? = nil
    @Published var selectedFileName: String = ""
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0
    @Published var successMessage: String? = nil
    @Published var errorMessage: String? = nil
    @Published var showDocumentPicker: Bool = false

    func uploadEEGFile(for patient: SamplePatient) {
        guard let fileURL = selectedFileURL else {
            errorMessage = "No file selected."
            return
        }

        resetMessages()
        isUploading = true
        let destinationPath = "\(patient.username)/\(fileURL.lastPathComponent)"

        uploadFile(to: destinationPath, fileURL: fileURL) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success:
                    self?.successMessage = "File uploaded successfully!"
                case .failure(let error):
                    self?.errorMessage = "Upload failed: \(error.localizedDescription)"
                }
            }
        }
    }

    private func uploadFile(to path: String, fileURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let serverURL = URL(string: ServerConfig.baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.addValue(path, forHTTPHeaderField: "X-File-Name")

        URLSession.shared.uploadTask(with: request, fromFile: fileURL) { [weak self] _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let uploadError = NSError(
                    domain: "UploadError",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to upload file."]
                )
                completion(.failure(uploadError))
                return
            }

            self?.simulateUploadProgress() // Simulate progress update
            completion(.success(()))
        }.resume()
    }

    private func simulateUploadProgress() {
        DispatchQueue.global().async { [weak self] in
            for i in 0...100 {
                usleep(50000) // Simulate a delay
                DispatchQueue.main.async {
                    self?.uploadProgress = Double(i) / 100.0
                }
            }
        }
    }

    private func resetMessages() {
        successMessage = nil
        errorMessage = nil
    }
}
