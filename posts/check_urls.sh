while read p; do
  wget -S --spider "$p" 2>&1 | grep 'HTTP/1.1 ' | sed 's|  HTTP/1.1 ||g' >> out.txt
done <urls_to_check.txt
