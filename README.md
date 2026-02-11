# 🩸 Blood Bridge Toolkit

**Open-source platform for coordinating blood donation information**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![React](https://img.shields.io/badge/React-18.2.0-61DAFB?logo=react)](https://reactjs.org/)
[![Vite](https://img.shields.io/badge/Vite-5.0.8-646CFF?logo=vite)](https://vitejs.dev/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-3.4.0-38B2AC?logo=tailwind-css)](https://tailwindcss.com/)
[![PWA Ready](https://img.shields.io/badge/PWA-Ready-5A0FC8?logo=pwa)](https://web.dev/progressive-web-apps/)

> **🚨 IMPORTANT:** This is a **toolkit**, not a hosted service. It's open-source software for organizations to deploy independently. Each deployer is responsible for their own instance.

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Quick Start](#-quick-start)
- [Documentation](#-documentation)
- [Demo](#-demo)
- [Screenshots](#-screenshots)
- [Legal Protection](#-legal-protection)
- [Multi-Language Support](#-multi-language-support)
- [Architecture](#-architecture)
- [API Integration](#-api-integration)
- [Contributing](#-contributing)
- [License](#-license)
- [Disclaimer](#-disclaimer)

---

## 🎯 Overview

**Blood Bridge Toolkit** is a comprehensive, production-ready blood donation coordination platform designed specifically for India. It helps users:

- 🔍 Find blood banks and check availability
- 🚨 Send emergency SOS alerts to nearby donors
- ❤️ Register as voluntary blood donors
- 📅 Discover blood donation camps
- ✅ Check donation eligibility
- 🩸 Understand blood type compatibility

### What Makes This Different?

- **Open Source** - Deploy independently, no vendor lock-in
- **Legal Protection** - Comprehensive legal documents included
- **Multi-Language** - 6 Indian languages out of the box
- **PWA Ready** - Works offline with service workers
- **Admin Dashboard** - Manage blood banks and donors
- **Privacy First** - LocalStorage-first, no backend required

---

## ✨ Features

### Core Features
- ✅ **Blood Bank Search** - Search by type, location, radius with map/list views
- ✅ **Emergency SOS** - Send urgent blood requests to registered donors
- ✅ **Donor Registration** - Complete profile with medical information
- ✅ **Profile Management** - Track donations, certificates, impact stats
- ✅ **Blood Camps Calendar** - Find and RSVP for donation camps
- ✅ **Eligibility Checker** - 8-question quiz for donation eligibility
- ✅ **Compatibility Tool** - Interactive blood type compatibility chart
- ✅ **Admin Dashboard** - Manage platform (password-protected)

### Technical Features
- ✅ **PWA Support** - Offline functionality with service worker
- ✅ **Google Maps Integration** - Visual blood bank locations
- ✅ **Multi-Language** - English, Hindi, Tamil, Telugu, Bengali, Marathi
- ✅ **Responsive Design** - Mobile-first, works on all devices
- ✅ **Toast Notifications** - User-friendly feedback system
- ✅ **Legal Documents** - Privacy Policy, Terms of Service, Disclaimer
- ✅ **Demo Mode** - Clear warnings for testing instances

---

## 🛠️ Tech Stack

### Frontend
- **React 18** - UI library with hooks
- **Vite** - Lightning-fast build tool
- **Tailwind CSS** - Utility-first CSS framework

### Features
- **PWA** - Service workers, manifest, offline support
- **i18n** - Custom internationalization framework
- **LocalStorage** - Client-side data persistence
- **Context API** - State management for toasts and i18n

### APIs & Integrations
- **Google Maps API** - Location services (optional)
- **eRaktKosh** - Government blood bank data (template ready)
- **Geolocation API** - User location detection

---

## 🚀 Quick Start

### Prerequisites
```bash
node >= 16.0.0
npm >= 7.0.0
```

### Installation

```bash
# Clone the repository
git clone https://github.com/SamirSuman01/blood_near_me.git
cd blood_near_me

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env
# Edit .env with your organization details

# Start development server
npm run dev
```

**Open:** http://localhost:5173

### Build for Production

```bash
# Build
npm run build

# Preview production build
npm run preview
```

---

## 📚 Documentation

Comprehensive guides included:

1. **[GETTING_STARTED.md](GETTING_STARTED.md)** - Installation and setup
2. **[FEATURE_ROADMAP.md](FEATURE_ROADMAP.md)** - Feature planning and priorities
3. **[FEATURES_BUILT.md](FEATURES_BUILT.md)** - Complete feature list (30+ pages)
4. **[LEGAL_SETUP_GUIDE.md](LEGAL_SETUP_GUIDE.md)** - Legal document implementation
5. **[DISCLAIMER_GUIDE.md](DISCLAIMER_GUIDE.md)** - Managing disclaimers and warnings
6. **[ERAKTKOSH_INTEGRATION_GUIDE.md](ERAKTKOSH_INTEGRATION_GUIDE.md)** - Real API integration
7. **[COMPLETION_STATUS.md](COMPLETION_STATUS.md)** - Project progress (89% complete)

---

## 🎬 Demo

**Live Demo:** *Coming soon* (Deploy to see it live!)

### Quick Demo
```bash
npm run dev
# Visit http://localhost:5173
# Click through: Find Blood → SOS Alert → Become Donor → Camps
# Try language switcher (6 languages)
# Test eligibility checker
# Explore admin dashboard (password: admin123)
```

---

## 📱 Screenshots

### Home Page
Clean, professional interface with quick action cards for all features.

### Search View (Enhanced)
- List and map view toggle
- Filters: verified only, minimum units
- Sort by: distance, availability, name
- GPS location integration

### Blood Compatibility Checker
Interactive tool showing who you can donate to and receive from.

### Eligibility Quiz
8-question progressive quiz with immediate feedback.

### Blood Donation Camps
Calendar view with RSVP functionality and camp details.

### Admin Dashboard
Password-protected management panel with stats and controls.

### Multi-Language Support
Seamless language switching between 6 Indian languages.

*Screenshots coming soon - deploy to generate!*

---

## ⚖️ Legal Protection

Comprehensive legal documents included to protect:
- **You** (the open-source creator)
- **Deployers** (organizations running instances)
- **Users** (people using the platform)

### Included Documents:
1. **[LICENSE](LICENSE)** - MIT License with health disclaimer
2. **[DISCLAIMER.md](DISCLAIMER.md)** - What this is/isn't, responsibilities
3. **[PRIVACY_POLICY.md](PRIVACY_POLICY.md)** - Data collection and usage (18 sections)
4. **[TERMS_OF_SERVICE.md](TERMS_OF_SERVICE.md)** - Rules for using platform (23 sections)

### Key Protection Points:
- ✅ Clear "information only, not medical advice" disclaimers
- ✅ Deployer responsibility model (not creator liability)
- ✅ User data privacy (GDPR/HIPAA considerations)
- ✅ Emergency service disclaimers
- ✅ No warranty disclaimers
- ✅ Indemnification clauses

**⚠️ Important:** Customize legal documents for your jurisdiction and consult a lawyer before real deployment.

---

## 🌍 Multi-Language Support

### Supported Languages (6)

| Language | Code | Coverage | Speakers |
|----------|------|----------|----------|
| English | `en` | International | Default |
| हिन्दी (Hindi) | `hi` | 52% of India | 528M |
| தமிழ் (Tamil) | `ta` | 6.3% of India | 69M |
| తెలుగు (Telugu) | `te` | 6.7% of India | 82M |
| বাংলা (Bengali) | `bn` | 8.1% of India | 97M |
| मराठी (Marathi) | `mr` | 7.0% of India | 83M |

**Total Coverage:** ~80% of India's population

### Adding More Languages

Easy to add more! Just:
1. Create `src/i18n/translations/[lang].js`
2. Copy translation structure from `en.js`
3. Translate 170+ strings
4. Add to `LANGUAGES` in `src/i18n/index.js`

---

## 🏗️ Architecture

### Project Structure
```
blood_near_me/
├── public/
│   ├── manifest.json       # PWA manifest
│   ├── sw.js              # Service worker
│   └── offline.html       # Offline fallback
├── src/
│   ├── components/        # 20 React components
│   │   ├── SearchViewEnhanced.jsx
│   │   ├── MapView.jsx
│   │   ├── ProfileEnhanced.jsx
│   │   ├── CampsView.jsx
│   │   ├── AdminDashboard.jsx
│   │   └── ...
│   ├── i18n/             # Internationalization
│   │   ├── index.js
│   │   └── translations/
│   │       ├── en.js
│   │       ├── hi.js
│   │       ├── ta.js
│   │       └── ...
│   ├── utils/            # Utilities
│   │   ├── api.js        # API integration
│   │   ├── helpers.js    # Validation, formatting
│   │   ├── storage.js    # LocalStorage
│   │   └── mockData.js   # Sample data
│   ├── config/
│   │   └── index.js      # Configuration
│   ├── App.jsx           # Main app
│   ├── main.jsx          # Entry point
│   └── index.css         # Global styles
├── docs/                 # 8 documentation files
├── .env                  # Configuration
├── package.json
└── vite.config.js
```

### Component Architecture
- **View Components** (9) - Full pages (Search, SOS, Donate, Profile, etc.)
- **UI Components** (7) - Reusable UI (Navbar, Footer, Toast, Loading, etc.)
- **Utility Components** (4) - Specialized (BloodBankCard, LanguageSwitcher, etc.)

### State Management
- **Context API** - Toast notifications, i18n
- **LocalStorage** - Donor profiles, search history, SOS requests
- **React State** - Component-level state with hooks

---

## 🔌 API Integration

### Current: Mock Data
Uses sample data from `src/utils/mockData.js`:
- 5 Jamshedpur blood banks
- Complete with GPS coordinates, availability, contact info

### Ready for: Real Data

**eRaktKosh Integration** (India's national blood bank system)
```javascript
// Template ready in src/utils/api.js
import { searchBloodBanks } from './utils/api';

const banks = await searchBloodBanks('A+', 'Jamshedpur', 50);
// Automatically falls back to mock data if API unavailable
```

**See [ERAKTKOSH_INTEGRATION_GUIDE.md](ERAKTKOSH_INTEGRATION_GUIDE.md) for:**
- API endpoint details
- Authentication setup
- Data transformation
- Error handling
- Rate limiting

---

## 🎨 Design

### Color Palette
```css
/* Blood Red Theme */
--blood-50:  #FEF2F2;
--blood-100: #FEE2E2;
--blood-600: #DC2626;  /* Primary */
--blood-700: #B91C1C;  /* Hover */
```

### Components
- **Buttons** - Primary, secondary, danger variants
- **Cards** - Elevated, hover effects, responsive
- **Badges** - Color-coded status indicators
- **Forms** - Validated inputs, selects, textareas
- **Modals** - Accessible with focus trap
- **Toasts** - Success, error, warning, info

### Responsive
- **Mobile-first** - Designed for phones
- **Breakpoints** - sm, md, lg, xl
- **Touch-friendly** - 44px minimum tap targets

---

## 🧪 Testing

### Manual Testing Checklist
- [ ] Blood bank search with different types
- [ ] GPS location detection
- [ ] SOS alert creation
- [ ] Donor registration with validation
- [ ] Profile editing and deletion
- [ ] Language switching (all 6)
- [ ] Eligibility quiz (all questions)
- [ ] Compatibility checker
- [ ] Camps calendar and RSVP
- [ ] Admin dashboard login
- [ ] Offline mode (disconnect internet)
- [ ] Responsive design (mobile, tablet, desktop)

### Automated Testing
Not implemented yet. Recommended:
- **Vitest** - Unit tests for utilities
- **React Testing Library** - Component tests
- **Cypress** - E2E tests

---

## 🚢 Deployment

### Deploy to Vercel (Recommended)
```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel --prod
```

### Deploy to Netlify
```bash
# Install Netlify CLI
npm i -g netlify-cli

# Login
netlify login

# Deploy
netlify deploy --prod
```

### Deploy to GitHub Pages
```bash
# Build
npm run build

# Deploy to gh-pages branch
npx gh-pages -d dist
```

### Environment Variables
Set these in your hosting platform:
```env
VITE_ORG_NAME="Your Organization"
VITE_LEGAL_ENTITY="Your Company Pvt. Ltd."
VITE_SUPPORT_EMAIL="support@yourorg.com"
VITE_DEMO_MODE=false
VITE_GOOGLE_MAPS_KEY="your_api_key"
```

---

## 🤝 Contributing

We welcome contributions! Here's how:

### Ways to Contribute
1. **Report bugs** - Open an issue with details
2. **Suggest features** - Share your ideas
3. **Improve documentation** - Fix typos, add examples
4. **Add translations** - Contribute new languages
5. **Write tests** - Increase code coverage
6. **Fix bugs** - Submit pull requests

### Development Workflow
```bash
# Fork the repo
# Clone your fork
git clone https://github.com/YOUR_USERNAME/blood_near_me.git

# Create feature branch
git checkout -b feature/amazing-feature

# Make changes
# Test locally

# Commit with descriptive message
git commit -m "Add amazing feature"

# Push to your fork
git push origin feature/amazing-feature

# Open pull request
```

### Code Standards
- Use React hooks (not class components)
- Follow Tailwind utility-first approach
- Add comments for complex logic
- Update documentation for new features
- Test on mobile and desktop

---

## 📈 Roadmap

### ✅ Phase 1-3: Completed (89%)
- [x] Core features (Search, SOS, Donate, Profile)
- [x] 6 languages (English, Hindi, Tamil, Telugu, Bengali, Marathi)
- [x] PWA support (offline mode)
- [x] Admin dashboard
- [x] Legal documents
- [x] Documentation (8 guides)

### 🔄 Phase 4: In Progress
- [ ] Real eRaktKosh API integration (needs credentials)
- [ ] Backend + Database (optional - currently localStorage)
- [ ] Automated tests (Vitest, Cypress)

### 🔮 Phase 5: Future
- [ ] More languages (Gujarati, Kannada, Malayalam, etc.)
- [ ] Success stories section
- [ ] Leaderboard/gamification
- [ ] Push notifications
- [ ] SMS/WhatsApp integration
- [ ] Certificate generation (PDF)
- [ ] Advanced analytics

See [FEATURE_ROADMAP.md](FEATURE_ROADMAP.md) for detailed planning.

---

## 📊 Stats

- **20 Components** - Modular React architecture
- **6 Languages** - 170+ translations each
- **8 Documentation Files** - 50+ pages total
- **3 Legal Documents** - 30+ pages of protection
- **89% Complete** - Production-ready for portfolio
- **100% Open Source** - MIT Licensed

---

## 🏆 Use Cases

### For Students
- **Portfolio project** - Showcase full-stack skills
- **Learning resource** - Study React, Vite, i18n, PWA
- **Hackathon entry** - Complete, ready to present

### For Organizations
- **Hospitals** - Manage blood bank information
- **NGOs** - Coordinate donation drives
- **Government** - Public health information system
- **Blood Banks** - Donor management

### For Developers
- **Template** - Start new projects with solid foundation
- **Learning** - Study production-grade React patterns
- **Contribution** - Give back to open source

---

## ⚠️ Disclaimer

**IMPORTANT: READ BEFORE USE**

1. **Information Only** - This is NOT a medical service
2. **Always Verify** - Call blood banks directly to confirm availability
3. **Emergencies** - Call 108 (India) immediately, don't rely on this app
4. **No Warranty** - Provided "as is" without guarantees
5. **Deployer Responsibility** - Each deployer accepts full liability
6. **Not Medical Advice** - Consult healthcare professionals

See [DISCLAIMER.md](DISCLAIMER.md) for complete details.

---

## 📄 License

**MIT License with Health Disclaimer**

```
Copyright (c) 2026 Blood Bridge Toolkit Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, subject to the following conditions:

THIS SOFTWARE IS PROVIDED FOR INFORMATIONAL PURPOSES ONLY AND IS NOT INTENDED
TO PROVIDE MEDICAL ADVICE OR TO SUBSTITUTE FOR PROFESSIONAL MEDICAL CARE.
```

See [LICENSE](LICENSE) for full text.

---

## 🙏 Acknowledgments

### Data Sources
- **eRaktKosh** - National Blood Transfusion Council, Govt. of India
- **Google Maps** - Location services
- **OpenStreetMap** - Mapping data

### Technologies
- **React Team** - Amazing UI library
- **Vite Team** - Lightning-fast build tool
- **Tailwind Labs** - Excellent CSS framework

### Inspiration
- Healthcare workers saving lives every day
- Blood donors around the world
- Open-source community

---

## 📞 Contact & Support

### For This Instance
- **Repository:** https://github.com/SamirSuman01/blood_near_me
- **Issues:** https://github.com/SamirSuman01/blood_near_me/issues
- **Discussions:** https://github.com/SamirSuman01/blood_near_me/discussions

### For Deployers
- Read documentation in `/docs` folder
- Check [GETTING_STARTED.md](GETTING_STARTED.md)
- Review [LEGAL_SETUP_GUIDE.md](LEGAL_SETUP_GUIDE.md)
- Consult a lawyer before production deployment

### For Contributors
- Open issues for bugs/features
- Submit pull requests with tests
- Join discussions for major changes
- Follow code of conduct

---

## 🌟 Star This Project

If you find this project useful:
- ⭐ Star on GitHub
- 🐛 Report bugs
- 💡 Suggest features
- 🤝 Contribute code
- 📢 Share with others

---

## 📝 Changelog

### v1.0.0-beta (February 2026)
- ✨ Initial release with core features
- 🌍 6 languages supported
- 📱 PWA support
- 📄 Complete legal documents
- 📚 Comprehensive documentation

See [COMPLETION_STATUS.md](COMPLETION_STATUS.md) for detailed progress.

---

**Built with ❤️ for saving lives**

*Open source. No strings attached. Deploy anywhere.*

---

## 🔗 Quick Links

- **Documentation:** [/docs](./docs)
- **Getting Started:** [GETTING_STARTED.md](GETTING_STARTED.md)
- **Feature Roadmap:** [FEATURE_ROADMAP.md](FEATURE_ROADMAP.md)
- **Legal Setup:** [LEGAL_SETUP_GUIDE.md](LEGAL_SETUP_GUIDE.md)
- **API Integration:** [ERAKTKOSH_INTEGRATION_GUIDE.md](ERAKTKOSH_INTEGRATION_GUIDE.md)
- **License:** [LICENSE](LICENSE)
- **Disclaimer:** [DISCLAIMER.md](DISCLAIMER.md)

---

**Status:** ✅ Portfolio-Ready | ⚠️ Needs Work for Production

**Last Updated:** February 12, 2026
**Version:** 1.0.0-beta
**Maintainer:** [@SamirSuman01](https://github.com/SamirSuman01)
