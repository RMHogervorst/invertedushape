# Running an R script on a schedule
This is a small proof of concept standalone script

* [Running R scripts on heroku](#heroku)
* [Running R scripts using github-actions](#github-actions)


# Heroku
(See also [my blogpost](https://blog.rmhogervorst.nl/blog/2020/09/21/running-an-r-script-on-a-schedule-heroku/))

It is an update to: https://blog.rmhogervorst.nl/blog/2018/12/06/running-an-r-script-on-heroku/


```
You save your script locally in a git repository
You push everything to heroku (a cloud provider, think a laptop in the sky)
# installation
heroku installs R and the relevant packages and the script
heroku saves this state and stops
# running something
you can give heroku a command and it will start up and run the script
this starting up can be done on a timer
```

What you need:


* no fear for using the command line (know where it is and how to navigate is enough)
* an heroku account (you will need a creditcard, but once a day running is probably free)
* install the heroku CLI (command line interface)
* authenticate your CLI by running heroku login
* a folder with a script that does what you want to do
* (not necessary, but very useful) renv set up for this project

Heroku doesn't support R officially but other people have created
addons to make it work. I'm using the heroku-buildpack-r by virtualstaticvoid. 
This is rather convenient, because you can use RENV to tell the 
buildpack what packages you need and it will install them.

### Using RENV on your script:

* activate renv for your project in Rstudio
* install all packages (if you type `library(rtweet)` in your script the rstudio editor will ask you if you want to install that package and will install it in your local RENV environment)

* If you are satisfied with your script, source it and see if it runs successfully, 
* do `renv::snapshot()` to add all the right packages to the snapshot.

### Setting up heroku
1. Download and install heroku cli
https://devcenter.heroku.com/articles/heroku-cli

for mac `brew tap heroku/brew && brew install heroku`

after installation
`heroku login`

Do either:
`heroku create --buildpack https://github.com/virtualstaticvoid/heroku-buildpack-r.git` in folder 

or do `heroku create` and add the buildpack with:
`heroku buildpacks:set https://github.com/virtualstaticvoid/heroku-buildpack-r.git`

In this previous step you get a name for your project for instance powerful-dusk-49558

* make sure you connect your repo to heroku (this didn’t happen automatically for me) `heroku git:remote -a powerful-dusk-49558`

* make sure to add the renv/activate script and the lockfile to your git repo

`git add renv/activate.R`
`git add renv.lock`

* git push 
`git push heroku master`

The terminal shows all the installs of the buildback
```
remote: -----> R (renv) app detected
remote: -----> Installing R
remote:        Version 4.0.0 will be installed.
remote: -----> Downloading buildpack archives from AWS S3
..etc..
```

it is installing all the stuff. 

### Environmental variables
I went into the heroku website of my project and manually
set the config vars <https://devcenter.heroku.com/articles/config-vars>

these are the environmental variables. 

but it is also possible to set them using `heroku config:set GITHUB_USERNAME=joesmith`

I have  a script that uses `Sys.getenv()` to get environmental
variables. I set them locally with .Renviron (in this folder, (don't forget to add them to your .gitignore file, so you dont add them to your public repo!), another option is set it globally, but when you use RENV it only looks locally [IS THTAT SO?])


Test if the script runs with `heroku run Rscript run_job.R`

Do only push everything to heroku when you are sure it works because it reinstalls everything at every push but renv will
use the cache, but it is somewhat slow (several minutes for me):
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


### Adding the scheduler
```
heroku addons:create scheduler:standard
```

Go to your heroku project to set the scheduler or use
`heroku addons:open scheduler` to let your browser move to the correct window.

I first set the frequency to hourly to see if the tweet bot works hourly. 

I set the job to `Rscript run_job.R` 

*that is right I use the the same incantation as `heroku run {}`*


links:

https://github.com/virtualstaticvoid/heroku-buildpack-r

# Github actions

* Add your secrets to github
* Modify the .github/workflows/main.yml file

# using gitlab

* Add your secrets to settings/ci cd /variables
* Modify the .gitlab-ci.yml file to your liking
