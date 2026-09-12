# Rahala — Travel Booking App

**Rahala** (رحّالة) is a Flutter travel booking application that lets users discover curated trips, save favorites, book seats, and track booking status — while admins manage trips, categories, statistics, and booking approvals from a dedicated dashboard.

| | |
|---|---|
| **Package name** | `travel_app` |
| **Android applicationId** | `com.rehala.travel` |
| **API base URL** | `https://rahala.duckdns.org/api/v1/` |
| **Platforms** | Android / iOS (Flutter) |
| **Languages** | Arabic & English (`easy_localization`) |
| **Default locale** | Arabic (`ar`) |

---

## Table of contents

1. [App idea](#app-idea)
2. [Architecture](#architecture)
3. [Project structure](#project-structure)
4. [Core layer (`lib/core`)](#core-layer-libcore)
5. [User features](#user-features)
6. [Admin features](#admin-features)
7. [API endpoints](#api-endpoints)
8. [Routing map](#routing-map)
9. [Tech stack](#tech-stack)
10. [App bootstrap](#app-bootstrap)
11. [Getting started](#getting-started)

---

## App idea

Rahala is a **two-sided travel product**:

### For travelers (user side)
- Browse published trips with prices, dates, seats, itineraries, and media
- Explore trips by category
- Save / remove trips from favorites
- Create a booking (seats + optional notes)
- View “My Bookings” with status filters
- Open full booking details after creating or from the list
- Sign in with email/password or Google
- Switch UI language (AR / EN)

### For operators (admin side)
- View platform statistics (users, trips, bookings, financials)
- List and filter all trips (published / unpublished / draft)
- Create a new trip through a multi-step form (basic info → price/dates → media/services → itinerary)
- Review booking requests and **approve** or **reject** them
- Jump between admin dashboard and the user home experience

---

## Architecture

The codebase follows a **Feature-First Clean Architecture** style.

### Layers inside each feature

```
feature_name/
├── data/
│   ├── models/          # API JSON ↔ Dart models
│   └── repo/            # Abstract repository + implementation
└── presentation/
    ├── cubit/           # Business logic + states (flutter_bloc)
    ├── pages/           # Screens
    └── widgets/         # Feature-specific UI pieces
```

### Data flow

```
UI (Page / Widget)
        ↓
    Cubit / States
        ↓
  Repository (abstract)
        ↓
Repository Implementation
        ↓
ApiConsumer (Dio)  →  Backend API
        ↓
Either<Failure, Success>   (dartz)
        ↓
Emit State → rebuild UI
```

### Design principles used
- **Feature-first folders** — each domain lives under `lib/features/...`
- **Repository pattern** — UI never talks to Dio directly
- **Cubit + Equatable states** — predictable state management
- **GetIt DI** — register networking, repos, and cubits once
- **Either / Failure** — errors mapped to typed failures for the UI
- **Secure token storage** — access/refresh tokens + user JSON
- **Shared core** — theme, networking, routing, validators, shared widgets

### Shared trip model note
The main trip entity used across Home, Explore, Favorites, Trip Details, and Create Booking is `AdminTripModel` (defined under admin trips models). Despite the name, it is the **shared trip model** for the whole app.

---

## Project structure

```
lib/
├── main.dart                 # Firebase, localization, DI, runApp
├── app.dart                  # MaterialApp.router + ScreenUtil + theme
├── core/                     # Shared infrastructure
└── features/
    ├── user/
    │   ├── splash/
    │   ├── auth/
    │   ├── home/
    │   ├── explore/
    │   ├── favorites/
    │   ├── user_booking/
    │   ├── profile/
    │   ├── settings/
    │   └── not_found/
    └── admin/
        ├── dashboard/
        ├── trips/
        └── bookings/

assets/
├── translations/
│   ├── ar.json
│   └── en.json
└── images/                   # logos, splash, placeholders, destinations
```

---

## Core layer (`lib/core`)

Everything reusable across features lives here.

### `core/constants/`
| File | Purpose |
|------|---------|
| `app_strings.dart` | Centralized localized string getters (`.tr()` keys) |
| `app_colors.dart` | Brand palette (navy primary, amber secondary, status colors) |
| `app_assets.dart` | Paths to image/icon assets |
| `app_cities.dart` | Egypt cities list (API values + Arabic labels) used in add-trip forms |

### `core/di/`
| File | Purpose |
|------|---------|
| `dependency_injection.dart` | GetIt setup: secure storage, network, Dio, all repos & cubits. `FavoritesCubit` and `UserBookingCubit` are **lazy singletons**; most other cubits are **factories**. |

### `core/errors/`
| File | Purpose |
|------|---------|
| `failure.dart` | Failure types (`ServerFailure`, `NetworkFailure`, `AuthFailure`, `UnexpectedFailure`, …) |
| `failure_mapper.dart` | Maps thrown exceptions → `Failure` |
| `exceptions.dart` | App-level exception types |
| `dio_exceptions.dart` | Dio-specific error handling |
| `error_model.dart` | Backend error payload shape |

### `core/extensions/`
| File | Purpose |
|------|---------|
| `extensions.dart` | Barrel export |
| `build_context_extension.dart` | Context helpers |
| `num_extension.dart` | Spacing helpers on numbers |
| `string_extension.dart` | String utilities |
| `widget_extension.dart` | Widget helpers (padding, centering, etc.) |

### `core/helper/`
| File | Purpose |
|------|---------|
| `app_validation/validation.dart` | `AppValidator` (email, password, phone, name, confirm password) |
| `app_validation/validation_message_mapper.dart` | Maps validation results → localized messages |
| `cache/secure_storage_caching.dart` | Save/read tokens + user; `isLoggedIn()` |
| `cache/secure_storage_keys.dart` | Keys: `access_token`, `refresh_token`, `user` |

### `core/networking/`
| File | Purpose |
|------|---------|
| `end_points.dart` | Base URL + every API path |
| `api_consumer.dart` | Abstract HTTP contract (`get` / `post` / `patch` / …) |
| `dio_consumer.dart` | Dio implementation + connectivity gate |
| `dio_factory.dart` | Creates configured Dio (timeouts, logger in debug) |
| `api_interceptor.dart` | Attaches Bearer token, `Accept-Language: ar`, refreshes token on 401 |
| `internet_checker/network_info.dart` | Abstract connectivity |
| `internet_checker/network_info_impl.dart` | Uses `internet_connection_checker_plus` |

### `core/router/`
| File | Purpose |
|------|---------|
| `route_names.dart` | All route path constants + helpers (e.g. `bookingDetailsPath`) |
| `app_router.dart` | `GoRouter` definition, `BlocProvider`s per route, `errorBuilder` → Not Found |

### `core/services/`
| File | Purpose |
|------|---------|
| `google_service.dart` | Google Sign-In + Firebase Auth credential flow (`signInWithGoogle` / `signOut`) |

### `core/shared/widgets/`
| File | Purpose |
|------|---------|
| `app_button.dart` | Primary app button |
| `app_text_field.dart` | Styled text field |
| `app_loading.dart` | Loading indicator |
| `app_shimmer.dart` | Shimmer wrapper |
| `app_snackbar.dart` | Success / error snackbars |
| `app_dialog.dart` | Shared dialogs |
| `app_network_image.dart` | Cached network image helper |

### `core/theme/`
| File | Purpose |
|------|---------|
| `app_theme.dart` | Material 3 light & dark themes (app currently forces light mode) |
| `app_text_styles.dart` | Typography (Google Fonts) |
| `app_sizes.dart` | ScreenUtil-aware paddings, radii, icon/button sizes |

---

## User features

### 1. Splash (`features/user/splash`)
**What it does:** Branded splash screen. After ~2 seconds it checks secure storage for login state and user role, then navigates to Login, Home, or Admin Dashboard.

| Type | Details |
|------|---------|
| Page | `splash_page.dart` |
| Cubit / Repo | None (logic is local in the page) |

---

### 2. Auth (`features/user/auth`)
**What it does:** Full authentication for email/password and Google.

| Page | What it does |
|------|--------------|
| `login_page.dart` | Email + password login, Google sign-in; routes **admin → dashboard**, **user → home** |
| `register_page.dart` | Full name, email, phone, password, confirm password, optional profile image |

| Cubit methods (`AuthCubit`) | Description |
|-----------------------------|-------------|
| `login({email, password})` | Email/password login |
| `register({request})` | Register with optional image |
| `signInWithGoogle()` | Google → backend `auth/google` |

| Repo APIs | Endpoint |
|-----------|----------|
| Login | `POST auth/login` (stores tokens + user) |
| Register | `POST auth/register` (multipart FormData) |
| Google | `POST auth/google` with `{ idToken }` |

| Widgets | Purpose |
|---------|---------|
| `social_auth_buttons.dart` | Google button (and related social/admin entry UI) |
| `profile_avatar_picker.dart` | Pick avatar from camera/gallery on register |

| Models | Purpose |
|--------|---------|
| `login_response_model.dart` | Tokens + user + role |
| `register_request_model.dart` | Registration payload |
| `register_response_model.dart` | Register success payload |

---

### 3. Home (`features/user/home`)
**What it does:** Main user shell after login — bottom navigation + trip discovery + trip details.

| Page / Tab | What it does |
|------------|--------------|
| `home_page.dart` | Bottom nav shell (`IndexedStack`): Home · Notifications · Bookings · Profile. Listens for favorite-toggle snackbars |
| `tabs/home_tab.dart` | Feed: header, offers carousel, categories, popular trips, promo; loads `HomeCubit` + `CategoriesCubit` |
| `tabs/notifications_tab.dart` | **Mock UI only** — static notifications, no API |
| `tabs/bookings_tab.dart` | Embeds `MyBookingsPage` from `user_booking` |
| `trip_details_page.dart` | Full trip page: image carousel, overview/itinerary/included/excluded/gallery/reviews tabs, favorite heart, sticky “Book Now” → create booking |

| Cubit methods (`HomeCubit`) | Description |
|-----------------------------|-------------|
| `loadHome()` | Loads trips + offers in parallel |
| `getTrips()` / `fetchMoreTrips()` | Paginated trips |
| `getOffers()` | Active offers |

| Repo APIs | Endpoint |
|-----------|----------|
| Trips | `GET trips?page&limit&sort` |
| Offers | `GET offers` |

| Widgets | Purpose |
|---------|---------|
| `home_header_widget.dart` | Greeting / search chrome |
| `home_featured_banner_widget.dart` | Offers carousel |
| `home_categories_widget.dart` | Category chips → Explore with slug |
| `home_popular_destinations_widget.dart` | Popular trip cards |
| `home_promo_banner_widget.dart` | Promo CTA |
| `home_shimmer_loading.dart` | Home skeleton |
| `trip_details_image_carousel.dart` | Hero images |
| `trip_details_header_info.dart` | Title / price / meta |
| `trip_details_features_grid.dart` | Duration / capacity / seats chips |
| `trip_details_sections.dart` | Tab contents |
| `trip_details_sticky_footer.dart` | Price + Book Now |

| Models | Purpose |
|--------|---------|
| `offer_model.dart` | Offers response + offer/trip nested models |

---

### 4. Explore (`features/user/explore`)
**What it does:** Browse trips filtered by category, with infinite scroll and a pinned category header. Supports optional `?category=` query from Home.

| Cubit methods (`ExploreCubit`) | Description |
|--------------------------------|-------------|
| `getTripsFiltered(category, …)` | Fetch/filter trips (per-category cache) |
| `loadMoreTrips()` | Pagination |

| Repo API | Endpoint |
|----------|----------|
| Filtered trips | `GET trips?category&page&limit` |

| Widgets | Purpose |
|---------|---------|
| `explore_scroll_intro.dart` | Intro title/subtitle |
| `explore_categories_bar.dart` | Category chips |
| `explore_categories_pinned_header.dart` | Pinned header while scrolling |
| `explore_trips_list.dart` | Paginated list |
| `explore_trip_card.dart` | Trip card + favorite |
| `explore_shimmer_loading.dart` | Loading skeleton |

---

### 5. Favorites (`features/user/favorites`)
**What it does:** List saved trips, toggle favorite from many screens (Explore, Home cards, Trip Details, Favorites list). Cubit is a **shared singleton**.

| Page | What it does |
|------|--------------|
| `favorites_page.dart` | Paginated favorites with pull-to-refresh & load more |

| Cubit methods (`FavoritesCubit`) | Description |
|----------------------------------|-------------|
| `getFavorites()` / `loadMoreFavorites()` | List favorites |
| `toggleFavoriteTrip(trip)` | Add/remove favorite |
| `isFavorite` / `isToggling` | UI helpers for heart state |

| Repo APIs | Endpoint |
|-----------|----------|
| List | `GET favorites?page&limit` |
| Toggle | `POST favorites/toggle/{tripId}` |

| Widgets | Purpose |
|---------|---------|
| `favorites_header.dart` | Title + count |
| `favorites_list.dart` | Scroll list |
| `favorite_card.dart` | Favorite trip card |
| `trip_favorite_button.dart` | Reusable heart button |
| `favorites_empty_view.dart` | Empty state |
| `favorites_error_view.dart` | Error + retry |
| `favorites_shimmer_loading.dart` | Skeleton |

| Models | Purpose |
|--------|---------|
| `favorite_model.dart` | Favorites page data + toggle response (items are `AdminTripModel`) |

---

### 6. User Booking (`features/user/user_booking`)
**What it does:** Complete booking lifecycle for the traveler — create booking, list bookings, view details.

| Page | What it does |
|------|--------------|
| `create_booking_page.dart` | Seats stepper, notes, price summary, confirm. On success → **booking details** |
| `my_bookings_page.dart` | My bookings list + filters (all / approved / pending / cancelled|rejected) + pagination |
| `booking_details_page.dart` | Fetches booking by id; hero, ticket card, trip section, notes/rejection/cancellation |

| Cubit methods (`UserBookingCubit`) | Description |
|------------------------------------|-------------|
| `getUserBookings()` / `loadMoreUserBookings()` | Paginated my bookings |
| `createUserBooking(...)` | Create booking (`tripId`, seats, notes, optional coupon) |
| `getUserBookingById(id)` | Fetch single booking details |
| `restoreBookingsListState()` | Restore list success state after leaving details |

| Repo APIs | Endpoint |
|-----------|----------|
| My bookings | `GET bookings/my?page&limit` |
| Create | `POST bookings` |
| Details | `GET bookings/{bookingId}` |

| Widgets | Purpose |
|---------|---------|
| `user_booking_list_card.dart` | Booking list card |
| `user_bookings_filters.dart` | Status filter chips |
| `user_bookings_empty_error.dart` | Empty + error views |
| `user_bookings_shimmer_loading.dart` | List skeleton |
| `create_booking_trip_card.dart` | Trip summary on create screen |
| `create_booking_seats_stepper.dart` | Seat counter |
| `create_booking_notes_field.dart` | Notes input |
| `create_booking_price_summary.dart` | Price breakdown |
| `create_booking_bottom_bar.dart` | Confirm CTA |
| `booking_details_hero.dart` | Cover + status + route |
| `booking_details_ticket_card.dart` | Ticket-style booking data |
| `booking_details_trip_section.dart` | Trip meta section |
| `booking_details_notes_section.dart` | Notes / rejection / cancellation |
| `booking_details_shimmer.dart` | Details skeleton |

| Models | Purpose |
|--------|---------|
| `UserBookingsResponseModel` / `UserBookingsPageData` | List + pagination |
| `CreateUserBookingResponseModel` | Create response |
| `UserBookingDetailsResponseModel` | Details response |
| `UserBookingModel` (+ user / trip / snapshot) | Booking entity |

---

### 7. Profile (`features/user/profile`)
**What it does:** Account tab inside Home shell — menu entries (e.g. Favorites, Settings) and logout UI.

| Page | What it does |
|------|--------------|
| `profile_tab.dart` | Main profile UX inside bottom nav |
| `profile_page.dart` | Lightweight stub screen for `/profile` route |

| Widgets | Purpose |
|---------|---------|
| `profile_menu_item_widget.dart` | Menu row (Material + ListTile) |

Cubit / Repo: **none** (local UI for now).

---

### 8. Settings (`features/user/settings`)
**What it does:** Placeholder settings screen (title scaffold). Routed at `/settings`.

Cubit / Repo / Widgets: **none** yet.

---

### 9. Not Found (`features/user/not_found`)
**What it does:** 404 / invalid-route screen. Used as GoRouter `errorBuilder` and when route extras are invalid (e.g. missing trip for create booking).

| Page | `not_found_page.dart` |

---

## Admin features

### 1. Dashboard (`features/admin/dashboard`)
**What it does:** Admin home — platform stats and quick actions (manage trips, manage bookings, add trip, switch to user home).

| Cubit | `getAdminStats()` |
| Repo | `GET admin/stats` |
| Widget | `admin_stat_card.dart` |
| Models | `admin_dashboard_stats_model.dart` (users, trips, bookings, financials, top trips, …) |

---

### 2. Trips (`features/admin/trips`)
**What it does:** Admin trip catalog + create-trip wizard + categories (also reused by user Home/Explore).

| Page | What it does |
|------|--------------|
| `admin_trips_page.dart` | List trips with status filters + pagination + navigate to add trip |
| `add_trip_page.dart` | 4-step stepper: basic info → price/dates → media/services → itinerary → publish |

| Cubits | Methods |
|--------|---------|
| `AdminTripsCubit` | `getAdminTrips`, `loadMore`, `updateStatus` |
| `AdminTripManagerCubit` | `addTrip(request, {coverImage, gallery})` |
| `CategoriesCubit` | `getCategories()` (active categories only) — shared with user side |

| Repo APIs | Endpoint |
|-----------|----------|
| Admin trips list | `GET trips/admin/all?page&limit&status?` |
| Create trip | `POST trips` (JSON or multipart with images) |
| Categories | `GET categories` |

| Widgets | Purpose |
|---------|---------|
| `admin_trip_card.dart` | Admin trip card |
| `add_trip_stepper_header.dart` | Step indicator |
| `add_trip_step1_basic_info.dart` | Title, description, category, origin/destination |
| `add_trip_step2_price_dates.dart` | Price, capacity, dates |
| `add_trip_step3_media_services.dart` | Cover/gallery, included/excluded |
| `add_trip_step4_itinerary.dart` | Days & activities builder |
| `add_trip_bottom_action_bar.dart` | Prev / Next / Publish |

| Models | Purpose |
|--------|---------|
| `admin_trips_model.dart` | **`AdminTripModel`** (shared app-wide) + pagination |
| `categories_response_model.dart` | `CategoryModel` |
| `add_trip_request_model.dart` | Create trip request + days/activities |
| `add_trip_response_model.dart` | Create trip response |

---

### 3. Bookings (`features/admin/bookings`)
**What it does:** Review customer booking requests; approve or reject.

| Page | What it does |
|------|--------------|
| `admin_bookings_page.dart` | Bookings list, status/trip filters, infinite scroll |
| `admin_booking_details_page.dart` | Booking detail (from `extra`), customer/trip/notes, approve/reject |

| Cubit methods (`AdminBookingCubit`) | Description |
|-------------------------------------|-------------|
| `getAdminBookings()` / `loadMore()` | Paginated list |
| `selectTrip` / `selectStatus` | Client-side filters |
| `approveBooking(id)` / `rejectBooking(id)` | Decision actions |

| Repo APIs | Endpoint |
|-----------|----------|
| List | `GET bookings?page&limit&status?` |
| Approve | `PATCH bookings/{id}/approve` |
| Reject | `PATCH bookings/{id}/reject` |

| Widgets | Purpose |
|---------|---------|
| `admin_bookings_app_bar.dart` | App bar |
| `admin_bookings_body.dart` | Body layout |
| `admin_bookings_list.dart` | List |
| `admin_bookings_status_filters.dart` | Status chips |
| `admin_bookings_trip_filter.dart` | Trip filter |
| `admin_booking_card.dart` | Card with actions |
| `admin_bookings_error_view.dart` | Error UI |

| Models | Purpose |
|--------|---------|
| `admin_booking_model.dart` | Admin booking + nested user/trip/snapshot + pagination |

---

## API endpoints

Base: `https://rahala.duckdns.org/api/v1/`

| Feature | Method | Path |
|---------|--------|------|
| Login | `POST` | `auth/login` |
| Register | `POST` | `auth/register` |
| Google login | `POST` | `auth/google` |
| Refresh token | `POST` | `auth/refresh-token` |
| Admin stats | `GET` | `admin/stats` |
| Admin trips | `GET` | `trips/admin/all` |
| Categories | `GET` | `categories` |
| Create trip | `POST` | `trips` |
| Public trips | `GET` | `trips` |
| Active offers | `GET` | `offers` |
| Favorites list | `GET` | `favorites` |
| Toggle favorite | `POST` | `favorites/toggle/{tripId}` |
| Create booking | `POST` | `bookings` |
| My bookings | `GET` | `bookings/my` |
| Booking details | `GET` | `bookings/{bookingId}` |
| Admin bookings | `GET` | `bookings` |
| Approve booking | `PATCH` | `bookings/{id}/approve` |
| Reject booking | `PATCH` | `bookings/{id}/reject` |

---

## Routing map

| Path | Screen |
|------|--------|
| `/` | Splash |
| `/login` | Login |
| `/register` | Register |
| `/home` | User home shell |
| `/explore` | Explore trips |
| `/trip-details` | Trip details (`extra`: `AdminTripModel`) |
| `/favorites` | Favorites |
| `/booking-confirmation` | Create booking (`extra`: trip) |
| `/booking-details/:bookingId` | User booking details |
| `/profile` | Profile stub |
| `/settings` | Settings stub |
| `/admin-dashboard` | Admin dashboard |
| `/admin-trips` | Admin trips list |
| `/add-trip` | Add trip wizard |
| `/admin-bookings` | Admin bookings list |
| `/admin-booking-details` | Admin booking details |

---

## Tech stack

| Area | Package / tool | How it’s used |
|------|----------------|---------------|
| Framework | Flutter (Dart 3) | App framework |
| State management | `flutter_bloc` + `equatable` | Cubits & states |
| Navigation | `go_router` | Declarative routes |
| Networking | `dio` + `pretty_dio_logger` | REST + debug logs |
| DI | `get_it` | Service locator |
| Error handling | `dartz` | `Either<Failure, T>` |
| Secure storage | `flutter_secure_storage` | Tokens + user |
| Connectivity | `internet_connection_checker_plus` | Offline checks |
| Localization | `easy_localization` | AR / EN JSON |
| Auth | `firebase_core`, `firebase_auth`, `google_sign_in` | Google login |
| Responsive UI | `flutter_screenutil` | Design size `375×812` |
| Typography | `google_fonts` | Text styles |
| Images | `cached_network_image`, `image_picker` | Network images + local picks |
| Loading UX | `shimmer` | Skeletons |
| Carousels | `carousel_slider`, `smooth_page_indicator` | Offers / galleries |

---

## App bootstrap

### `main.dart`
1. Ensure Flutter bindings
2. Initialize **Firebase**
3. Initialize **EasyLocalization** (`ar` + `en`, path `assets/translations`, default `ar`)
4. Call **`setupGetIt()`**
5. `runApp` wrapped with `EasyLocalization`

### `app.dart`
1. **ScreenUtilInit** (`375×812`)
2. `MaterialApp.router` with localization delegates
3. Light / dark themes from `AppTheme` (currently **`ThemeMode.light`**)
4. Router: `AppRouter.router`

---

## Getting started

### Requirements
- Flutter SDK `^3.12`
- Firebase configured for Android/iOS (needed for Google Sign-In)

### Run

```bash
git clone <repo-url>
cd travel_app
flutter pub get
flutter run
```

### Useful paths for developers
| Concern | Path |
|---------|------|
| DI registration | `lib/core/di/dependency_injection.dart` |
| Routes | `lib/core/router/` |
| Endpoints | `lib/core/networking/end_points.dart` |
| Translations | `assets/translations/ar.json`, `en.json` |
| Theme | `lib/core/theme/` |

---

## Current limitations (honest status)

- **Notifications tab** is mock UI only (no backend).
- **Settings page** and standalone **Profile page** are stubs; primary profile UX is `ProfileTab`.
- Trip **update/delete** in admin manager cubit are stubbed/commented.
- Legacy UI still exists under `lib/features/user/bookings/` (old confirmation/details/cards). The **active** booking flow is `lib/features/user/user_booking/`; Home’s Bookings tab embeds `MyBookingsPage` from there.
- Material app title may still show a starter placeholder in some places; product brand is **Rahala**.

---

## License

Educational / portfolio project — usage as defined by the repository owner.
