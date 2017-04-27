# About

This is a quick ruby script to standardize the file naming system in a particular directory. I use it with a launchd [LaunchAgent](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html) to watch for changes to a particular directory and ensure that any new files are named according to my preferred style.

The repository thus contains two files:

- `standardize-filenames.rb`, a Ruby script to inspect a directory and rationalize filenames.
- `articles.plist`, a launchd Property List definition (called "articles" because the script is designed to process academic article filenames).

# What is this for?

As an academic, I keep on hand a great many PDFs of published articles. Currently they are (almost) all stored in a single large directory (at `~/Documents/articles`) which currently contains 3935 items (~5.49GB). I got tired of having to manually rename new files to conform to my preferred name scheme, which is:

```
author-lastname some fancy article title.pdf
```

It keeps things uniform and easily readable if everything is named the same way. I've settled on all-lowercase, lastname-plus-short-article-title format. This is of course arbitrary; what's important to me is to have a system, not so much the specific criteria adopted.

# Aesthetic details

I do have one exception to the all-lowercase rule: if a word is an acronym, I prefer for it to remain all uppercase. Acronyms can also contain digits (this sometimes includes abbreviations: I often use "19C" as an abbreviation for "19th century"). So the script has to be just slightly smarter than "lowercase everything" in order to handle the acronym case.

I also convert all underscores to spaces. (I thought about doing the same with hyphens, but there are too many hyphens in people's names, etc.)

# Installation:

The ruby script would work on any system with ruby installed. The launchd part requires OSX.

1. Move the plist file into `~/Library/LaunchAgents`
2. Move standardize-files.rb into some standard location (I use `~/bin`).
3. Edit articles.plist file to reflect the path you want to watch (I use `/Users/myuser/Documents/articles`) and the path to your script. (You'll want to insert your username where I put `YOURUSER` as a placeholder value in lines 9, 10 and 14.) 
4. `launchctl load ~/Library/LaunchAgents/articles.plist`

# Usage

Each time you add a new file to your target folder, the script will run and will standardize all filenames in the folder. (To be specific, it finds all files whose names contain uppercase characters. I don't know a way to only inspect recently changed files given the launchd WatchPaths UI, and we don't know for sure that recently added files will have recent modification times (so that wouldn't be a good criterion to watch with.)


## Usage notes

You can monitor the results by opening `Console.app` and watching the log when you add a new file to your target directory. Each rename operation generates a log entry.

It takes a few seconds for the script to run when you add a new file to the folder. It may also take a moment for Finder to update the filename if you're watching the folder in the GUI.

If you add a bunch of files to your folder one after the next, launchd seems to impose a cool-down period on the script:

```
4/27/17 12:35:51.621 PM com.apple.xpc.launchd[1]: (articles) Service only ran for 0 seconds. Pushing respawn out by 10 seconds.
```

Then it keeps chugging away as usual.

## Manual invocation

You can also just run 

```
$ standardize-filenames.rb /Users/youruser/Documents/articles
```

and it will run interactively. Prefix with DRY_RUN=1 to test without actually renaming anything, like:

```
$ DRY_RUN=1 standardize-filenames.rb /Users/youruser/Documents/articles
```

## Customization

All the actual renaming logic happens in the `standardize_name` method. If you wanted some other naming system you could just customize that.

# Sources:

- http://stackoverflow.com/questions/1515730/is-there-a-command-like-watch-or-inotifywait-on-the-mac

# License

If someone wants this code to have an open source license, just drop me a line.
