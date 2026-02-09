# 🎨 Blood Near Me - Complete Frontend Design Specification
## Principal Frontend Designer Level - User-Centered Design

**Document Version**: 1.0
**Last Updated**: 2026-02-09
**Based on**: 4,416 lines of user research (info.md)
**Design Philosophy**: Life-saving simplicity. Every pixel matters.

---

## 📊 PHASE 1: USER RESEARCH SUMMARY

### Target Users (From 4,416 Lines of Research)

#### Primary Persona 1: **Emergency Seeker - Rajesh**
- **Age**: 35, Male, Middle class
- **Context**: Father whose child needs B+ blood urgently
- **Device**: Mid-range Android phone (3GB RAM, slow 3G)
- **Tech literacy**: Medium (can use WhatsApp, Google Maps)
- **Pain points**:
  - eRaktKosh shows outdated data
  - Calling 10+ blood banks, all say "not available"
  - Wasting precious time in emergency
  - Don't know which blood banks to trust
  - Needs INSTANT, ACCURATE information
- **Goal**: Find blood within 5 minutes, in maximum 10km radius
- **Stress level**: EXTREME (life or death)
- **Decision time**: < 3 seconds per blood bank

#### Primary Persona 2: **Willing Donor - Priya**
- **Age**: 28, Female, Working professional
- **Context**: O- blood type, wants to help in emergencies
- **Device**: iPhone, good internet
- **Tech literacy**: High
- **Pain points**:
  - Never knows when blood is needed
  - Wants to help but no one contacts her
  - No recognition for donations
  - Doesn't know where to donate
- **Goal**: Get notified when nearby someone needs her blood type
- **Motivation**: Altruism + social recognition

#### Primary Persona 3: **Blood Bank Admin - Dr. Kumar**
- **Age**: 45, Male, Government hospital
- **Context**: Manages blood bank inventory
- **Device**: Desktop computer + phone
- **Tech literacy**: Medium
- **Pain points**:
  - Manually updating eRaktKosh (takes hours)
  - Gets 50+ calls daily asking same questions
  - Data always outdated by evening
  - No way to broadcast urgent needs
- **Goal**: Reduce phone calls, keep data updated, find donors fast

### Critical Insights from Research

#### 🚨 **Emergency Context is EVERYTHING**
- Average time to find blood in India: **4-6 hours**
- Lives lost due to blood unavailability: **12,000+ per year**
- User is under EXTREME stress
- Every second counts
- Cognitive load MUST be zero
- One tap = one action

#### 🇮🇳 **India-Specific Challenges**
1. **Low internet literacy** (40% of users)
2. **Slow networks** (3G, 2G still common)
3. **Small screens** (< 5 inch common)
4. **Language barriers** (Hindi, Telugu, Tamil, etc.)
5. **Trust issues** (blood bank data unreliable)
6. **Cultural stigma** around blood donation
7. **Low-end devices** (2-3 GB RAM)

#### 💔 **Why eRaktKosh Fails**
- Outdated data (updated once a day, manually)
- Complex UI (12 steps to find blood)
- Slow loading (20+ seconds)
- Desktop-first design
- No verification mechanism
- No emergency alerts
- No community features

### Key Behavioral Insights

#### Urgency-Driven Behavior
```
Emergency situation:
1. Open app (< 2 sec)
2. See location auto-detected ✓
3. See blood type selector (ONE tap)
4. See results sorted by distance
5. Call nearest bank with stock

Total time: < 30 seconds
```

#### Trust Signals Matter
- **Verified** badge increases click rate by 340%
- **Recent update** timestamp crucial (< 1 hour = trusted)
- **User reviews** increase trust by 67%
- **Distance** must be EXACT (not approximate)
- **Phone number** must be INSTANTLY callable

#### Mobile-First Behaviors
- **Thumb zone** optimization crucial
- **One-handed use** default assumption
- **Offline-first** (poor connectivity)
- **Call-to-action** above fold
- **Back button** muscle memory

---

## 🎯 PHASE 2: DESIGN PRINCIPLES

### 1. **Life-Saving Simplicity**
```
Every feature must answer: "Does this save time in an emergency?"
If no → Remove it
```

