import SwiftUI

struct MyClipExperience: ClipExperience {
    static let urlPattern = "look.app/address/:location"
    static let clipName = "Loo-K Cost Check"
    static let clipDescription = "Enter an address and get the true monthly cost in seconds."
    static let teamName = "Your Team Name"
    
    static let touchpoint: JourneyTouchpoint = .utility
    static let invocationSource: InvocationSource = .qrCode
    
    let context: ClipContext
    
    @State private var addressInput: String = ""
    @State private var selectedLocation: LocationResult? = nil
    @State private var showError = false
    @State private var profile = UserProfile()
    @State private var currentStep: FlowStep = .profile
    
    enum FlowStep {
        case profile
        case search
    }
    
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
            
            if currentStep == .profile {
                UserProfileStepView(profile: $profile) {
                    currentStep = .search
                }
            } else {
                ScrollView {
                    VStack(spacing: 18) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("COST ANALYSIS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(1.6)
                                .foregroundStyle(Color.white.opacity(0.7))
                            
                            Text("What does it really cost to live here?")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text("Enter an address to estimate rent, commute, groceries, utilities, and lifestyle.")
                                .font(.subheadline)
                                .foregroundStyle(Color.white.opacity(0.72))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color(red: 12/255, green: 24/255, blue: 58/255).opacity(0.72))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                        )
                        
                        searchCard
                        
                        if let location = selectedLocation {
                            selectedAddressCard(location: location)
                            summaryCard(location: location)
                            breakdownSection(location: location)
                            footnote
                        } else {
                            idleCard
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 18)
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}
// MARK: - UI
private extension MyClipExperience {
    var searchCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search any address in Waterloo-Kitchener…", text: $addressInput)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            Button {
                runAnalysis()
            } label: {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Calculate Cost")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.blue)

            if showError {
                Text("Enter a Waterloo or Kitchener address to continue.")
                    .font(.footnote)
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    var idleCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 30))
                .foregroundStyle(.secondary)

            Text("No address selected yet")
                .font(.headline)

            Text("Search above to see the full cost breakdown for a sample Waterloo-Kitchener location.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    func selectedAddressCard(location: LocationResult) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(.red)

            Text(location.address)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(2)

            Spacer()
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    func summaryCard(location: LocationResult) -> some View {
        VStack(spacing: 18) {
            scoreHexagon(metrics: location.metrics)

            VStack(spacing: 4) {
                Text("TRUE MONTHLY COST")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .tracking(1.5)
                    .foregroundStyle(.secondary)

                Text(location.totalCost.currencyString)
                    .font(.system(size: 40, weight: .bold, design: .rounded))

                Text("estimated / month")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    func breakdownSection(location: LocationResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💰 Cost Breakdown")
                .font(.headline)

            VStack(spacing: 10) {
                ForEach(location.breakdown) { item in
                    breakdownRow(item: item, maxValue: location.maxBreakdownValue)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    func breakdownRow(item: CostItem, maxValue: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(item.title, systemImage: item.icon)
                    .font(.subheadline)
                    .foregroundStyle(.primary)

                Spacer()

                Text(item.value.currencyString)
                    .font(.subheadline.weight(.semibold))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.08))

                    Capsule()
                        .fill(item.color.opacity(0.95))
                        .frame(width: max(10, geo.size.width * CGFloat(item.value / maxValue)))
                }
            }
            .frame(height: 8)
        }
        .padding(12)
        .background(Color.white.opacity(0.03), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    var footnote: some View {
        Text("Cost estimates are illustrative — real data pipeline coming soon.")
            .font(.caption)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
            .padding(.top, 4)
    }

    func scoreHexagon(metrics: ScoreMetrics) -> some View {
        VStack(spacing: 10) {
            ZStack {
                HexagonGrid()
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    .frame(width: 170, height: 170)

                MetricPolygon(values: [
                    metrics.rent,
                    metrics.commute,
                    metrics.groceries,
                    metrics.utilities,
                    metrics.entertainment,
                    metrics.transport
                ])
                .fill(Color.blue.opacity(0.22))

                MetricPolygon(values: [
                    metrics.rent,
                    metrics.commute,
                    metrics.groceries,
                    metrics.utilities,
                    metrics.entertainment,
                    metrics.transport
                ])
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: 170, height: 170)
            }
            .frame(width: 170, height: 170)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                scoreTag("Rent", value: metrics.rent)
                scoreTag("Commute", value: metrics.commute)
                scoreTag("Groceries", value: metrics.groceries)
                scoreTag("Utilities", value: metrics.utilities)
                scoreTag("Fun", value: metrics.entertainment)
                scoreTag("Transport", value: metrics.transport)
            }
        }
    }

    func scoreTag(_ title: String, value: Double) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.blue.opacity(0.85))
                .frame(width: 6, height: 6)

            Text(title)
                .font(.caption)

            Spacer()

            Text("\(Int(value * 100))")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.04), in: Capsule())
    }
}

// MARK: - Actions
private extension MyClipExperience {
    func runAnalysis() {
        let trimmed = addressInput.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            showError = true
            selectedLocation = nil
            return
        }

