# HUGO XMIN

## Fork

This fork primarily adds the Bootstrap
[Grid system](https://getbootstrap.com/docs/4.0/layout/grid/)
for organizing blog posts into columns.

Following the directions from this Stackoverflow
[answer](https://stackoverflow.com/a/38995154/6637133), you can easily
add any number of columns within the body of the post:

````
<div class="row">
<div class="col-md-6"><h2>Column 1</h2>
`r ''````{r}
#1234567890#1234567890#1234567890#1234567890#1234567890#1234567890#1234567890#12
library(tidyverse)

ggplot2::diamonds
```
</div>
<div class="col-md-6"><h2>Column 2</h2>
```{r}
mtcars
```
</div>
</div>
````

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
```
