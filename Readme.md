Pipeable Ruby - forget about grep / sed / awk / wc ... use pure, readable Ruby!

Install
=======
    sudo gem install pru

Usage
=====
pru supports mapping and reducing.<br/><br/>
Map works on each line as String<br/>
Reduce works on all lines as Array<br/>

    something | pru 'map' ['reduce']
    something | pru -r 'reduce'

### Examples

    # grep --- all lines including foo
    ls -al | grep foo
    ls -al | pru /foo/

    # grep --- all lines including current date
    ls -al | ???
    ls -al | pru 'include?(Time.now.strftime("%Y-%m-%d"))'

    # grep --- all lines including foo but not self
    ps -ef | grep foo | grep -v grep
    ps -ef | pru 'include?("foo") and not include?("pru")'

    # awk --- return second item
    ls -al | awk '{print $2}'
    ls -al | pru 'split(" ")[1]'

    # awk --- count and average of all integers on second position
    ls -al | awk '{ s += $2; } END {print "average" ,int(s/NR);print "count ",int(NR)}'
    ls -al | pru 'split(" ")[1]' '"average #{mean(&:to_i)}\ncount #{size}"'

    # wc --- count lines
    ls -al | wc -l
    ls -al | pru -r 'size'

    # sed -- replace a 5 with five
    ls -al | sed 's/5/five/'
    ls -al | pru 'gsub(/5/,"five")'

    # every second line
    ls -al | pru 'i % 2 == 0'


Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