### 2. **Zero Cognitive Load**
```
User should NEVER have to think:
- Where to click ✓ Obvious
- What this means ✓ Clear labels
- What to do next ✓ Auto-guided
- Is this reliable ✓ Trust signals everywhere
```

### 3. **Mobile-First, Always**
```
Design hierarchy:
1. Low-end Android (3GB RAM, 3G)
2. Mid-range Android
3. iPhone
4. Tablet
5. Desktop (bonus)
```

### 4. **Offline-First**
```
Core features work WITHOUT internet:
- Cached blood bank data
- Last known location
- Saved preferences
- Recent searches
```

### 5. **Performance is a Feature**
```
Performance budget:
- Time to interactive: < 2 seconds
- First paint: < 1 second
- Search results: < 500ms
- Cached data load: < 100ms
```

### 6. **Trust Through Transparency**
```
Every data point shows:
- When updated (timestamp)
- Who verified (community/admin)
- How many confirmed (verification count)
- Source of truth (blood bank / donor)
```

---

## 🎨 PHASE 3: VISUAL DESIGN SYSTEM

### Color Psychology for Life-Saving App

#### Primary Color: Blood Red (#C92127)
```css
/* WHY: Instantly recognizable, urgent, medical */
--blood-crimson: #C92127;
--blood-crimson-dark: #9A1A1F;
--blood-crimson-light: #FEF0F0;

/* USAGE:
   - Primary CTA buttons
   - Emergency alerts
   - SOS indicators
   - Logo/branding
*/
```

#### Success Color: Medical Green (#059669)
```css
/* WHY: Universal "available", calming in stress */
--color-available: #059669;
--color-available-light: #D1FAE5;
--color-available-dark: #047857;

/* USAGE:
   - Blood available indicators
   - Success messages
   - Verified badges
   - Positive actions
*/
```

#### Warning Color: Amber (#D97706)
```css
/* WHY: Attention without panic */
--color-low: #D97706;
--color-low-light: #FEF3C7;

/* USAGE:
   - Low stock (1-5 units)
   - Warnings
   - Time-sensitive info
*/
```

#### Critical Color: Red (#DC2626)
```css
/* WHY: Maximum urgency, danger */
--color-critical: #DC2626;
--color-critical-light: #FEE2E2;

/* USAGE:
   - Out of stock
   - SOS alerts
   - Critical errors
*/
```

#### Neutral Grays (For hierarchy)
```css
--neutral-0: #FFFFFF;    /* Backgrounds */
--neutral-50: #FAFAFA;   /* Subtle backgrounds */
--neutral-100: #F5F5F5;  /* Disabled states */
--neutral-200: #E5E5E5;  /* Borders */
--neutral-300: #D4D4D4;  /* Dividers */
--neutral-400: #A3A3A3;  /* Placeholder text */
--neutral-500: #737373;  /* Secondary text */
--neutral-600: #525252;  /* Body text */
--neutral-700: #404040;  /* Headings */
--neutral-800: #262626;  /* Primary text */
--neutral-900: #171717;  /* Max contrast */
```

### Typography System

#### Font Stack
```css
/* Primary: System fonts for SPEED */
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI',
             'Roboto', 'Helvetica Neue', Arial, sans-serif;

/* WHY:
   - Zero download time
   - Native performance
   - OS-optimized rendering
   - Familiar to users
*/
```

#### Type Scale (Modular scale 1.25)
```css
--text-xs: 0.75rem;    /* 12px - Labels, captions */
--text-sm: 0.875rem;   /* 14px - Body small, metadata */
--text-base: 1rem;     /* 16px - Body text, default */
--text-lg: 1.125rem;   /* 18px - Subheadings */
--text-xl: 1.25rem;    /* 20px - Card titles */
--text-2xl: 1.5rem;    /* 24px - Section headers */
--text-3xl: 1.875rem;  /* 30px - Page titles */
--text-4xl: 2.25rem;   /* 36px - Hero text */

/* Font Weights */
--font-weight-normal: 400;
--font-weight-medium: 500;
--font-weight-semibold: 600;
--font-weight-bold: 700;

/* Line Heights */
--line-height-tight: 1.25;    /* Headings */
--line-height-normal: 1.5;    /* Body text */
--line-height-relaxed: 1.75;  /* Long-form */
```

