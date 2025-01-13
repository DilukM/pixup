# PixUp

PixUp is a movie recommendation app that helps you discover the perfect films for your mood. Curated suggestions, seamless navigation, and a world of cinema at your fingertips.

## Setup Instructions

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter
- Android Studio or Xcode: For running on Android or iOS devices
- TMDB Account: Required for API access

### TMDB API Configuration

1. Create a TMDB Account:
   - Visit [TMDB Website](https://www.themoviedb.org/)
   - Click "Join TMDB" and complete the registration process
   - Verify your email address

2. Generate API Key:
   - Log in to your TMDB account
   - Go to your account settings (click your avatar)
   - Click on "Settings" in the dropdown menu
   - Select "API" from the left sidebar
   - Click "Create" or "Request an API key"
   - Choose "Developer" option
   - Fill out the application form with:
     - Application name: "PixUp"
     - Application URL: Your website or GitHub repository
     - Application Summary: "Mobile app for movie recommendations"
   - Accept the terms of use
   - Submit the form

3. Get Your API Key:
   - Once approved, you'll receive:
     - API Key (v3 auth)
     - API Read Access Token
   - Save these credentials securely

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/DilukM/pixup.git
   cd pixup
   ```

2. Install dependencies:

   ```sh
   flutter pub get
   ```

3. Set up your API key:

- Create a file named .env in the root directory
- Add your TMDB API key to the .env file:

  ```sh
  TMDB_API_KEY=your_api_key_here
  ```

4. Configure TMDB API Base URL:
   - The base URL for TMDB API is: `https://api.themoviedb.org/3`
   - Example API call format: `https://api.themoviedb.org/3/movie/popular?api_key=your_api_key_here`

5. Run the app:
   ```sh
   flutter run
   ```

### Libraries and Plugins Used

- carousel_slider
- flutter_floating_bottom_bar
- http
- provider
- shared_preferences
- flutter_dotenv

### Additional Information

- For more details on Flutter development, visit the [official documentation](https://flutter.dev/docs)
- For TMDB API documentation, visit the [TMDB API Documentation](https://developers.themoviedb.org/3)
- Rate Limits: TMDB API has a rate limit of 40 requests every 10 seconds
