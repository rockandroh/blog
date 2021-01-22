---
title: Home
---

[<img src="https://simpleicons.org/icons/github.svg" style="max-width:15%;min-width:40px;float:right;" alt="Github repo" />](https://github.com/yihui/hugo-xmin)

# HUGO XMIN

## _Keep it simple, but not simpler_

**XMin** is a Hugo theme written by [Yihui Xie](https://yihui.name) in about four hours: half an hour was spent on the Hugo templates, and 3.5 hours were spent on styling. The main motivation for writing this theme was to provide a really minimal example to beginners of Hugo templates. This XMin theme contains about 130 lines of code in total, including the code in HTML templates and CSS (also counting empty lines).


```bash
find . -not -path '*/exampleSite/*' \( -name '*.html' -o -name '*.css' \) | xargs wc -l
```

```
      37 ./layouts/list.html
      22 ./layouts/r-syntax-highlighting-gallery/list.html
       5 ./layouts/404.html
      27 ./layouts/blog/list.html
      21 ./layouts/_default/single.html
      21 ./layouts/_default/list.html
      12 ./layouts/partials/project-card.html
       1 ./layouts/partials/head_hljs.html
      35 ./layouts/partials/blog-card.html
      27 ./layouts/partials/rgallery-card.html
      31 ./layouts/partials/two-column.html
      29 ./layouts/partials/footer.html
      36 ./layouts/partials/foot_js.html
      28 ./layouts/partials/header.html
       8 ./static/css/bootstrap.css
       2 ./static/css/prism-vs.css
       2 ./static/css/style.css
       2 ./static/css/fonts.css
     346 total
```

I can certainly further reduce the code, for example, by eliminating the CSS, but I believe a tiny bit of CSS can greatly improve readability. You cannot really find many CSS frameworks that only contain 50 lines of code.

Although it is a minimal theme, it is actually fully functional. It supports pages (including the home page), blog posts, a navigation menu, categories, tags, and RSS. With [a little bit customization](https://github.com/yihui/hugo-xmin/blob/master/exampleSite/layouts/partials/foot_custom.html), it can easily support LaTeX math expressions, e.g.,

`$${\sqrt {n}}\left(\left({\frac {1}{n}}\sum _{i=1}^{n}X_{i}\right)-\mu \right)\ {\xrightarrow {d}}\ N\left(0,\sigma ^{2}\right)$$`

All pages not under the root directory of the website are listed below. You can also visit the list page of a single section, e.g., [posts](/post/), or [notes](/note/). See the [About](/about/) page for the usage of this theme.
