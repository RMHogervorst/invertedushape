# Running R scripts on heroku


This is a small proof of concept with steps to see what you need for running a script on heroku. 

It is an update to: https://blog.rmhogervorst.nl/blog/2018/12/06/running-an-r-script-on-heroku/

https://github.com/RMHogervorst/tweetwikidatadeaths

1. Download and install heroku cli
https://devcenter.heroku.com/articles/heroku-cli

for mac `brew tap heroku/brew && brew install heroku`

after installation
`heroku login`

Do either:
`heroku create --buildpack https://github.com/virtualstaticvoid/heroku-buildpack-r.git` in folder 

or do `heroku create` and add the buildpack with:
`heroku buildpacks:set https://github.com/virtualstaticvoid/heroku-buildpack-r.git`

```
Run git push heroku main to create a new release using this buildpack.
```

```
heroku addons:create scheduler:standard
```

links:

https://github.com/virtualstaticvoid/heroku-buildpack-r
