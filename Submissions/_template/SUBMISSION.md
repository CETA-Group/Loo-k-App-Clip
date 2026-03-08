## Team Name: CETA-Group
## Clip Name: Loo-k
## Invocation URL Pattern: look://location/:locationId

---

## What Great Looks Like

Your submission is strong when it is:
- **Specific**: one clear fan moment, one clear problem, one clear outcome
- **Clip-shaped**: value in under 30 seconds, no heavy onboarding
- **Business-aware**: connects to revenue (venue, online, or both)
- **Testable**: prototype actually runs in the simulator with your URL pattern

---

### 1. Problem Framing

Which user moment or touchpoint are you targeting?

- [x] Discovery / first awareness
- [x] Intent / consideration
- [ ] Purchase / conversion
- [x] In-person / on-site interaction
- [ ] Post-purchase / re-engagement
- [ ] Other: ___

What friction or missed opportunity are you solving for? (3-5 sentences)

People often discover places to live through listings, signs, shared links, or location-based recommendations, but the information they get is incomplete. Most housing discovery tools focus on rent and photos while ignoring the practical question of what it actually feels like to live there day to day. This creates friction in the earliest stage of decision-making, where users want a fast and trustworthy first impression without downloading a full app or creating an account. Our Clip solves this by giving users an instant, lightweight way to evaluate a location’s livability and real-world suitability in the exact moment they become curious.

---

### 2. Proposed Solution

**How is the Clip invoked?** (check all that apply)
- [x] QR Code (printed on physical surface)
- [ ] NFC Tag (embedded in object — wristband, poster, etc.)
- [x] iMessage / SMS Link
- [ ] Safari Smart App Banner
- [x] Apple Maps (location-based)
- [ ] Siri Suggestion
- [x] Other: rental listing / shared housing link

**End-to-end user experience** (step by step):
1. A user encounters a property or location through a listing, QR code, shared link, or map-based discovery point and opens the Loo-k App Clip instantly.
2. The Clip loads a focused location snapshot that helps the user quickly judge whether the place is worth considering based on livability and real-cost thinking, rather than rent alone.
3. The user leaves with a clear takeaway in under 30 seconds: continue exploring this place more seriously, or move on.

**How does the 8-hour notification window factor into your strategy?**

The 8-hour notification window gives this experience a valuable second chance without requiring a full app install. After the initial interaction, a follow-up notification could remind the user to revisit a saved location, compare it with another property they viewed, or continue evaluating options later the same day when housing decisions are still fresh in mind. This keeps the Clip lightweight while still supporting short-term re-engagement during a high-intent decision window.

---

### 3. Platform Extensions (if applicable)

Our current prototype does not require major new Reactiv Clips platform capabilities in order to demonstrate the core experience. The Clip already fits well within a URL-invoked, no-install flow. In a more advanced production version, optional support for richer location context, deeper listing metadata, or lightweight saved-comparison states across short sessions could strengthen the experience, but these are enhancements rather than hard requirements for the concept to work.

---

### 4. Prototype Description

Our working prototype demonstrates a focused App Clip experience for instant housing-location evaluation. It is invokable through the defined URL pattern in the Invocation Console and presents a clear, lightweight decision moment centered on whether a location feels promising enough to explore further. The implemented flow includes a working ClipExperience, a location-based entry point, and a complete short interaction with a clear end state. The prototype is intentionally narrow in scope so that its value is easy to understand within the time constraints of an App Clip experience.

Minimum expectation:
- A working `ClipExperience`
- Invokable via your URL pattern in Invocation Console
- At least one complete user flow with a clear end state

---

### 5. Impact Hypothesis

This creates business impact primarily at the top of the housing discovery funnel, where users make fast judgments about whether a listing or location is worth deeper attention. The main channel is online-to-location discovery, with strong potential spillover into in-person contexts such as rental signage, posters, or QR-linked property promotion. We believe this intervention can improve engagement with housing leads by reducing the friction between seeing a place and evaluating it meaningfully. Instead of losing users to slow, generic listing pages or forcing them into a full app too early, the Clip provides an immediate and memorable first-touch experience, which can increase downstream conversion into deeper browsing, contact, or follow-up exploration.

---

### Demo Video

Link: ___

### Screenshot(s)
- ___
- ___
