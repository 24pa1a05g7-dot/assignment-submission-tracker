# Assignment Submission Tracker

A Flutter application that helps students organise coursework, manage deadlines, and track assignment completion.

**Roll Number:** 24PA1A05G7  
**Project Title:** Assignment Submission Tracker  
**Platform:** Flutter Web  
**Development Environment:** GitHub Codespaces

## Features

- Add assignments with title, subject, due date, priority, and status
- Edit or delete assignments
- Mark assignments as completed or pending
- Search assignments by title or subject
- Filter assignments by Pending, In Progress, Completed, or Overdue
- Dashboard showing academic momentum and completion progress
- Planner screen for managing all assignments
- Insights screen with completion, in-progress, overdue, and progress statistics
- SDG impact and platform information
- Local browser storage so assignments remain after refresh

## SDG Relevance

This project supports **SDG 4: Quality Education**.

The tracker helps students plan coursework, avoid missed deadlines, develop consistent study habits, and manage academic responsibilities more effectively.

## Project Structure

```text
lib/
  main.dart
  models/
    assignment.dart
  services/
    assignment_storage.dart
  screens/
    home_screen.dart
    planner_screen.dart
    insights_screen.dart
    about_screen.dart
  widgets/
    assignment_card.dart
    stat_card.dart
    sdg_impact_card.dart
```

## Run the Project

Install dependencies:

```bash
flutter pub get
```

Check code quality:

```bash
flutter analyze
flutter test
```

Run the web version:

```bash
flutter run -d web-server --web-port 8080
```

Open the forwarded port `8080` in GitHub Codespaces to view the application.

## Technologies Used

- Flutter
- Dart
- Shared Preferences
- GitHub Codespaces
- GitHub

## Author

24PA1A05G7
