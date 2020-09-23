FROM rocker/r-ver:4.0.2
#APT_PKGS: "libcurl4-openssl-dev libssl-dev"

# before
RUN apt-get update
RUN  export PATH="/usr/local/lib/R/site-library/littler/examples/:${PATH}"

RUN echo "options(Ncpus = $(nproc --all))" >> /usr/local/lib/R/etc/Rprofile.site
RUN mkdir -p ~/.local/share/renv
RUN R -e 'install.packages("renv")'
# user settings
RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev libssl-dev libxt6
COPY run_job.R run_job.R
COPY renv.lock renv.lock

RUN R -e 'install.packages(c("ggplot2","rtweet"))'
RUN R -e 'renv::restore()'
# on running of the container this is called:
CMD Rscript run_job.R
