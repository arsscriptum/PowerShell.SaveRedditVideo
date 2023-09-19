# Save-RedditVideo

PowerShell function to save a video from Reddit based on the Url.

## Usage

Go on a page where a video is available, like https://www.reddit.com/r/ukraine/comments/yqwngl/volodymyr_zelenskyy_official_nov_9th_2022_about/
Then use that url with the function

```
    Save-RedditVideo.ps1 -Url "https://www.reddit.com/r/ukraine/comments/yqwngl/volodymyr_zelenskyy_official_nov_9th_2022_about/"
```

### Doc

https://github.com/arsscriptum/PowerShell.SaveRedditVideo/blob/main/doc/Save-RedditVideo.md

## Innards

Gets the download url from ```redditsave.com``` 

## Demo

![Demo](https://raw.githubusercontent.com/arsscriptum/PowerShell.SaveRedditVideo/main/doc/demo.gif)


![Demo](https://raw.githubusercontent.com/arsscriptum/PowerShell.SaveRedditVideo/main/doc/demo2.gif)