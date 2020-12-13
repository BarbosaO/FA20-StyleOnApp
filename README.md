# Style-On

Project Structure

- StyleOn                               - Contains the whole project scope without the Pods installation
    - StyleOn                           - Contains the source code of our app
        - Main.storyboard               - Contains all the front end of the application linked to the subsequent .swift file
        - Views                         - Contains the files for a custom .xib file with its corresponding .swift file
        - ViewControllers               - Contains the intermediaries between the views it manages and the data of our app
            - Media                     - Contains the sign-in video of our app
            - Helpers                   - Contains just a handful of extensions and helper methods
            - Services                  - Contains methods that add functionality to our services such as download image from DB
            - Models                    - Contains the models that we'll use to retrieve and store data from Firebase
    - Libs
        - Mapbox                        - Contains the framework files for the Mapbox Software Development Kid (SDK)
    - StyleOnTests                      - Contains Swift built in tests
    - Products                          - Contains the certificates and frameworks defined
    - Pods                              - Contains the configuration of our Pods
    - Frameworks                        - Contains the Swift framework library
- Pods                                  - Contains the installation of the Pods and it's addons

- Firebase Database
    -   Cloud Firestore
        - bookings                      - Contains the bookings data
        - post                          - Contains the posts data
        - users                         - Contains the users' data
        - userBusiness                  - Contains the pro users' data
    -   Storage                         - Contains the posts' images
