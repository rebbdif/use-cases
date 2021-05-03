# Readme


## Installation
This project uses CocoaPods as a dependency manager. 
To build the project, run `pod install` in the folder project. Then open Pave.xcworkspace file.

If you don't have CocoaPods installed, run `sudo gem install cocoapods` before that. And check out https://cocoapods.org for more info.


## Starting work 
To start working with the app, put your API key and user_id in **NetworkService** (fields `token` and `userId`).


## Details
App uses MVP pattern - app uses Controllers, that are driven by Presenters, that show Models. Presenters get data from DataProviders, that use stateless services.  
More on MVP https://medium.com/omisoft/lightweight-mvp-architecture-in-ios-a16b3da01563

For the implementation of network requests to API, see **NetworkService**.