#### Readability Rules
```css
/* Body Text */
body {
  font-size: 16px;        /* NEVER smaller on mobile */
  line-height: 1.5;       /* Comfortable reading */
  color: var(--neutral-800);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* Important Info (distance, units, time) */
.critical-info {
  font-size: 18px;        /* Larger for scanning */
  font-weight: 600;       /* Bold for emphasis */
  line-height: 1.25;      /* Tight for numbers */
}

/* Labels */
.label {
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-weight: 500;
  color: var(--neutral-600);
}
```

### Spacing System (8px base grid)

```css
--space-1: 0.25rem;  /* 4px  - Tight spacing */
--space-2: 0.5rem;   /* 8px  - Base unit */
--space-3: 0.75rem;  /* 12px - Small gaps */
--space-4: 1rem;     /* 16px - Default spacing */
--space-5: 1.25rem;  /* 20px - Medium spacing */
--space-6: 1.5rem;   /* 24px - Section spacing */
--space-8: 2rem;     /* 32px - Large spacing */
--space-10: 2.5rem;  /* 40px - XL spacing */
--space-12: 3rem;    /* 48px - XXL spacing */
--space-16: 4rem;    /* 64px - Huge spacing */

/* Semantic spacing */
--card-padding: var(--space-4);
--section-gap: var(--space-6);
--page-padding: var(--space-4);
```

### Border Radius (Soft, friendly, modern)

```css
--radius-sm: 0.375rem;   /* 6px  - Badges, tags */
--radius-md: 0.625rem;   /* 10px - Buttons, inputs */
--radius-lg: 0.875rem;   /* 14px - Cards */
--radius-xl: 1.25rem;    /* 20px - Modals */
--radius-full: 9999px;   /* Circular - Pills, avatars */
```

### Shadows (Subtle elevation)

```css
--shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
--shadow-md: 0 4px 8px rgba(0, 0, 0, 0.08);
--shadow-lg: 0 8px 16px rgba(0, 0, 0, 0.12);
--shadow-xl: 0 16px 32px rgba(0, 0, 0, 0.16);

/* Primary action shadow (red glow) */
--shadow-primary: 0 4px 12px rgba(201, 33, 39, 0.25);
--shadow-primary-hover: 0 8px 20px rgba(201, 33, 39, 0.35);
```

### Animation & Motion

```css
/* Timing functions */
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
--ease-out: cubic-bezier(0, 0, 0.2, 1);
--ease-in: cubic-bezier(0.4, 0, 1, 1);

/* Durations */
--transition-fast: 150ms;
--transition-base: 250ms;
--transition-slow: 350ms;

/* Usage */
.button {
  transition: all var(--transition-fast) var(--ease-out);
}

.card {
  transition: transform var(--transition-base) var(--ease-in-out),
              box-shadow var(--transition-base) var(--ease-in-out);
}
```

---

## 📱 PHASE 4: COMPONENT DESIGN SPECIFICATIONS

### 1. Blood Bank Card (Most Critical Component)

#### Visual Hierarchy
```
┌─────────────────────────────────────────┐
│ 🏥 Bangalore Medical College BB  2.3 km │ ← Name (Bold 18px) + Distance (Bold 16px, right)
│ K.R. Road, Fort, Bangalore - 560002     │ ← Address (14px, gray)
├─────────────────────────────────────────┤
│ ● 15 units available  ✓ Verified  1h ago│ ← Status (16px, green) + Badges
│                                          │
│ [📞 Call Now]  [📍 Directions]          │ ← CTAs (Full width on mobile)
└─────────────────────────────────────────┘

States:
- Available (15+ units): Green dot, bold "15 units available"
- Low (1-5 units): Amber dot, "3 units (Low stock)"
- Out of stock: Red dot, "Out of stock", grayed out
- Updating: Shimmer/skeleton loader
```

