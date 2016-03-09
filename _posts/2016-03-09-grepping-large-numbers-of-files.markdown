---
published: true
title: Grepping large numbers of files
layout: post
---
From [http://unix.stackexchange.com/questions/131535/recursive-grep-vs-find-type-f-exec-grep-which-is-more-efficient-faster]

Do this as the standard:

``` Bash
find / -type f -exec grep search_term /dev/null {} +
```

Do this with GNU tools:

``` Bash
find / -type f -exec grep -Hi 'the brown dog' {} +
```

Do this for multi-threading on a RAID setup:

``` Bash
find / -type f -print0 | xargs -r0 -P2 grep -Hi 'the brown dog'
```

To avoid looking inside /proc, /sys..., use -xdev and specify the file systems you want to search in:

``` Bash
LC_ALL=C find / /home -xdev -type f -exec grep -i 'the brown dog' /dev/null {} +
```