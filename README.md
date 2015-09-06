# HangmanGame

Hi! Welcome to this page for introducing and archiving my Strikingly interview project: a word-guessing game on iOS.

## Walkthrough

My project is base on the MVC design pattern.

### Model

- `RESTfulAPIManager` interacts with the HTTP connection and implements all the given APIs in five Objective-C methods with completion handlers.

- `HMString` is a subclass of `NSString`, which reads each character of a word and replaces it with other characters.

- `HMGameMangaer` has just one shared instance telling the program whether the player wants to start a new game or continue the last saved game.

### View

I define my own category and subclass of [FlatUIKit](https://github.com/Grouper/FlatUIKit) and [MBProgressHUD](https://github.com/jdg/MBProgressHUD) to customize my UI components, such as labels, buttons, text field and progress HUD.

### Controller

- HMWelcomeViewController has three parts.
    - Enter your player ID in the text field.
    - Touch **NEW GAME** button to start a new game, and this will reset all the saved data.
    - Touch **CONTINUE** button to continue your last game.

- HMGuessViewController is for guessing the word and getting the result.
    - Submit your guessing letter with the customized keyboard.
    - Check the progress of the current word and some other stats after every guess.
    - Quit the game or submit your score.

## Difficulties that I encountered and how do I resolve them

### HTTP request

Before the task, I have never written code to request data via HTTP. The only library I used to deal with the network when developing iOS App is [LeanCloud](https://leancloud.cn/). However, I just know some basic APIs, nothing more in lower level.

So the first thing I do is to learn what RESTful web service is and how to send and receive JSON package. I read an [article](http://www.drdobbs.com/web-development/restful-web-services-a-tutorial/240169069?pgno=1) and manage to send request using both the terminal and an Chrome extension named [Advanced REST client](https://chrome.google.com/webstore/detail/advanced-rest-client/hgmloofddffdnphfgcellkdfbfbjeloo/reviews?hl=en-US&utm_source=ARC). An hour later, I finally understand the whole game flow and the HTTP request and response that I need to finish the game.

### Customized keyboard

I want to impress people when playing my game but the default keyboard of iOS which looks dull doesn't meet my requirement, and some keys are redundant for guessing a word. So I decide to design a customized keyboard.

I really have little time to learn [Custom Keyboard of App Extension](https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/Keyboard.html) provided by Apple, so the dirty method I come up with is to simulate a keyboard with tons of `UIButton`. Another thing pissed me off is how to auto layout theses buttons. At last, I make it works and it could be worse :)

![](https://cloud.githubusercontent.com/assets/5687273/9426908/f1b108fc-4990-11e5-9ac4-ccfa134e6e60.png)

## Highlights

- > Can I play the game without a player ID?

  > What if I continue the game with a different player ID?

 The answer is NO. And I have also prepared some nice tips for handling these kinds of uncommon behaviour and server error. Find more funny tips as you find the bugs.

- Every time you make a guess, the word will shake its body to cheer you up!

- The keyboard, obviously the one in the second view.

- The App name: **H_ngm_n**. Wait, is it an English word?

- Simple but elegant UI with the help of [FlatUIKit](https://github.com/Grouper/FlatUIKit).

## Screenshots

![](https://cloud.githubusercontent.com/assets/5687273/9704667/40bd83b6-54e1-11e5-92a4-f5d5b8e3d2cd.png)
*Welcome*

![](https://cloud.githubusercontent.com/assets/5687273/9704669/515ded8c-54e1-11e5-80ae-390123855144.png)
*Noob entering ID*

![](https://cloud.githubusercontent.com/assets/5687273/9704670/6982bfc8-54e1-11e5-9f91-3a94a5da08cb.gif)
*Shake it*

![](https://cloud.githubusercontent.com/assets/5687273/9704675/9be902ec-54e1-11e5-8bc5-04620703135d.png)
*Noob testing button*

## Big thanks

Thank you very much for giving me such a special interview opportunity. I will never forget the intense but meaningful development time lasted 4 days. Hope you enjoy my work as I do. For more fun, please try another iOS game made by me, [7 Light Year](https://itunes.apple.com/us/app/7-light-year/id1025658330?mt=8).
