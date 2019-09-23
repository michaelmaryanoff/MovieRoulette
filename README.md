# **Movie Roulette**

## Description:
"Movie Roulette" is an app to use when you can't figure out what to watch. The user inputs a set of three parameters (genre, release window, and actor). The user will then hit the "spin" button and the app will then find a list of movies meeting those criteria using the TMDB.org API and will generate a random movie to watch that night.

# **App implementation**

## Selection View Controller
When the user opens the app, they are presented with the SelectionViewController. This view controller has three labels and four buttons. Three of these buttons will allow the user set up parameters the user can use to generate their random movie. The last button will choose a random movie for the user (more details below).


## Select Genres Label
The "Genres Selected" label will show the user how many genres they have selected. If there are no genres selected it will read "Select Genres." If some genres have been selected, it will display the amount of genres selected.

## Select Genres button
The select genres button will segue to the "GenresTableViewController" where the user can select their preferred genres for the movie they want to watch (Action, Comedy, Drama, etc). These settings will be saved when the user hits the "back" button.

## Release Window label
This is a label that displays the release window the user has selected. If no release window is selected it will read "Release Dates." The user can choose a release window using the "Date Range" Button.

## Date Range Button
The date range button will segue to to ReleaseWindowViewController which contains a picker view which allows the user to select a release window range. Hitting the back button saves this selection.

## Choose Actor Label
This label will display which actor the user has chosen as a search parameter. If the user has not chosen an actor, it will read "Select an Actor". The user can choose an Actor using the "Choose Actor" Button

## Choose Actor Button
This button will segue to the ActorSearchViewController. It is a table view with a search bar. When the user begins typing in a name to the search bar, the table view will populate with actors meeting the search criteria.

While the client is querying the server, a UIActivityIndicator will animate in the middle of the screen. **If the user has a sufficiently fast internet connection, the activity indicator will be too quick to notice.**

If no actors can be found, an error will displaying notifying the user. It will also notify the user if there is not internet connect. The user selecting a row with the name of their preferred actor will segue back to the SelectionViewController and update the choose actor label with their selection.

## Spin Button
This button will make a network call using all of the parameters chosen by the user and fetch a list of movies meeting the requirements. It will then choose a random movie for the user to watch. This movie will be displayed via an Alert controller. Hitting the "Spin" button again will choose another movie.

# **Requirements**

Xcode 10.2.1
Swift 5.0
Deployment target: iOS 12.2
AlamoFire library
SwiftyJson library

# **API used

TMDB.org API: https://developers.themoviedb.org/3/getting-started/introduction

# **Podfile

When running app, podfile should look like this before running cocoapods installation:

```
# Uncomment the next line to define a global platform for your project
platform :ios, '12.2'

target 'MovieRoulette' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MovieRoulette
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Alamofire', '~> 5.0.0-beta.5'
end
```
