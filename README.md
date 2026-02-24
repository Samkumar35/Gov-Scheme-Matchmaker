# 🏛️ National Government Scheme Matchmaker

A full-stack digital solution designed to bridge the gap between citizens and government benefits. This portal allows users to input their demographic details and instantly discover eligible Central Government schemes with step-by-step application guides.

---

## 🌟 Key Features
* **Smart Eligibility Engine:** Utilizes a custom-built filtering algorithm to match users with government benefits based on Age, Income, State, Gender, Category, and Profession in real-time.
* **Scalable Data Architecture:** Built with a dynamic database schema that allows for the seamless addition of unlimited schemes without modifying the frontend or backend source code.
* **Detailed Application Guides:** Each result includes a direct link to the official government portal and structured, line-by-line "How to Apply" instructions to assist the citizen through the entire process.
* **Responsive UI/UX:** Features a polished, mobile-friendly interface with an instant Profile Summary and expandable cards for high-density information display.
  
---

## 🛠️ Tech Stack
* **Frontend:** Flutter (Dart) - For a cross-platform mobile and web experience.
* **Backend:** Spring Boot (Java) - RESTful API handling the matching logic and database communication.
* **Database:** PostgreSQL - Relational database for structured storage of scheme criteria and benefits.

---

## 🚀 Getting Started

### 1. Prerequisites
* Flutter SDK
* Java JDK 17+
* PostgreSQL

### 2. Database Setup
1. Create a database named `scheme_db` in PostgreSQL.
2. Execute the SQL script located in `/backend/database_setup.sql` to create the `schemes` table and populate it with data.

### 3. Backend Setup
1. Navigate to the `backend` folder.
2. Update `src/main/resources/application.properties` with your PostgreSQL username and password.
3. Run the application:
   ```bash
   ./mvnw spring-boot:run

### 4. Frontend Setup
1. Navigate to the frontend folder.
2. Open lib/main.dart and update the ipAddress variable to your local IPv4 address.
3. Run the app:
   ```bash
   flutter pub get
   flutter run

