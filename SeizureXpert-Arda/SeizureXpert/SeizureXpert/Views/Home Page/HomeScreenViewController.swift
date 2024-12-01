//
//  HomeScreenViewController.swift
//  SeizureXpert
//
//  Created by B50 on 30.11.2024.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    private let homeScreenView = HomeScreenView()
    private var proceedingAnalyses: [Patient] = []
    private var completedAnalyses: [Patient] = []
    private let sectionTitles = ["Completed Analyses", "Proceeding Analyses"]

    // MARK: - Lifecycle
    override func loadView() {
        view = homeScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupDelegates()
        setupActions()
        homeScreenView.analysisTableView.rowHeight = 90
    }

    // MARK: - Data Fetching
    private func fetchData() {
        let allPatients = PatientData.getPatients()
        proceedingAnalyses = allPatients.filter { $0.progress < 1.0 }
        completedAnalyses = allPatients.filter { $0.progress == 1.0 }
    }

    // MARK: - Setup Methods
    private func setupDelegates() {
        homeScreenView.analysisTableView.dataSource = self
        homeScreenView.analysisTableView.delegate = self
    }

    private func setupActions() {
        // Handle Profile Picture Tap
        homeScreenView.doctorProfileImageView.isUserInteractionEnabled = true
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        homeScreenView.doctorProfileImageView.addGestureRecognizer(profileTapGesture)

        // Handle Notification Button Tap
        homeScreenView.notificationButton.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)

        // Handle Settings Button Tap
        homeScreenView.settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)

        // Handle Page Slider
        homeScreenView.pageSlider.addTarget(self, action: #selector(pageSliderChanged), for: .valueChanged)
    }

    // MARK: - Actions
    @objc private func profileTapped() {
        print("Profile tapped")
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc private func notificationTapped() {
        print("Notification button tapped")
        let notificationsVC = NotificationsViewController()
        navigationController?.pushViewController(notificationsVC, animated: true)
    }

    @objc private func settingsTapped() {
        print("Settings button tapped")
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    @objc private func pageSliderChanged() {
        let selectedIndex = homeScreenView.pageSlider.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            print("Home button tapped")
        case 1:
            print("My Patients button tapped")
        case 2:
            print("All Patients button tapped")
        case 3:
            print("Profile button tapped")
        default:
            print("Unknown button tapped")
        }
    }

    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? completedAnalyses.count : proceedingAnalyses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as! AnalysisCell
        let patient = indexPath.section == 0 ? completedAnalyses[indexPath.row] : proceedingAnalyses[indexPath.row]
        cell.configure(with: patient.name, profileImage: patient.profileImage, progress: patient.progress)

        // Info Button Action
        cell.onInfoButtonTapped = {
            let patientDetailsVC = PatientDetailsViewController()
            patientDetailsVC.patient = patient
            self.navigationController?.pushViewController(patientDetailsVC, animated: true)
        }

        // Visualize Button Action
        cell.onVisualizeButtonTapped = {
            let sozVisualizationVC = SOZVisualizationViewController()
            sozVisualizationVC.patient = patient
            self.navigationController?.pushViewController(sozVisualizationVC, animated: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}
