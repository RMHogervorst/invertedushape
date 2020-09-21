# Running R scripts on heroku


This is a small proof of concept with steps to see what you need for running a script on heroku. 

I'm using the heroku-buildpack-r by virtualstaticvoid. 
This is rather convenient, because you can use RENV to tell the 
buildpack what packages you need and it will install them.

activate renv for your project in Rstudio
install all packages (if you type `library(rtweet)` in your script the rstudio editor will ask you if you want to install that package and will install it in your local RENV environment)

If you are satisfied with your script, source it and see if it runs successfully, do `renv::snapshot()` to add all the right packages to the snapshot.


```
Heroku is really nice
but has a lot of hidden configuration that you can miss
manual steps
```


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

You need to set up the repo correctly:

use git remote add [ZOEK UIT]
`heroku git:remote -a powerful-dusk-47428`

```
set git remote heroku to https://git.heroku.com/powerful-dusk-47428.git
```

make sure to add the renv/activate script and the lockfile

`git add renv/activate.R`
`git add renv.lock`

git push (will fail if no buildpack script (app, renv/))
`git push heroku master`

The terminal shows all the installs of the buildback
```
remote: -----> R (renv) app detected
remote: -----> Installing R
remote:        Version 4.0.0 will be installed.
remote: -----> Downloading buildpack archives from AWS S3
....
```

it is installing all the stuff. 

I went into the heroku website of my project and manually
set the config vars <https://devcenter.heroku.com/articles/config-vars>

these are the environmental variables. 

but it is also possible to set them using `heroku config:set GITHUB_USERNAME=joesmith`

I have  a script that uses `Sys.getenv()` to get environmental
variables. I set them locally with .Renviron (in this folder, (don't forget to add them to your .gitignore file, so you dont add them to your public repo!), another option is set it globally, but when you use RENV it only looks locally [IS THTAT SO?])


Test if the script runs with `heroku run Rscript run_job.R`

Do only push everything to heroku when you are sure it works because it reinstalls everything at every push but renv will
use the cache, but it is somewhat slow:
```
remote:        Restoring R packages from cache
remote:        Restoring renv packages from cache
remote:        Setting up build environment from cache
remote: -----> Configuring build environment...
remote: -----> Bootstrapping renv
remote:        * The library is already synchronized with the lockfile.
remote: -----> Finalising environment...
remote: -----> Writing environment to profile
remote: -----> Caching build outputs
remote:        Build environment...
remote:        Done: 499M
remote:        R packages...
remote:        Done: 186M
remote:        renv packages...
remote:        Done: 960K
remote: -----> R 4.0.0 installed successfully!
remote:        Install took 174 seconds to complete
remote: -----> Discovering process types
remote:        Procfile declares types     -> (none)
remote:        Default types for buildpack -> console
```


```
heroku addons:create scheduler:standard
```

links:

https://github.com/virtualstaticvoid/heroku-buildpack-r