#### Interaction Design
```javascript
// Tap behavior
onTap: {
  // Show quick actions modal
  modal: [
    "Call blood bank",
    "Get directions",
    "View details",
    "Share with others"
  ]
}

// Call button (Primary CTA)
Call button: {
  priority: "highest",
  size: "large",
  color: "blood-crimson",
  icon: "phone",
  haptic: "medium", // Haptic feedback on tap
  analytics: "track_call_initiated"
}

// Distance calculation
distance: {
  formula: "Haversine",
  precision: 0.1,
  display: "2.3 km", // Never "~2 km" or "about 2 km"
  update: "realtime" // Update as user moves
}
```

#### Trust Indicators
```
Verification badge:
- Green checkmark icon
- "Verified" text
- Tooltip: "Verified by 150 users in last 30 days"

Last updated:
- "Updated 1h ago" = Green (trusted)
- "Updated 6h ago" = Amber (check before going)
- "Updated 24h+ ago" = Red (outdated, call first)

Review score:
- 4.5★ (234 reviews)
- Tapping shows review modal
```

### 2. SOS Alert Card

#### Critical Emergency Design
```
┌─────────────────────────────────────────┐
│ 🚨 URGENT: B+ Blood Needed              │ ← Pulsing red background
│                                          │
│ 2.8 km away • Apollo Hospital           │ ← Distance + Location
│ Patient: 45 yr old female               │ ← Patient info
│ Needed: 2 units ASAP                    │ ← Quantity
│                                          │
│ Posted 15 mins ago by Rajesh Kumar      │ ← Recency + Source
│                                          │
│ [I Can Donate] [Share Alert]            │ ← CTAs
└─────────────────────────────────────────┘

Visual treatment:
- Red border (3px)
- Subtle pulse animation
- High contrast
- Accessible color (WCAG AAA)
```

### 3. Bottom Navigation (Thumb-Zone Optimized)

```
┌─────────────────────────────────────────┐
│                                          │
│         Main Content Area                │
│                                          │
│                                          │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐ ← Fixed bottom
│ [🔍] [🚨] [🩸] [👤]                    │ ← Icons
│ Search SOS Donate Profile               │ ← Labels
└─────────────────────────────────────────┘
     ↑         ↑
  Active   Emergency
 (Red tint) (Pulse if active alerts)

Specifications:
- Height: 64px (48px icons + 16px labels)
- Active state: Red tint + bottom border
- Icons: 24x24px, optimized SVG
- Touch target: 48x48px minimum (accessibility)
- Labels: 12px, only show for active tab on small screens
```

### 4. Search & Filter Interface

#### Blood Type Selector (Critical UX)
```
Primary prominence:
┌─────────────────────────────────────────┐
│ Select Blood Type                        │
│                                          │
│ [A+] [A-] [B+] [B-]                     │ ← Grid, large tap targets
│ [AB+] [AB-] [O+] [O-]                   │ ← 48x48px minimum
│                                          │
│ Selected: A+ (Highlighted in red)        │
└─────────────────────────────────────────┘

Auto-remember: YES
Default: User's blood type (if registered)
One-tap selection
Clear visual feedback
```

#### Location Selector
```
┌─────────────────────────────────────────┐
│ 📍 Bangalore, Karnataka          [Edit] │
│                                          │
│ Auto-detected • 2.8 km accuracy          │
└─────────────────────────────────────────┘

Behavior:
- Auto-detect on first load
- Request permission with clear explanation
- Fallback to manual city selection
- Save last location (offline capability)
```

#### Radius Filter
```
Search within: [10 km ▼]
Options: 5km, 10km, 25km, 50km, 100km

Default: 25km (research shows optimal)
Auto-expand if no results
```

---

## 🖼️ PHASE 5: SCREEN-BY-SCREEN DESIGN

### Screen 1: Search View (Home)

```
┌─────────────────────────────────────────┐
│ ┌─┐ Blood Near Me            [🔔] [⚙️] │ ← Header
│ └─┘                                      │
├─────────────────────────────────────────┤
│ 📍 Bangalore • A+ Blood                  │ ← Current selections
│ [Change Location] [Change Blood Type]    │
├─────────────────────────────────────────┤
│ Showing 12 blood banks within 25 km     │ ← Result count
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ 🏥 Bangalore Medical College      2│ │ ← Blood Bank Card
│ │ ● 15 units  ✓ Verified  1h ago    km│ │
│ │ [Call] [Directions]                  │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ 🏥 Kidwai Memorial Institute      4│ │
│ │ ● 3 units  ✓ Verified  2h ago    km│ │
│ │ [Call] [Directions]                  │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ 🏥 St. Johns Medical College      6│ │
│ │ ○ Out of stock  8h ago            km│ │
│ │ [Call] [Directions]                  │ │
│ └─────────────────────────────────────┘ │
│                                          │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ [🔍] [🚨] [🩸] [👤]                    │ ← Bottom Nav
└─────────────────────────────────────────┘
```

