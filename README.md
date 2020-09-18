# Running R scripts on heroku


This is a small proof of concept with steps to see what you need for running a script on heroku. 

It is an update to: https://blog.rmhogervorst.nl/blog/2018/12/06/running-an-r-script-on-heroku/

https://github.com/RMHogervorst/tweetwikidatadeaths

1. Download and install heroku cli
https://devcenter.heroku.com/articles/heroku-cli

for mac `brew tap heroku/brew && brew install heroku`

after installation
`heroku login`


`heroku create --buildpack https://github.com/virtualstaticvoid/heroku-buildpack-r.git` in folder 
I created 


links:

https://github.com/virtualstaticvoid/heroku-buildpack-r
