# Readme


## Installation
This project uses CocoaPods as a dependency manager. 
To build the project, run `pod install` in the folder project. Then open Pave.xcworkspace file.

If you don't have CocoaPods installed, run `sudo gem install cocoapods` before that. And check out https://cocoapods.org for more info.


## Starting work 
To start working with the app, put your API key and user_id in **Services/NetworkService** (fields `token` and `userId`).
```swift
var token: String {
	return "YOUR_TOKEN_HERE"
}
```

```swift
var userId: String = "ID_OF_THE_USER"
```

## Details

### Architecture 
App uses MVP pattern - app uses Controllers, that are driven by Presenters, that show Models. Presenters get data from DataProviders, that use stateless services.  
More on MVP https://medium.com/omisoft/lightweight-mvp-architecture-in-ios-a16b3da01563

### Classes
For the implementation of network requests to API, see **NetworkService**.

You can see dashboard implementation in **Dashboard** folder. 

Everything you need for building a chart is in **Charts** folder. **GraphCell** is a container that contains **ChartViewController** that works with the chart. 
To set values to ChartViewController, map your values to array of `DashboardValue`, and then pass them in `setValues` method.

Money amounts are represented by **Money Amount** class, that contains amount in a currency. Note, that if you try to sum two amounts in different currency, a **MoneyError** will be thrown. 
