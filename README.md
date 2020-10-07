# Comments

1. The app uses Master-Detail template and MVVM architecture.

2. Pulls data from the API 'https://jsonplaceholder.typicode.com/comments'. The data is comments divided based on the post id.

3. Core data is used to store the comments so that those can be shown when the user is offline.

3. Created sections of comments based on post id.

4. Used codable NSManagedObject to decode the data fetched from the API and store it in core data.

5. NSFetchedResultsController is used to manage fetching and displaying the records from core data.

6. Comment details are shown on DetailViewController.

7. 'Pull to refresh' support is added using 'UIRefreshControl'.

8. Unit tests written for model and view model classes.

9. The app uses 'SwiftLint' pod to maintain the code quality. Please install the pod before running the app.
