Ruby pipe helper

Use ruby in your pipes, forget about grep / sed / awk / wc ...

Sometimes rup is longer, but its easier to read/debug/refactor
and you only need to know pure ruby.

Install
=======
    sudo gem install rup

Usage
=====
Rup supports mapping and reducing.<br/><br/>
Map works on each line as String<br/>
Reduce works on all lines as Array<br/>

    something | rup 'map' ['reduce']
    something | rup -r 'reduce'

A few simple examples.<br/>

    # grep --- all lines including foo
    ls -al | grep foo
    ls -al | rup 'include?("foo")'

    # grep --- all lines including foo but not grep
    ps -ef | grep foo | grep -v grep
    ps -ef | rup 'include?("foo") and not include?("rup")'

    # awk --- return second work
    ls -al | awk '{print $2}'
    ls -al | rup 'split(" ")[1]'

    # awk --- count and average of all integers on second position
    ls -al | awk '{ s += $2; } END {print "average" ,int(s/NR);print "count ",int(NR)}'
    ls -al | rup 'split(" ")[1]' '"average #{mean(&:to_i)}\ncount #{size}"'

    # wc --- count lines
    ls -al | wc -l
    ls -al | rup -r 'size'

    # sed -- replace a 5 with five
    ls -al | sed 's/5/five/'
    ls -al | rup 'gsub(/5/,"five")'


Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
