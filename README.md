#Style Me

Style Me is a comprehensive clothing e-commerce application developed as a fourth-semester project by the following group members:

Dikshit Bhatta

Prabin Aryal

Siddhant Adhikari

Shishir Adhikari

#Project Description

Style Me is a modern e-commerce platform for clothing, designed to provide users with a seamless shopping experience. The application incorporates standard e-commerce functionalities along with innovative features to stand out in the market. Our main focus is on:

Size Measurement for Users:

Using real-time camera access and OpenCV to capture and process user measurements for accurate size recommendations.

Virtual Try-On for Clothes:

Enabling users to virtually try on clothes (primarily T-shirts) using advanced machine learning techniques.

#Features

Core Features:

Size Measurement: Real-time measurement using the device's camera.

Virtual Try-On: Try clothes virtually before making a purchase.

E-commerce Features:

Product Catalog: Browse through a wide variety of clothing items.

Search Functionality:

Text-based search.

Voice-based search using integrated voice recognition technology.

Payment Gateway Integration: Secure payment options for hassle-free transactions.

Notification System: Real-time notifications for order updates, offers, and more.

Cart Management: Add, update, or remove items from the cart.

Favorites: Save products for future reference.

Product Details Page: Comprehensive details for each product, including size, material, and more.

#Additional Features:

User authentication and profile management.

Order tracking and history.

Responsive and user-friendly UI/UX.

Many more features to enhance the shopping experience.

#Technology Stack

Frontend:

Flutter: For building a responsive and intuitive mobile application.

Backend:

Django: As the primary backend framework for building robust APIs.

Django Rest Framework (DRF): For API development.

PostgreSQL: As the database for storing user and product information.

Machine Learning Models:

U2NET: For cloth segmentation.

Graphonomy: For parsing human body shapes.

Mediapipe: For extracting body measurements.

Posenet: For estimating user poses.

Detectron2: For dense pose estimation.

HR-VITON: For virtual try-on functionality.

Additional Tools:

Firebase: For authentication and notification services.

Khalti and Esewa: Integrated for payment gateway solutions.

#Installation and Setup

Clone the repository:

git clone https://github.com/your-repository-url.git

Navigate to the project directory:

cd styleme

cd stylefront

Install dependencies:

flutter pub get

Navigate to the backend directory and install backend dependencies:

cd measurement
pip install -r requirements.txt

Run the backend server:

python manage.py runserver

Return to the Flutter project directory and run the app:

cd ../
flutter run

#Future Enhancements

Expand virtual try-on to include more clothing categories.

AI-driven personalized recommendations.

Multi-language support.

Integration with AR for an immersive shopping experience.

GPU acceleration for faster virtual try-on processing.

#License

This project is developed for academic purposes and is open for contributions. The licensing terms can be updated as per future requirements.

We hope you enjoy using Style Me as much as we enjoyed building it. Feel free to contribute or provide feedback to make it even better!


