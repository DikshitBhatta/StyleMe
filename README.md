# StyleMe

**StyleMe** is a comprehensive clothing e-commerce application developed as a fourth-semester project by the following group members:

- Dikshit Bhatta
- Prabin Aryal
- Siddhant Adhikari
- Shishir Adhikari

## Project Description

**StyleMe** is a modern e-commerce platform for clothing, designed to provide users with a seamless shopping experience. The application incorporates standard e-commerce functionalities along with innovative features to stand out in the market. Our main focus is on:

### Size Measurement for Users:
Using real-time camera access and OpenCV to capture and process user measurements for accurate size recommendations.

### Virtual Try-On for Clothes:
Enabling users to virtually try on clothes (primarily T-shirts) using advanced machine learning techniques.

## Features

### Core Features:
- **Size Measurement**: Real-time measurement using the device's camera.
- **Virtual Try-On**: Try clothes virtually before making a purchase.

### E-commerce Features:
- **Product Catalog**: Browse through a wide variety of clothing items.
- **Search Functionality**:
  - Text-based search.
  - Voice-based search using integrated voice recognition technology.
- **Payment Gateway Integration**: Secure payment options for hassle-free transactions.
- **Notification System**: Real-time notifications for order updates, offers, and more.
- **Cart Management**: Add, update, or remove items from the cart.
- **Favorites**: Save products for future reference.
- **Product Details Page**: Comprehensive details for each product, including size, material, and more.

### Additional Features:
- User authentication and profile management.
- Order tracking and history.
- Responsive and user-friendly UI/UX.
- Many more features to enhance the shopping experience.

## Technology Stack

### Frontend:
- **Flutter**: For building a responsive and intuitive mobile application.

### Backend:
- **Django**: As the primary backend framework for building robust APIs.
- **Django Rest Framework (DRF)**: For API development.
- **PostgreSQL**: As the database for storing user and product information.

### Machine Learning Models:
- **U2NET**: For cloth segmentation.
- **Graphonomy**: For parsing human body shapes.
- **Mediapipe**: For extracting body measurements.
- **Posenet**: For estimating user poses.
- **Detectron2**: For dense pose estimation.
- **HR-VITON**: For virtual try-on functionality.

### Additional Tools:
- **Firebase**: For authentication and notification services.
- **Khalti and Esewa**: Integrated for payment gateway solutions.

## Repository layout

| Path | What it is |
| --- | --- |
| `stylefront/` | The Flutter app (Android, iOS, web, desktop). |
| `measurement/` | Django + DRF service: a photo plus the user's height in, body measurements and a recommended size out (MediaPipe pose). Runs standalone on SQLite. |
| `styleme/` | Django shop backend and the virtual try-on pipeline (U2NET, Graphonomy, DensePose, HR-VITON). Needs PostgreSQL (`styleme_db`) and the ML checkpoints. |

## Installation and Setup

### 1. Clone

```zsh
git clone https://github.com/DikshitBhatta/StyleMe.git
cd StyleMe
```

### 2. Measurement backend

```zsh
cd measurement
python3 -m venv .venv
./.venv/bin/pip install -r requirements.txt
./.venv/bin/python manage.py migrate
./.venv/bin/python manage.py runserver 8000
```

It serves `POST /api/measurement/live/`, taking `{"image": "<base64 jpeg>", "height": "<cm>"}`
and returning shoulder, chest, waist and inseam measurements with a recommended size.
The whole person must be in frame — a photo cropped at the ankles is rejected.

### 3. Flutter app

```zsh
cd stylefront
flutter pub get
flutter run
```

By default the app talks to the measurement backend on the machine running it
(`10.0.2.2:8000` from an Android emulator, `localhost:8000` everywhere else).
Point it somewhere else — a phone on your LAN, or a deployed host — with:

```zsh
flutter run --dart-define=MEASUREMENT_API=http://192.168.1.20:8000
```

### 4. Try-on pipeline (optional, heavy)

`styleme/` needs PostgreSQL with a `styleme_db` database and the HR-VITON /
Graphonomy / DensePose checkpoints, which are not in the repository.

```zsh
cd styleme
python3 -m venv .venv
./.venv/bin/python manage.py migrate
./.venv/bin/python manage.py runserver 8001
```

## Future Enhancements

- Expand virtual try-on to include more clothing categories.

- AI-driven personalized recommendations.

- Multi-language support.

- Integration with AR for an immersive shopping experience.

- GPU acceleration for faster virtual try-on processing.

## License

This project is developed for academic purposes and is open for contributions. The licensing terms can be updated as per future requirements.

We hope you enjoy using **StyleMe** as much as we enjoyed building it. Feel free to contribute or provide feedback to make it even better!


