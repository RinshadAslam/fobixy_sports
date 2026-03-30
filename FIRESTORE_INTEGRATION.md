# Fobixy Sports - Firestore User Data Storage

## Overview

This document describes the Firestore integration for user data storage in the Fobixy Sports Flutter app.

## Firestore Structure

### Users Collection

**Collection Path:** `/users`

**Document ID:** Firebase Authentication User UID (unique identifier)

**Document Structure:**
```json
{
  "userId": "firebase-auth-uid",
  "name": "User's Full Name",
  "email": "user@example.com",
  "createdAt": "Firestore Server Timestamp",
  "favoriteTeams": ["Team A", "Team B"],
  "profileImage": "https://example.com/image.jpg" | null,
  "isEmailVerified": true | false
}
```

## Data Flow

### User Signup Process

1. **User Input**: User enters name, email, and password
2. **Firebase Auth**: Create account with email/password
3. **Success Check**: Verify account creation was successful
4. **Firestore Storage**: Save user profile data
5. **Email Verification**: Send verification email
6. **UI Feedback**: Show success/error messages

### Error Handling

- **Authentication Errors**: Invalid email, weak password, email already in use
- **Firestore Errors**: Network issues, permission denied, document conflicts
- **Recovery**: Clean up orphaned accounts if Firestore write fails

## Security Rules

See `firestore.rules` for comprehensive security configuration:

- Users can only read/write their own documents
- Authenticated users can read public data
- Admin operations require special permissions

## API Methods

### AuthService Methods

```dart
// Sign up with complete profile creation
Future<UserCredential> signUp({
  required String name,
  required String email,
  required String password,
});

// Update user profile data
Future<void> updateUserData(String uid, Map<String, dynamic> data);

// Manage favorite teams
Future<void> addFavoriteTeam(String uid, String teamName);
Future<void> removeFavoriteTeam(String uid, String teamName);

// Update profile image
Future<void> updateProfileImage(String uid, String imageUrl);
```

## UI Integration

### Loading States
- Show loading indicator during signup process
- Prevent multiple submissions
- Clear feedback on completion

### Error Messages
- Specific error messages for different failure types
- User-friendly language
- Retry options where appropriate

### Success Feedback
- Confirmation of account creation
- Instructions for email verification
- Automatic navigation to next step

## Best Practices

1. **Data Validation**: Validate all inputs before Firestore operations
2. **Error Recovery**: Handle partial failures gracefully
3. **Security**: Never store passwords in Firestore
4. **Performance**: Use appropriate indexes for queries
5. **Offline Support**: Consider offline data handling

## Future Enhancements

- User preferences storage
- Favorite matches tracking
- Social features (following users)
- Advanced profile customization
- Data migration tools