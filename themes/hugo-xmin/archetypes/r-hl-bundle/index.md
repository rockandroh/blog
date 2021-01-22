---
title: "{{ replace .Name "-" " " | title }}"
draft: true
---

<link href="theme.css" rel="stylesheet" type="text/css">
<script src="/highlighter.min.js"></script>

```r
library(tidyverse)

urchins <- read_csv("https://tidymodels.org/start/models/urchins.csv") %>%
  setNames(c("food_regime", "initial_volume", "width")) %>%
  mutate(food_regime = factor(food_regime, levels = c("Init", "Low", "High")))

urchins %>%
  group_by(food_regime) %>%
  summarise(
    across(everything(), mean), n = n()
  )

mean(urchins$width)
ggplot2::cut_interval(urchins$initial_volume)

lm(width ~ initial_volume * food_regime, data = urchins)
```
<!--more-->