import SwiftUI

struct UserProfile {
    var salaryRange: SalaryRange = .student
    var workMode: WorkMode = .hybrid
    var transportMode: TransportMode = .transit
    var groceryStyle: GroceryStyle = .balanced
    var diningOut: DiningOutFrequency = .sometimes
}

enum SalaryRange: String, CaseIterable, Identifiable {
    case student = "Student / Under $2k"
    case low = "$2k – $4k"
    case medium = "$4k – $7k"
    case high = "$7k – $10k"
    case premium = "$10k+"

    var id: String { rawValue }
}

enum WorkMode: String, CaseIterable, Identifiable {
    case remote = "Remote"
    case hybrid = "Hybrid"
    case onsite = "On-site"
    case student = "Student"

    var id: String { rawValue }
}

enum TransportMode: String, CaseIterable, Identifiable {
    case walk = "Walk / Bike"
    case transit = "Transit"
    case drive = "Drive"
    case mixed = "Mixed"

    var id: String { rawValue }
}

enum GroceryStyle: String, CaseIterable, Identifiable {
    case budget = "Budget"
    case balanced = "Balanced"
    case premium = "Premium"

    var id: String { rawValue }
}

enum DiningOutFrequency: String, CaseIterable, Identifiable {
    case rarely = "Rarely"
    case sometimes = "Sometimes"
    case often = "Often"

    var id: String { rawValue }
}

struct UserProfileStepView: View {
    @Binding var profile: UserProfile
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 7/255, green: 19/255, blue: 48/255),
                    Color(red: 15/255, green: 34/255, blue: 84/255),
                    Color(red: 34/255, green: 20/255, blue: 74/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    headerCard
                    formCard
                    continueButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 18)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
    }
}

private extension UserProfileStepView {
    var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("QUICK PROFILE")
                .font(.caption)
                .fontWeight(.bold)
                .tracking(1.6)
                .foregroundStyle(Color.white.opacity(0.7))

            Text("Tell us a bit about your lifestyle")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("We’ll use this to personalize your estimated monthly cost before showing the final result.")
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.72))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(cardBackground)
    }

    var formCard: some View {
        VStack(spacing: 16) {
            profileRow(
                title: "Income / Budget",
                systemImage: "dollarsign.circle",
                selection: $profile.salaryRange
            )

            profileRow(
                title: "Work / School Mode",
                systemImage: "briefcase",
                selection: $profile.workMode
            )

            profileRow(
                title: "Transportation",
                systemImage: "tram",
                selection: $profile.transportMode
            )

            profileRow(
                title: "Grocery Style",
                systemImage: "cart",
                selection: $profile.groceryStyle
            )

            profileRow(
                title: "Dining Out",
                systemImage: "fork.knife",
                selection: $profile.diningOut
            )
        }
        .padding(18)
        .background(cardBackground)
    }

    var continueButton: some View {
        Button(action: onContinue) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.right.circle.fill")
                Text("Continue to Address Search")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 55/255, green: 120/255, blue: 1.0),
                        Color(red: 106/255, green: 92/255, blue: 1.0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
            )
            .shadow(color: Color.blue.opacity(0.28), radius: 18, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color(red: 12/255, green: 24/255, blue: 58/255).opacity(0.72))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }

    func profileRow<T: CaseIterable & Identifiable & RawRepresentable>(
        title: String,
        systemImage: String,
        selection: Binding<T>
    ) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(Color(red: 120/255, green: 170/255, blue: 1.0))
            }

            Menu {
                ForEach(Array(T.allCases), id: \.id) { option in
                    Button(option.rawValue) {
                        selection.wrappedValue = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.wrappedValue.rawValue)
                        .foregroundStyle(.white.opacity(0.92))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}
