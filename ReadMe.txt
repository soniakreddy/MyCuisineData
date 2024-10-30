### Steps to Run the App
Clone the Repository: Start by cloning the repository to your local machine.
Open the Project: Open the .xcodeproj file in Xcode.
Install Dependencies: Install the Kingfisher dependency using Swift Package Manager.
Run the App: Select a simulator or a physical device and hit the "Run" button in Xcode.
Explore the Features: Use the app to navigate through the recipes, test the search functionality, and observe how the view controller interacts with the view model.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I prioritized the implementation of the ViewController and its interactions with the RecipeViewModel. This focus was essential because the view controller serves as the primary interface for users, and ensuring a smooth user experience with accurate data presentation and search functionality is crucial for the app's success.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I had to split the development over the days as I couldn't allocate enough time to finish it in a stetch.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

One significant trade-off was the decision to use completion handlers instead of async/await for network calls. Initially, I considered using async/await to streamline asynchronous code and improve readability. However, I switched to completion handlers to ensure compatibility with existing code structures and to facilitate easier unit testing. This decision allowed for a more straightforward implementation but resulted in slightly more complex callback management in the view model.

### Weakest Part of the Project: What do you think is the weakest part of your project?
Right now, it only catches a couple of specific errors, like malformed data and empty responses. This makes it harder to diagnose issues when they come up, since it doesn’t cover other potential problems that might happen during network calls or while processing data. It would definitely be better to improve the error handling to include more scenarios, making the app more reliable overall.

### External Code and Dependencies: Did you use any external code, libraries, or dependencies?
I used the XCTest framework for unit testing, which is a standard part of the Xcode toolchain. Additionally, I leveraged UISearchController for search functionality, which is also part of the UIKit framework. No third-party libraries or external dependencies were used in this project.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
