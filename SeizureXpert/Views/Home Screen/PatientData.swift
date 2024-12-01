class PatientData {
    static func getPatients() -> [SamplePatient] {
        return [
            SamplePatient(name: "John Doe", gender: "male", progress: 0.5),
            SamplePatient(name: "Jane Smith", gender: "female", progress: 1.0),
            SamplePatient(name: "Alex Johnson", gender: "other", progress: 0.75)
        ]
    }
}
