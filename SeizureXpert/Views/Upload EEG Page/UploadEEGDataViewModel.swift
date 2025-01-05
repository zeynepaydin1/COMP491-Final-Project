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

        uploadFile(patientUsername: patient.username, fileURL: fileURL) { [weak self] result in
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

    private func uploadFile(patientUsername: String, fileURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let serverURL = URL(string: ServerConfig.baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.addValue(fileURL.lastPathComponent, forHTTPHeaderField: "X-File-Name") // File name header
        request.addValue(patientUsername, forHTTPHeaderField: "X-Patient-Username")    // Username header

        // Upload task
        URLSession.shared.uploadTask(with: request, fromFile: fileURL) { data, response, error in
            if let error = error {
                completion(.failure(error)) // Handle error
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid Response", code: -1, userInfo: nil)))
                return
            }

            if httpResponse.statusCode == 200 {
                // Optionally parse the response
                if let data = data,
                   let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = jsonResponse["message"] as? String {
                    print("Server Response: \(message)")
                }
                completion(.success(()))
            } else {
                let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                completion(.failure(NSError(domain: "Upload Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
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
