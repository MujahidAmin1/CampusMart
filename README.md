# CampusMart

CampusMart is a mobile marketplace application built for university students at Bayero University Kano (BUK). It enables students to list, discover, and purchase second-hand or new items within the campus community, with integrated payment processing and a full order management workflow.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Firebase Setup](#firebase-setup)
  - [Cloudinary Setup](#cloudinary-setup)
  - [Running the App](#running-the-app)
- [Data Models](#data-models)
- [Order Lifecycle](#order-lifecycle)
- [Environment Notes](#environment-notes)

---

## Overview

CampusMart connects buyers and sellers within a campus environment. Students can create product listings across multiple categories, browse and filter available items, place orders, and pay securely via Paystack. Sellers receive real-time notifications as orders progress, and an admin approval layer ensures listing quality before items go live.

---

## Features

### Authentication
- Email and password registration with student registration number capture
- Email and password login with descriptive error handling
- Persistent session management via Firebase Auth state streams
- Sign out with full provider state invalidation

### Product Listings
- Create listings with title, description, price, category, and multiple images
- Images are uploaded to Cloudinary and stored as CDN URLs
- Admin approval required before a listing becomes publicly visible
- Category filtering across: Electronics, Fashion, Furniture, Academics, Sports, Gadgets, and Others
- Price range filtering via a modal bottom sheet
- Pull-to-refresh on the listings grid
- Edit and delete your own listings from the profile screen

### Search
- Full-text search across product title, description, and category
- Real-time results as the user types

### Orders
- Place an order directly from a product detail screen
- Separate buyer and seller order views in a unified orders tab
- Order detail screen with a visual timeline of status progression
- Seller can confirm shipping; buyer can confirm collection
- Product availability is automatically set to unavailable once an order is created

### Payments
- Paystack integration for in-app payment processing (NGN)
- Payment reference stored against the order record
- Payment confirmation screen after successful transaction

### Notifications
- Real-time in-app notifications for order events: new order, payment received, shipped, collected, completed, and payment released
- Unread count badge on the navigation bar
- Mark individual notifications as read or mark all as read
- Delete individual notifications

### Profile
- View and edit display name and profile picture
- Profile picture upload via Cloudinary
- View all your active listings
- View items you have paid for (as a seller)
- Browse another user's public profile and their listings

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart SDK >= 3.10.0) |
| State Management | Riverpod 2 (flutter_riverpod) |
| Backend / Database | Firebase (Firestore, Firebase Auth, Firebase Storage) |
| Image Hosting | Cloudinary |
| Payments | Paystack (pay_with_paystack) |
| Image Picker | image_picker |
| Notifications | In-app via Firestore streams |
| UI Icons | iconsax_flutter |
| Utilities | intl, uuid, url_launcher, dotted_border, another_flushbar |

---

## Architecture

The project follows a feature-first layered architecture:

```
feature/
  controller/   - Riverpod StateNotifier and Provider definitions
  repository/   - Firestore and external service calls
  view/         - Screen widgets
  widget/       - Reusable UI components scoped to the feature
```

Each feature is self-contained. Shared infrastructure (Firebase instances, Cloudinary service, global providers) lives in `lib/core/`. Data models are in `lib/models/`.

State is managed entirely through Riverpod providers. Repositories are injected into controllers via providers, making the dependency graph explicit and testable. Streams are used throughout for real-time Firestore updates.

---

## Project Structure

```
lib/
  core/
    providers.dart          # Global Firebase and service providers
    cloudinary_img_upl.dart # Cloudinary upload service
    img_picker.dart         # Image picker helper
    loading_screen.dart     # Shared loading widget
    bucket_ids.dart         # Storage bucket constants
    utils/
      extensions.dart       # Navigator extension helpers
      ktextstyle.dart       # Text style helpers
      my_colors.dart        # App color constants
      price_format.dart     # Currency formatting
  features/
    auth/                   # Registration, login, logout
    bottomNavBar/           # Navigation shell and tab controller
    listings/               # Product browsing, creation, editing
    notification/           # In-app notification feed
    orders/                 # Order placement, tracking, detail
    payment/                # Paystack payment flow
    profile/                # User profile, my listings, edit profile
    search/                 # Product search
  models/
    user.dart
    product.dart
    order.dart
    app_notification.dart
    reviews.dart
  firebase_options.dart
  main.dart
```

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.10.0
- Dart SDK >= 3.10.0
- A Firebase project with Firestore, Firebase Auth, and Firebase Storage enabled
- A Cloudinary account
- A Paystack account (test or live)

### Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
2. Enable **Email/Password** authentication under Authentication > Sign-in method.
3. Create a **Firestore** database and set up the following collections:
   - `users`
   - `products`
   - `orders`
   - `notifications` (subcollection per user: `users/{uid}/notifications`)
4. Run the FlutterFire CLI to generate `lib/firebase_options.dart`:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`.

### Cloudinary Setup

1. Create a Cloudinary account at [cloudinary.com](https://cloudinary.com).
2. Note your **Cloud Name**, **API Key**, and **API Secret**.
3. Update the `cloudinaryServiceProvider` in `lib/core/providers.dart` with your credentials.

> The app uploads product images to a `products/` folder in your Cloudinary media library using signed uploads.

### Paystack Setup

1. Obtain your secret key from the [Paystack dashboard](https://dashboard.paystack.com).
2. Replace the `secretKey` value in `lib/features/payment/payment_service.dart` with your key.
3. Update the `callbackUrl` to a valid endpoint for your environment.

> Use test keys during development. Switch to live keys only for production builds.

### Running the App

```bash
# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Build a release APK
flutter build apk --release
```

---

## Data Models

### User
| Field | Type | Description |
|---|---|---|
| id | String | Firebase Auth UID |
| username | String | Display name |
| email | String | Email address |
| regNo | String | Student registration number |
| userType | UserType | `student` or `admin` |
| profilePic | String? | Cloudinary image URL |
| address | String? | Delivery address |
| bio | String? | Short bio |

### Product
| Field | Type | Description |
|---|---|---|
| productId | String | UUID |
| ownerId | String | Seller's UID |
| title | String | Listing title |
| description | String | Listing description |
| price | double | Price in NGN |
| category | String | One of the defined Category enum values |
| isAvailable | bool | False once an order is placed |
| isApproved | bool | Must be true for the listing to appear publicly |
| datePosted | DateTime | Creation timestamp |
| imageUrls | List\<String\> | Cloudinary CDN URLs |

### Order
| Field | Type | Description |
|---|---|---|
| orderId | String | UUID |
| productId | String | Reference to the product |
| buyerId | String | Buyer's UID |
| sellerId | String | Seller's UID |
| amount | double | Order total in NGN |
| status | OrderStatus | See order lifecycle below |
| orderDate | DateTime | Order creation timestamp |
| deliveryAddress | String | Delivery or pickup address |
| paymentId | String? | Paystack transaction reference |
| isShippingConfirmed | bool | Set by seller |
| hasCollectedItem | bool | Set by buyer |
| receivedAt | DateTime? | Timestamp when item was collected |

### Product Categories

`electronics`, `fashion`, `furniture`, `academics`, `sports`, `gadgets`, `others`

---

## Order Lifecycle

```
pending -> processing -> paid -> shipped -> collected -> completed
                                                      -> cancelled
```

| Status | Meaning |
|---|---|
| pending | Order created, awaiting payment |
| processing | Payment initiated |
| paid | Payment confirmed by Paystack |
| shipped | Seller has confirmed dispatch |
| collected | Buyer has confirmed receipt |
| completed | Transaction fully closed |
| cancelled | Order was cancelled |

---

## Environment Notes

- The app targets Android and iOS. Web, Linux, macOS, and Windows runner scaffolding is present but not the primary deployment target.
- All Firestore queries that require composite indexes (e.g., filtering by `sellerId` and `status`) may need corresponding indexes created in the Firebase console on first run.
- Product listings only appear in the public feed when both `isAvailable` and `isApproved` are `true`. Admin approval must be set manually in Firestore or via a separate admin interface.
- Credentials (Cloudinary API secret, Paystack secret key) are currently embedded in source. Before any public or production deployment, move these to environment variables or a secrets manager and exclude them from version control.