        showError = false

        if let exact = MockLocationDatabase.match(for: trimmed) {
            selectedLocation = exact
            return
        }

        selectedLocation = MockLocationDatabase.fallback(for: trimmed)
    }
}

// MARK: - Mock Data
private struct MockLocationDatabase {
    static let all: [LocationResult] = [
        LocationResult(
            address: "300 Hazel St, Waterloo, ON",
            totalCost: 3675,
            metrics: .init(
                rent: 0.72,
                commute: 0.66,
                groceries: 0.61,
                utilities: 0.42,
                entertainment: 0.35,
                transport: 0.58
            ),
            breakdown: [
                .init(title: "Rent", icon: "house.fill", value: 2100, color: .blue),
                .init(title: "Commute", icon: "tram.fill", value: 240, color: .orange),
                .init(title: "Groceries", icon: "cart.fill", value: 520, color: .green),
                .init(title: "Utilities", icon: "bolt.fill", value: 180, color: .purple),
                .init(title: "Entertainment", icon: "ticket.fill", value: 260, color: .pink),
                .init(title: "Transport", icon: "car.fill", value: 375, color: .mint)
            ]
        ),
        LocationResult(
            address: "200 University Ave W, Waterloo, ON",
            totalCost: 3290,
            metrics: .init(
                rent: 0.64,
                commute: 0.90,
                groceries: 0.74,
                utilities: 0.45,
                entertainment: 0.59,
                transport: 0.81
            ),
            breakdown: [
                .init(title: "Rent", icon: "house.fill", value: 1850, color: .blue),
                .init(title: "Commute", icon: "tram.fill", value: 95, color: .orange),
                .init(title: "Groceries", icon: "cart.fill", value: 510, color: .green),
                .init(title: "Utilities", icon: "bolt.fill", value: 175, color: .purple),
                .init(title: "Entertainment", icon: "ticket.fill", value: 310, color: .pink),
                .init(title: "Transport", icon: "car.fill", value: 350, color: .mint)
            ]
        ),
        LocationResult(
            address: "King St W, Kitchener, ON",
            totalCost: 3415,
            metrics: .init(
                rent: 0.67,
                commute: 0.78,
                groceries: 0.63,
                utilities: 0.44,
                entertainment: 0.56,
                transport: 0.69
            ),
            breakdown: [
                .init(title: "Rent", icon: "house.fill", value: 1920, color: .blue),
                .init(title: "Commute", icon: "tram.fill", value: 150, color: .orange),
                .init(title: "Groceries", icon: "cart.fill", value: 500, color: .green),
                .init(title: "Utilities", icon: "bolt.fill", value: 185, color: .purple),
                .init(title: "Entertainment", icon: "ticket.fill", value: 300, color: .pink),
                .init(title: "Transport", icon: "car.fill", value: 360, color: .mint)
            ]
        )
    ]

    static func match(for query: String) -> LocationResult? {
        let q = query.lowercased()
        return all.first { $0.address.lowercased().contains(q) || q.contains($0.address.lowercased()) }
    }

    static func fallback(for query: String) -> LocationResult {
        if query.lowercased().contains("kitchener") {
            return all[2]
        }
        return all[0]
    }
}

// MARK: - Models
private struct LocationResult {
    let address: String
    let totalCost: Double
    let metrics: ScoreMetrics
    let breakdown: [CostItem]

    var maxBreakdownValue: Double {
        breakdown.map(\.value).max() ?? 1
    }
}

private struct ScoreMetrics {
    let rent: Double
    let commute: Double
    let groceries: Double
    let utilities: Double
    let entertainment: Double
    let transport: Double
}

private struct CostItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let value: Double
    let color: Color
}

// MARK: - Shapes
private struct HexagonGrid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        for scale in stride(from: 1.0, through: 0.25, by: -0.25) {
            path.addPath(hexagon(in: rect.insetBy(dx: rect.width * (1 - scale) / 2,
                                                  dy: rect.height * (1 - scale) / 2)))
        }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = hexagonPoints(in: rect)

        for point in outer {
            path.move(to: center)
            path.addLine(to: point)
        }

        return path
    }

    private func hexagon(in rect: CGRect) -> Path {
        let points = hexagonPoints(in: rect)
        var path = Path()

        guard let first = points.first else { return path }
        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }

    private func hexagonPoints(in rect: CGRect) -> [CGPoint] {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        return (0..<6).map { index in
            let angle = Angle.degrees(Double(index) * 60 - 90).radians
            return CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
        }
    }
}

private struct MetricPolygon: Shape {
    let values: [Double]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        let points = values.enumerated().map { index, value in
            let angle = Angle.degrees(Double(index) * 60 - 90).radians
            let scaled = max(0.08, min(1.0, value))
            return CGPoint(
                x: center.x + cos(angle) * radius * scaled,
                y: center.y + sin(angle) * radius * scaled
            )
        }

        guard let first = points.first else { return path }
        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Helpers
private extension Double {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "$\(Int(self))"
    }
}
