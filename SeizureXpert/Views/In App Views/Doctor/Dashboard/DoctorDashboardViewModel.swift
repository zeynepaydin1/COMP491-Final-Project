//
//  LecturerDashboardViewModel.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/24/24.
//
import Foundation
import FirebaseFirestore
class LecturerDashboardViewModel: ObservableObject {
    @Published var videos: [Video] = []
    func fetchVideosForLecturer(lecturerID: String) {
        Firestore.firestore().collection("videos")
            .whereField("userID", isEqualTo: lecturerID).getDocuments { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self?.videos = querySnapshot?.documents.compactMap { document -> Video? in
                    let data = document.data()
                    return Video(
                        userID: data["lecturerID"] as? String ?? "",
                        imageName: data["imageName"] as? String ?? "defaultImage",
                        title: data["lectureName"] as? String ?? "Unknown Lecture",
                        description: data["videoDescription"] as? String ?? "No description provided.",
                        viewCount: data["viewCount"] as? Int ?? 0,
                        uploadDate: self?.formatDate(timestamp: data["uploadDate"] as? Timestamp) ?? "not indicated",
                        url: URL(string: data["videoURL"] as? String ?? "") ?? URL(fileURLWithPath: ""),
                        lectureName: data["lectureName"] as? String ?? "Unknown Lecture",
                        videoName: data["videoName"] as? String ?? "Unknown Video",
                        videoDescription: data["videoDescription"] as? String ?? "No description provided."
                    )
                } ?? []
            }
        }
    }
    private func formatDate(timestamp: Timestamp?) -> String {
            guard let timestamp = timestamp else { return "" }
            let date = timestamp.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        }
}
