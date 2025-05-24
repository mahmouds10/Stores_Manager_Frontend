# Stores list

``` 
lib/
├── cubits/
│   ├── auth/
│   │   ├── auth_cubit.dart
│   │   └── auth_state.dart
│   ├── store/
│   │   ├── store_cubit.dart
│   │   └── store_state.dart
│   ├── product/
│   │   ├── product_cubit.dart
│   │   └── product_state.dart
│   └── search/
│       ├── search_cubit.dart
│       └── search_state.dart
├── models/
│   ├── user_model.dart
│   ├── store_model.dart
│   └── product_model.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── product_list_screen.dart
│   └── search_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── store_service.dart
│   ├── product_service.dart
│   └── search_service.dart
├── main.dart
└── app.dart
```

---

## 📁 `lib/` — Overview

### 📁 `cubits/`
Contains state management logic using Cubit for different app features.

- **auth/** – Login & Register logic.
- **store/** – Manages store-related data.
- **product/** – Handles product listing per store.
- **search/** – Handles search functionality and results.

### 📁 `models/`
Data models for user, store, and product.

### 📁 `screens/`
All UI screens and user interactions.

### 📁 `services/`
Handles HTTP API calls separated by domain.

### 📄 `main.dart`
App entry point and Cubit initialization.

### 📄 `app.dart`
Manages routes and navigation.

---

## ✅ App Features

- **Register:** New users can register with required details.
- **Login:** Authenticate users and store session data.
- **Store Listing:** Show all stores (cafes/restaurants).
- **Product Listing:** Display products per store.
- **Search Products:** Find stores by a specific product.

---

Would you like me to generate a downloadable `.md` file for this?

