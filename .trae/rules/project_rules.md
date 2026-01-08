# 🚗 Car Rental App – TRAE Rules File

A cross-platform car rental marketplace where customers can rent cars and owners can list their vehicles.  
Admin dashboard will be added later.

The app follows **Clean Architecture**, uses **BLoC**, and follows a minimal, premium design.

---

## 🚀 Tech Stack

- Flutter  
- Dart  
- BLoC  
- Supabase  
- flutter_platform_widgets  
- go_router (for navigation)
- Clean Architecture  

---

## 🎨 App Theme

### Light Mode

| Token | Value |
|-------|--------|
| Primary | `#3466FF` |
| Primary Light | `#D6E4FF` |
| Background | `#F5F5F5` |
| Surface | `#FEFEFE` |
| Text Primary | `#4B77E4` |
| Text Secondary | `#6C6C80` |
| Border | `#ECECF0` |
| Silver Accent | `#ECECF0` |

### Dark Mode (optional)

- Background: `#0F0F1A`  
- Surface: `#1A1A2E`  
- Text Primary: `#FFFFFF`  
- Text Secondary: `#C9C9D6`  

---

## 🧩 Architecture Rules

Use **Clean Architecture** with the following structure:

```
lib/
  core/
    errors/
    utils/
    theme/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    cars/
      data/
      domain/
      presentation/
    bookings/
      data/
      domain/
      presentation/
    owner/
      data/
      domain/
      presentation/
    profile/
      data/
      domain/
      presentation/
```

### Data Layer
- Supabase APIs (auth, db, storage)  
- DTOs and mappers  
- Repositories  

### Domain Layer
- Entities  
- Repository contracts  
- Use cases  

### Presentation Layer
- Cubits / Blocs  
- Screens using `flutter_platform_widgets`  
- Reusable widgets  

---

## 🔐 Feature Requirements

### Authentication
- Email login  
- Signup with role: **customer** or **owner**  
- Forgot password  
- Persistent session  

### Customer Features
- Home screen: featured cars, categories, search  
- Explore + filters: type, brand, price, transmission, seats  
- Car details page: images, specs, availability  
- Booking flow:
  - Select date range  
  - Select pickup location  
  - Price breakdown  
- Favorites  
- Booking history  
- Edit profile  

### Owner Features
- Owner dashboard  
- Add car listing  
- Upload images → Supabase Storage  
- Edit or disable listing  
- Manage rental requests (approve / reject)  
- Earnings summary  

### Shared Features
- Notifications  
- Settings  
- Logout  

---

## 🧱 UI Rules

### General UI Style
- Clean, minimal, premium look  
- Whites + blue accents  
- Generous spacing  
- Rounded corners (10–14px)  
- Soft shadows  
- Use 'adaptive_platform_ui' for native UX feel  

### Buttons
- Primary: `#3466FF`  
- Secondary: outline (`#ECECF0`)  

### Typography
- SF Pro (iOS)  
- Roboto (Android)  
- H1: 24–28px  
- H2: 18–22px  
- Body: 14–16px  
- Caption: 12–14px  

---

## 🚦 Naming Rules

- Screens → `SomethingScreen`  
- BLoCs/Cubits → `SomethingBloc` / `SomethingCubit`  
- Use cases → verb-first (`CreateBooking`, `GetCarDetails`)  
- Repository implementations → `SomethingRepositoryImpl`  
- Data sources → `SomethingRemoteDataSource`  

---

## 🎯 Final Notes for TRAE

- Respect Clean Architecture boundaries strictly  
- Use BLoC for all logic handling  
- Use platform-native widgets  (if available)
- Stick to the provided color palette  
- Keep UI premium, modern, and minimal  

## Supabase Database Schema
### users
id,uuid,Primary Key
email,varchar,Unique email address
password,varchar,Hashed password
full_name,varchar,
phone,varchar,
profile_image,varchar,URL to storage
created_at,timestamptz,
role,role (enum),"likely 'admin', 'renter', 'customer'"

### cars
id,uuid,Primary Key
owner_id,uuid,Foreign Key -> users.id
title,varchar,
brand,varchar,"e.g., ""Tesla"", ""BMW"""
model,varchar,
year,varchar,
price_per_day,float8,
seats,int4,
gearbox,gearbox (enum),"e.g., 'Automatic', 'Manual'"
fuel_type,fuel_type (enum),"e.g., 'Petrol', 'Electric'"
images,_text (text[]),Array of image URLs
available,bool,
created_at,timestamptz,
max_speed,float8,
total_rating_count,int8,
description,varchar,
rating,float8,Average rating
is_top_deal, bool // True if the images has a thumbnail image picked

### rentals
id,uuid,Primary Key
car_id,uuid,Foreign Key -> cars.id
customer_id,uuid,Foreign Key -> users.id
created_at,timestamptz,
start_date,timestamptz,
end_date,timestamptz,
status,rental_status,"Enum (e.g., 'pending', 'active', 'completed')"
total_price,float8,
pickup_loc,geography,PostGIS geography point
pickup_address,varchar,Human readable address
review_submitted,bool,Default false

### reviews
id,uuid,Primary Key
rental_id,uuid,Foreign Key -> rentals.id
reviewer_id,uuid,Foreign Key -> users.id
car_id,uuid,Foreign Key -> cars.id
rating,int8,
comment,varchar,
created_at,timestamptz,

  
### conversations
| Column | Type | Description |
|--------|------|-------------|
| id | uuid | Primary Key |
| user_1 | uuid | Foreign Key → users.id |
| user_2 | uuid | Foreign Key → users.id |
| updated_at | timestamptz | Updates whenever a new message is sent so the chat 
| user_1_unread_count | int8 | Default 0 |
| user_2_unread_count | int8 | Default 0 |

### messages
id (uuid, PK)
conversation_id (uuid, FK)
sender_id (uuid, FK, nullable) — Null means the "System" sent it.
type (enum: 'text', 'booking_request', 'info')
content (text) — The actual message or a summary like "Booking request for Tesla Model 3".
car_id (uuid, FK, nullable) — Optional: link to the car being discussed.
rental_id (uuid, FK, nullable) — Optional: link to the specific booking to accept/reject.
created_at (timestamptz)