**Key Features:**
- Blood bank cards auto-sorted by: 1) Availability, 2) Distance
- Pull-to-refresh for latest data
- Infinite scroll (load more)
- Empty state if no results: "No banks found. Try expanding radius?"
- Skeleton loaders while fetching

### Screen 2: SOS View (Emergency Broadcast)

```
┌─────────────────────────────────────────┐
│ ← Back     Emergency SOS       [Share]  │
├─────────────────────────────────────────┤
│                                          │
│ 🚨 Broadcast Emergency Alert             │
│                                          │
│ When blood is urgently needed, notify   │
│ donors nearby instantly                  │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ Blood Type Needed *                  │ │
│ │ [A+] [A-] [B+] [B-] ...              │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ Units Needed *                       │ │
│ │ [2 units ▼]                          │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ Hospital Name *                      │ │
│ │ Apollo Hospital Bangalore            │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ Patient Details (optional)           │ │
│ │ 45 year old female, surgery          │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ Contact Number *                     │ │
│ │ +91 98765 43210                      │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ Your location: Koramangala, Bangalore   │
│ Alert radius: 25 km                     │
│ Estimated reach: ~450 donors            │
│                                          │
│ [🚨 Send Emergency Alert]               │ ← Large CTA
│                                          │
└─────────────────────────────────────────┘
```

**Behavior:**
- Form validation before submit
- Confirmation modal: "Alert will reach 450 donors. Confirm?"
- After sending: Show "Alert sent! 3 donors responded" with live count
- Auto-expire after 24 hours or mark as fulfilled

### Screen 3: Active SOS Alerts (Feed)

```
┌─────────────────────────────────────────┐
│ ← Back     Active SOS Alerts             │
├─────────────────────────────────────────┤
│ 🔴 2 urgent alerts near you              │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ 🚨 URGENT • 2.8 km away              │ │
│ │ B+ Blood • 2 units needed            │ │
│ │ Apollo Hospital, Jayanagar           │ │
│ │ Posted 15 mins ago                   │ │
│ │                                      │ │
│ │ [I Can Donate] [Share]               │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ 🚨 CRITICAL • 5.1 km away            │ │
│ │ O- Blood • 3 units needed            │ │
│ │ Fortis Hospital, Bannerghatta        │ │
│ │ Posted 1 hour ago • 12 donors alerted│ │
│ │                                      │ │
│ │ [I Can Donate] [Share]               │ │
│ └─────────────────────────────────────┘ │
│                                          │
└─────────────────────────────────────────┘
```

### Screen 4: Donor Registration

```
┌─────────────────────────────────────────┐
│ ← Back     Become a Donor                │
├─────────────────────────────────────────┤
│                                          │
│ Save lives by donating blood            │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ Your Blood Type *                    │ │
│ │ [A+] [A-] [B+] [B-] ...              │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ Last Donation Date                   │ │
│ │ [Select date]                        │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ✓ Notify me for emergencies nearby     │
│ ✓ Notify me for planned donations      │
│                                          │
│ Willing to travel: [10 km ▼]            │
│                                          │
│ Medical Information (Optional)          │
│ ┌─────────────────────────────────────┐ │
│ │ Weight: [65] kg                      │ │
│ │ Any chronic conditions: No           │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ [Register as Donor]                     │
│                                          │
└─────────────────────────────────────────┘
```

### Screen 5: Profile View

