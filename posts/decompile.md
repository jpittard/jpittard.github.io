# Use the IntelliJ lib to decompile a bunch of jars. It creates source jars.
find /mnt/c/Users/james.pittard/.m2/repository/com/searchtechnologies -name "*.jar" -exec cp -n {} . \;

# Make a directory for each file
for f in *.jar; do mkdir "${f%.*}"; done

# Get the IntelliJ lib
# Also available on Github as fernflower, but requires compiling the whole intellij plugins project to build
# I put a copy on Dropbox/support
cp C:\Program Files\JetBrains\IntelliJ IDEA 2019.3\plugins\java-decompiler\lib\java-decompiler.jar .

# Make a source jar for each compiled jar
java -cp ../java-decompiler.jar org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler *.jar decompiled/

# Unjar to common directories
for f in decompiled/*.jar; do jar -xvf $f; done
