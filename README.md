# TGBot
## (command-controlled version)

This Telegram bot lets you deliver a set of URLs, picking one randomly and asinchronously sending one to each of the updates received.

#### Dependencies

 - Bash 4 (or greater).

#### Installation

Clone the repo to your computer.

#### Configuration

 - Define your bot's API key in a file called '.api_key' at the root of the project folder.
 - Define `URLS_PATH` to the path of the plain text file containing all the URLs you want to deliver to your clients
 - Define `SPOKEN_NAME` to whatever name you want to put to your bot while replying.
 - Optionally, define a description in a file called '.desc' at the root of your project folder.

#### Usage

Simply run the script: `bash run.sh`
