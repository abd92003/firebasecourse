# Notes 

A new Flutter project.

🎯 Project Overview:

A Notes Management Application built with Flutter and Firebase, allowing users to create, edit, delete, and organize notes within customizable categories. The app supports image attachments with camera integration and provides a clean, user-friendly experience.

✨ Key Features:
Feature	Description
🔐 Authentication	Email/Password and Google Sign-In with email verification
📂 Categories	Create, edit, and delete categories
📝 Notes Management	Add, edit, and delete notes within categories
📷 Image Upload	Capture photos from camera and upload to Firebase Storage
🗑️ Safe Deletion	Confirmation dialogs to prevent accidental deletion
🚀 Real-time Sync	Firestore real-time data synchronization


Technology	Purpose
Flutter	Cross-platform UI framework
Firebase Auth	User authentication
Cloud Firestore	NoSQL database
Firebase Storage	Image file storage
Image Picker	Camera integration
Awesome Dialog	Beautiful dialogs for success/error messages


📱 Screens:

    Login → User authentication
    SignUp → New account registration
    Homepage → List of all categories
    Add Category → Create new category
    Edit Category → Update category name
    Note View → Display notes within a category
    Add Note → Create new note with optional image
    Edit Note → Update existing note


🎯 Core Features Breakdown:

✅ Authentication

    Email/Password sign-in and registration
    Google Sign-In integration
    Email verification before login

✅ Categories

    Create new categories with unique names
    Edit existing category names
    Long-press to delete with confirmation
    Real-time category list updates

✅ Notes

    Add notes within specific categories
    Option to attach images from camera
    Edit and update existing notes
    Delete notes with confirmation dialog
    View all notes in a clean list format

✅ Image Handling

    Capture images using device camera
    Automatic upload to Firebase Storage
    Display uploaded images in notes
    Loading indicators during upload

✅ User Experience

    Form validation for all inputs
    Loading states for async operations
    Success and error messages using AwesomeDialog
    Responsive and clean Material Design
    Confirmation dialogs for destructive actions


👨‍💻 Development Notes:

    Built with Flutter 3.44.3
    Uses Kotlin Gradle Plugin (KGP) for Android
    Follows Material 3 design guidelines
    Implements clean code architecture