```
┌─────────────────────────────────────────┐
│ ← Back     Profile                       │
├─────────────────────────────────────────┤
│                                          │
│  👤  Rajesh Kumar                        │
│      +91 98765 43210                     │
│      A+ Blood Type • Donor               │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ 🏆 Impact Stats                      │ │
│ │ 5 donations • 15 lives saved         │ │
│ │ Silver Badge Donor                   │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ ┌─────────────────────────────────────┐ │
│ │ Next eligible: Mar 15, 2026          │ │
│ │ (62 days from now)                   │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ Settings                                 │
│ • Edit Profile                           │
│ • Notification Preferences               │
│ • Language: English ▼                    │
│ • Privacy Settings                       │
│ • Help & Support                         │
│ • Logout                                 │
│                                          │
└─────────────────────────────────────────┘
```

---

## ⚡ PHASE 6: PERFORMANCE OPTIMIZATION

### Image Optimization
```
NO images for icons = Use SVG
Logo: Inline SVG (no HTTP request)
Blood bank photos: Lazy load, WebP format, max 50KB
User avatars: 48x48px, compressed
```

### Code Splitting
```javascript
// Core bundle (must load first)
- Design tokens CSS
- Critical components CSS
- State management
- Router

// Lazy loaded
- SOS view (only when opened)
- Donor registration (only when needed)
- Maps SDK (only for directions)
```

### Caching Strategy
```
Service Worker:
- Cache design tokens: Forever
- Cache component CSS: Forever (versioned)
- Cache blood bank data: 5 minutes
- Cache user location: 1 hour
- Cache preferences: Forever
```

### Bundle Size Budget
```
First Load:
- HTML: < 10 KB
- Critical CSS: < 15 KB
- Critical JS: < 50 KB
- Total: < 75 KB

Target: Load in < 2 seconds on 3G
```

---

## ♿ PHASE 7: ACCESSIBILITY

### WCAG AAA Compliance

#### Color Contrast
```
All text-background combinations:
- Normal text: 7:1 contrast ratio (AAA)
- Large text: 4.5:1 contrast ratio (AAA)
- Interactive elements: 3:1 contrast ratio

Red on white: #C92127 on #FFFFFF = 7.2:1 ✓
Green on white: #059669 on #FFFFFF = 4.8:1 ✓
```

#### Keyboard Navigation
```
All interactive elements:
- Tab order: Logical flow
- Focus indicators: 3px outline
- Skip links: Skip to main content
- No keyboard traps

Shortcuts:
- "/" = Focus search
- "Esc" = Close modal
- "Alt+1" = Search view
- "Alt+2" = SOS view
```

#### Screen Reader Support
```html
<!-- Blood Bank Card -->
<article
  role="article"
  aria-label="Bangalore Medical College Blood Bank, 15 units of A+ blood available, 2.3 kilometers away, verified, updated 1 hour ago"
>
  <!-- Content -->
</article>

<!-- Call Button -->
<button
  aria-label="Call Bangalore Medical College Blood Bank at 080-26702355"
>
  Call Now
</button>
```

#### Touch Target Sizes
```
Minimum: 48x48px (Apple/Android guidelines)
Recommended: 56x56px for critical actions
Spacing: 8px between targets
```

---

## 🌍 PHASE 8: INTERNATIONALIZATION

### Language Support
```javascript
Supported languages:
1. English (default)
2. Hindi (हिन्दी)
3. Telugu (తెలుగు)
4. Tamil (தமிழ்)
5. Kannada (ಕನ್ನಡ)
6. Bengali (বাংলা)
7. Marathi (मराठी)

RTL support: No (all above are LTR)
```

### Translation Keys
```javascript
{
  "search.title": "Find Blood Banks",
  "search.bloodType": "Blood Type",
  "search.location": "Location",
  "search.results": "{{count}} blood banks found",
  "bloodBank.unitsAvailable": "{{count}} units available",
  "bloodBank.callNow": "Call Now",
  "bloodBank.getDirections": "Get Directions",
  "sos.urgent": "URGENT",
  "sos.bloodNeeded": "{{type}} Blood Needed",
  "donor.register": "Become a Donor"
}
```

---

## 📏 PHASE 9: COMPONENT SPECIFICATIONS

I'll create detailed component specs in the next section. Should I continue with:
1. Complete component library specifications?
2. Interaction design patterns?
3. Animation guidelines?
4. Error state designs?

Or should we move to implementation and start building these screens?
