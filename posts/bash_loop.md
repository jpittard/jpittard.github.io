I keep forgetting how to write this loop in bash, so here it is. This one will unzip / tar a series of files into corresponding folders.

```Bash
#!/bin/bash
for f in *.gz; do 
  base=${f%%.*}
  mkdir $base
  pushd $base
  tar -xzvf ../$f
  popd
done
```
