# Plan Partner - AI-Powered Task Management App

**Plan Partner** is a Flutter mobile application designed for working professionals and students to organize daily tasks, reduce planning stress, and improve productivity through AI-assisted structured task management.

## 📱 Features

### Core Screens

1. **Welcome & Dashboard (Today Screen)**
   - View all tasks for the current day with weather widget
   - Quick task completion toggles
   - Priority-based task display (High/Medium/Low with color badges)
   - Time-formatted schedule view (24-hour format)
   - Easily tap tasks to view full details

2. **Task Entry & Configuration**
   - Add new tasks with required name field
   - Priority selection (High/Medium/Low)
   - Optional description field
   - AI-powered scheduling option (UI ready for backend integration)
   - Form validation with error handling
   - Auto-assign tomorrow's date for new tasks

3. **Suggested Schedule (AI Review Screen)**
   - View AI-optimized daily schedule
   - Priority indicators and time slots
   - Accept or refine suggested plan
   - Task completion tracking (ready for swipe actions)

4. **Task Detail & Completion**
   - View full task information
   - Toggle task completion status
   - One-tap back navigation

---

## 🏗️ Architecture

### Feature-Based Structure

```
lib/
├── core/
│   ├── models/          # Data models (Task, User, Api responses)
│   ├── providers/       # State management (ChangeNotifier)
│   ├── services/        # REST API client & external services
│   └── routes/          # GoRouter navigation setup
├── features/
│   ├── dashboard/       # Today Screen
│   ├── task_entry/      # New Task form
│   ├── task_detail/     # Single task view
│   ├── review/          # AI Suggested Schedule
│   └── notifications/   # Future notifications
├── main.dart            # App entry point & theme config
└── pubspec.yaml         # Dependencies
```

### Technology Stack

| Component | Version | Purpose |
|-----------|---------|---------|
| Flutter | 3.11+ | Mobile framework |
| Dart | 3.11+ | Programming language |
| Provider | 6.0+ | State management (ChangeNotifier + Consumer) |
| GoRouter | 17.1.0 | Declarative navigation |
| http | 1.1.0 | REST API communication |
| intl | 0.20+ | Date/time formatting |
| uuid | 4.5+ | Unique ID generation |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.11.0 or higher
- Dart 3.11.0 or higher
- A device or emulator (Web, Android, iOS, Windows, macOS, Linux)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/plan_partner.git
   cd plan_partner
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**

   **On Web (Recommended for quick testing):**
   ```bash
   flutter run -d edge
   ```

   **On Android Emulator:**
   ```bash
   flutter run -d emulator-5554
   ```

   **On iOS Simulator:**
   ```bash
   flutter run -d device-id
   ```

   **On Windows (Requires Visual Studio C++ tools):**
   ```bash
   flutter run -d windows
   ```

### Testing

```bash
# Run all widget tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run with coverage report
flutter test --coverage
```

### Code Quality

```bash
# Analyze code for issues
flutter analyze

# Format code to style guidelines
dart format lib/

# Get package updates info
flutter pub outdated
```

---

## 📡 REST API Integration

### Current State: Ready for Backend Integration

The app includes a fully configured REST API service that's ready to connect to your backend.

### API Configuration

Update the base URL in `lib/core/services/api_service.dart`:

```dart
static const String baseUrl = 'https://api.plan-partner.com/api';
```

### Expected Backend Endpoints

Your backend should provide these endpoints (CRUD operations):

```
POST   /tasks              Create a new task
GET    /tasks              Fetch all user tasks
GET    /tasks/{id}         Fetch a specific task
PUT    /tasks/{id}         Update a task
DELETE /tasks/{id}         Delete a task

POST   /schedule/suggest   Get AI-optimized schedule
POST   /auth/login         Authenticate user
```

### API Request/Response Contract

**Create Task:**
```json
POST /tasks
Content-Type: application/json

{
  "title": "Project Meeting",
  "description": "Discuss Q1 roadmap",
  "priority": "high",
  "dueDate": "2026-02-20T10:00:00Z",
  "estimatedDuration": 60
}

Response (201):
{
  "id": "uuid-string",
  "title": "Project Meeting",
  "description": "high",
  "dueDate": "2026-02-20T10:00:00Z",
  "estimatedDuration": 60,
  "isCompleted": false,
  "createdAt": "2026-02-19T15:30:00Z"
}
```

### Example: Using the API Service

```dart
import 'package:plan_partner/core/services/api_service.dart';

final apiService = ApiService();

// Fetch all tasks
try {
  final tasks = await apiService.get('/tasks');
  print('Tasks: $tasks');
} catch (e) {
  print('Error: $e');
}

// Create a new task
try {
  final newTask = await apiService.post('/tasks', {
    'title': 'Design mockups',
    'priority': 'medium',
  });
  print('Created: $newTask');
} catch (e) {
  print('Error: $e');
}
```

---

## 🎨 Design & Theme

### Color Scheme

