FROM rocker/r-ver:4.0.2

# before step (in gitlab)
# - update, and set for maximum cpu use
# - make a renv folder and install renv
RUN apt-get update
RUN echo "options(Ncpus = $(nproc --all))" >> /usr/local/lib/R/etc/Rprofile.site
RUN mkdir -p ~/.local/share/renv
RUN R -e 'install.packages("renv")'
# user settings
# - install the systems libraries
# - copy script and lock file
RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev libssl-dev libxt6
COPY run_job.R run_job.R
COPY renv.lock renv.lock
# I found that renv::restore does not use the super fast
#   rstudio package manager, and so by pre instaling rtweet and ggplot2
#   and all their dependencies we get way faster building speed
RUN R -e 'install.packages(c("ggplot2","rtweet"))'
RUN R -e 'renv::restore()'
# on running of the container this is called:
CMD Rscript run_job.R
