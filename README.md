# tweeter-viewer
This is a simple program written in Haskell that fetches 10 tweets by keyword that was asked in terminal.

## Before install
You need haskell & stack to run this app.
You need auth credentials which you can get through app registration on twitter. See https://apps.twitter.com/ 

## Clone & Configure
Clone repo:

```
$ git clone git@github.com:ashgaliyev/tweeter-viewer.git
$ cd tweeter-viewer
```

Create config.local in folder with following contents:

```
consumerKey = "your-consumer-key"
consumerSecret = "your-consumer-secret"
```

## Run

```
$ stack build
$ stack exec twitter-viewer-exe
```
