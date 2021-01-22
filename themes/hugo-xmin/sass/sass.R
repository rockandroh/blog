library(magrittr)
library(purrr)
library(tools)
library(sass)
library(fs)

sasses <- dir_ls("sass", glob = "*.scss")

csses <- sasses %>%
	file_path_sans_ext() %>%
	basename() %>%
	paste0("static/css/", ., ".css")

ops <- sass_options(output_style = "compressed")
walk2(sasses, csses, ~sass(input = sass_file(.x), output = .y, options = ops))