- **Primary Teal**: `#4DB8A8` (app bars, FABs, theme color)
- **High Priority**: `#E74C3C` (red badge)
- **Medium Priority**: `#F39C12` (orange badge)
- **Low Priority**: `#27AE60` (green badge)
- **Neutral**: `#95A5A6` (gray backgrounds)

### Typography

- Using Material 3 design system
- Responsive text sizing (h1, h2, body, etc.)
- Default sans-serif (system font)

---

## 📊 Data Models

### Task Model

```dart
class Task {
  final String id;                  // UUID
  String title;                     // Task name
  String? description;              // Priority level (high/medium/low)
  DateTime? dueDate;                // Due date/time
  Duration? estimatedDuration;      // Estimated time in minutes
  bool isCompleted;                 // Completion flag

  // JSON serialization
  factory Task.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

### User Model

```dart
class User {
  final String id;      // UUID
  String name;          // User full name

  // JSON serialization
  factory User.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

---

## 🔄 State Management Flow

Plan Partner uses **Provider** for state management:

1. **User Action** → UI triggers method on Provider
2. **Provider** → Executes business logic, optionally calls ApiService
3. **notifyListeners()** → Notifies all listening widgets
4. **UI Rebuild** → Widgets rebuild with new state via Consumer/watch

### Providers

- **TaskProvider** (`lib/core/providers/task_provider.dart`)
  - Manages task list state
  - CRUD operations (add, update, toggle, delete)

- **UserProvider** (`lib/core/providers/user_provider.dart`)
  - Manages user authentication state
  - User preferences

---

## 🛠️ Development Workflow

### Hot Reload vs Hot Restart

While running the app:

```bash
r    # Hot Reload (keeps app state, faster)
R    # Hot Restart (resets state, fully recompiles)
```

### Debug Shortcuts

```bash
h    # Show help and available commands
d    # Detach (app runs, closes debug connection)
q    # Quit (stop the app)
```

### Environment Variables (Optional)

Create `lib/core/config/env.dart`:

```dart
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.plan-partner.local/api',
  );
}
```

Run with:
```bash
flutter run --dart-define=API_BASE_URL=https://your-api.com/api
```

---

## 🔐 Security Best Practices

- ✅ Never hardcode API keys or credentials
- ✅ Use environment variables for sensitive data
- ✅ Validate all user input before API calls
- ✅ Use HTTPS for all API communication
- ✅ Implement token-based authentication when ready
- ✅ Add request timeout handling
- ✅ Log errors securely (no sensitive data in logs)

---

## ⚠️ Known Limitations & TODOs

| Feature | Status | Notes |
|---------|--------|-------|
| UI/Navigation | ✅ Complete | All 4 core screens ready |
| Task CRUD (local) | ✅ Complete | In-memory storage works |
| API Service | ✅ Complete | Ready to connect backend |
| REST API Backend | ❌ Required | Build as separate service |
| Authentication | ⏳ Planned | Login/registration flow |
| AI Scheduling | ⏳ Planned | Backend algorithm needed |
| Offline Support | ⏳ Planned | Local database + sync |
| Push Notifications | ⏳ Planned | Task reminders |
| Dark Mode | ⏳ Planned | Theme switching |
| Shared Tasks | ⏳ Planned | Collaboration feature |

---

## 📦 Project Dependencies

```yaml
dependencies:
  flutter: ^3.11.0
  provider: ^6.0.5       # State management
  go_router: ^17.1.0     # Navigation
  uuid: ^4.5.2           # ID generation
  intl: ^0.20.2          # Date formatting
  http: ^1.1.0           # REST API calls

dev_dependencies:
  flutter_test: # Testing framework
  flutter_lints: ^6.0.0  # Code analysis
```

---

## 🎓 Learning Resources

- [Flutter Official Documentation](https://flutter.dev)
- [Dart Language Guide](https://dart.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [REST API Best Practices](https://restfulapi.net/)
- [HTTP Package](https://pub.dev/packages/http)

---

## 📞 Support & Contribution

### Issue Reporting

Found a bug? Please create an issue with:
- App version (flutter version)
- Device/OS info
- Steps to reproduce
- Expected vs actual behavior

### Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

Copyright © 2026 Plan Partner Team. All rights reserved.

---

## ✨ Roadmap

### Phase 1: MVP (Current) ✅
- [x] Core UI & navigation
- [x] Local task management
- [x] REST API integration scaffold

### Phase 2: Backend Integration
- [ ] Implement backend REST API
- [ ] Connect to database
- [ ] User authentication

### Phase 3: AI Features
- [ ] AI-powered scheduling algorithm
- [ ] Smart task prioritization
- [ ] Duration estimation

### Phase 4: Social & Sync
- [ ] Offline synchronization
- [ ] Push notifications
- [ ] Task sharing & collaboration

### Phase 5: Enhancement
- [ ] Dark mode support
- [ ] Advanced analytics
- [ ] Mobile app stores release

---

**Happy task planning! 🚀**

For questions or discussion, please reach out to the development team.
