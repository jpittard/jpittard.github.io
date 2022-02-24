# Remove hard returns
sed -i 's/\r$//' filename
tr -d '\r' < windows.txt > unix.txt 
