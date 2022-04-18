# Get all the lines from file_you_want_results_from.txt that are not contained in file_with_some_commonality.txt
comm -23 <(sort -u file_you_want_results_from.txt) <(sort -u file_with_some_commonality.txt) > outfile.txt
