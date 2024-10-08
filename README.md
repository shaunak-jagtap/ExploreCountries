# ExploreCountries

ExploreCountries is an iOS application that allows users to browse and explore information about countries around the world. Users can search for countries, filter them by population, and view details such as capital city, currency, population, and flag.

## Features

- **Search Countries**: Quickly search for countries by name.
- **Filter by Population**: Filter countries based on population ranges:
  - All
  - Less than 1 million
  - Less than 5 million
  - Less than 10 million
- **Country Details**: View information like capital city, currency, population, and flag.
- **Pull-to-Refresh**: Refresh the country list by pulling down.
- **Retry on Error**: Retry fetching data if a network error occurs.

## Requirements

- iOS 14.0 or later
- Xcode 12.0 or later
- Swift 5.0 or later

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/yourusername/ExploreCountries.git
   ```
2. **Open the Project**
  
  ```bash
   cd ExploreCountries
   open ExploreCountries.xcodeproj
   ```
3. **Build and Run:**
- Select a target device or simulator in Xcode.
- Press Command + R to build and run the app.

## Usage

Browse Countries: Launch the app to see a list of countries.
Search: Use the search bar to find countries by name.
Filter: Tap the filter button to apply population filters.
Refresh: Pull down on the list to refresh data.
Retry: If an error occurs, tap "Retry" to attempt fetching data again.

## Architecture

The app follows the Model-View-ViewModel (MVVM) architecture pattern.

Model: Data structures representing country information.
ViewModel: Handles data fetching, filtering, and searching logic.
View: UI components like view controllers and views.

### Screenshots

You can find screenshots of the application in the `screenshots` folder of the repository.

<table>
  <tr>
    <td><img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-10-08%20at%2010.16.26.png" width="258" alt="Screenshot 1"></td>
    <td><img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-10-08%20at%2010.16.33.png" width="258" alt="Screenshot 3"></td>
  </tr>
  <tr>
    <td><img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-10-08%20at%2010.16.37.png" width="258" alt="Screenshot 4"></td>
    <td><img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-10-08%20at%2010.16.55.png" width="258" alt="Screenshot 5"></td>
  </tr>
</table>

## Testing

The project includes unit tests to ensure the reliability of the CountryViewModel.

# Running Tests
Open the Test Navigator
In Xcode, press Cmd + 6 or select the Test Navigator.

# Run Tests
Click the play button next to ExploreCountriesTests to run all tests.
Alternatively, run specific tests by clicking the play button next to individual test methods.

# Test Coverage
CountryViewModelTests: Tests for the CountryViewModel class.
Verifies successful data fetching.
Tests retry logic on network failure.
Validates filtering and searching functionalities.

# Mocking
MockNetworkManager: A mock network manager used to simulate API responses during testing.
