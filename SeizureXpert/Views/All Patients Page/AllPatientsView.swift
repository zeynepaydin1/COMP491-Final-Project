import SwiftUI

struct AllPatientsView: View {
    @StateObject private var viewModel = AllPatientsViewModel()

    var body: some View {
        VStack {
            Text("All Patients")
                .font(Fonts.title)
                .foregroundColor(Colors.textPrimary)
                .padding()

            if viewModel.allPatients.isEmpty {
                Text("No patients available. Please add new patients.")
                    .font(Fonts.body)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.allPatients) { patient in
                    HStack {
                        if let imageURL = URL(string: patient.profileImageURL) {
                            AsyncImage(url: imageURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .foregroundColor(.red)
                                } else {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading) {
                            Text(patient.name)
                                .font(Fonts.body)
                                .foregroundColor(Colors.textPrimary)
                            Text(patient.surname)
                                .font(Fonts.caption)
                                .foregroundColor(Colors.textSecondary)
                        }
                    }
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2, x: 0, y: 2)
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            viewModel.fetchAllPatients()
        }
        .background(Colors.background.ignoresSafeArea())
    }
}


struct AllPatientsView_Previews: PreviewProvider {
    static var previews: some View {
        AllPatientsView()
    }
}
