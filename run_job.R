library(rtweet)
library(ggplot2)
library(glue)

# fail on missing env vars
missing_env <- function(key){
  result <- is.na(Sys.getenv(key,unset = NA_character_))
  if(result) warning(paste0("Missing env var: ",key))
  result
}

if(any(
  missing_env('apikey'),
  missing_env("apisecretkey"),
  missing_env("access_token"),
  missing_env("access_token_secret")
)) stop("credentials not found")


# curve
point_len <- sample(c( 20, 25, 30, 35,40),1)
points <- seq_len(point_len)
halfpoint <- median(points)
offset_ <- round(rnorm(1)*4)
noise<- rnorm(n = point_len,mean = halfpoint, sd = sqrt(halfpoint))
dataset <- data.frame(
    x = points,
    y = -(points-halfpoint)^2+offset_+noise
)
# titles
x = sample(
    c("Arousal", "Time", "Height", "Pressure", "Dogpoo", "Coffee",
      "Stress", "Religiosity", "Response", "Dose",
      "Amount of things on the todo list", "Inequality", "Aging",
      "Female Participation Ratio", "Bro-ness", "Saltiness", "Friends"),
    1)
y = sample(
    c("Animals", "Percentage Poodles", "Flamingos", "Dinosaurs", "Donkeys",
      "Fun", "Angry Twitter People", "Performance", "Benefits", "Weed",
      "Job Security", "Happiness","Health", "Death Anxiety","Complexity",
      "Drug Concentration", "Motivation", "Innovation", "Temperature",
      "Polution", "Hemline", "Intelligence"),
    1)
subtitle=sample(c("  Who knew?", "  It is a curve!",
                  "  Who knew?", "  It is a curve!",
                  "  Who knew?", "  It is a curve!",
                  "  It is not as if this is just random data"),1)
title = glue("  {y} by {x} is an inverted u-shape")
# color settings
color_ = sample(
    c("#c6538c", "#660066", "#5200cc", "#7300e6",
      "#c2c2a3"),
    1)
background_color= sample(c("#ffffe6","#FFCC99" ),1)
message(glue("using \"{title}\" with foreground: {color_} and background: {background_color}"))
## authenticate and get token
token <- create_token(
    app = "tweetashape",
    consumer_key = Sys.getenv("apikey"),
    consumer_secret = Sys.getenv("apisecretkey"),
    access_token = Sys.getenv("access_token"),
    access_secret = Sys.getenv("access_token_secret"),
    set_renv = FALSE
    )

# plot the plot
tmp <- tempfile(fileext = ".png")

p <-
    ggplot(dataset, aes(x,y))+
    geom_smooth(method = "loess",formula = 'y~x',
                span=0.6,
                se=FALSE,
                position = position_jitter(height=0.05),
                size=2.5,
                color = color_
                )+
    theme_light(base_size = 15 )+
    labs(
        title=title,
        subtitle=subtitle,
        x= x,
        y=y,
        caption="automagically created by @invertedushape1  "
    )+
    theme(
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        plot.margin = margin(2, 2, 2, 2),
        plot.background = element_rect(fill = background_color),
        panel.background = element_rect(fill = background_color),
        plot.caption = element_text(face = "italic"),
        axis.title.x = element_text(hjust = 0.4),
        axis.title.y = element_text(hjust = 0.4),
        plot.subtitle = element_text(family = "serif",face="italic")
    )

ggsave(tmp, plot = p,width = 9, height = 6,)

# added a location to tweetbot too.
post_tweet(status = paste0(title,
                           " #invertedushape",
                           " This post came from: ",
                           Sys.getenv("LOCATION")
                           ),
           media = tmp,
           token = token)
message("Post successful")
