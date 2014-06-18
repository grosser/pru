Pipeable Ruby - forget about grep / sed / awk / wc ... use pure, readable Ruby!

Install
=======
    sudo gem install pru


Introduction
============
pru works on input lines and offers easy mapping and reducing.


## Map

Map works on each line as String.

    something | pru <map>


### Examples

    # count letters of each line
    ls -1 | pru size

    # select lines longer than five letters
    ls -1 | pru 'size > 5'

    # passthrough
    ls -1 | pru self


## Reduce

Reduce works on all lines as Array.

    something | pru -r <reduce>
    something | pru --reduce <reduce>

### Examples

    # count lines
    ls -1 | pru -r size

    # are the more than five lines?
    ls -1 | pru -r 'size > 5'

    # passthrough
    ls -1 | pru -r self


## Map and Reduce

    something | pru <map> <reduce>


### Examples

    # count letters in each line, then sum
    ls -1 | pru size sum

    # select lines longer than 5 letters, then join with commas
    ls -1 | pru 'size > 5' 'join(",")'

    # passthrough
    ls -1 | pru self self


Usage
=====

    something | pru <map>
    something | pru <map> <reduce>
    something | pru '' <reduce>
    something | pru -r <reduce>
    something | pru --reduce <reduce>

## Options

    -r, --reduce CODE                reduce via CODE

    -I, --libdir DIR                 Add DIR to load path
        --require LIB                Require LIB (also comma-separated)
    -i, --inplace-edit FILE          Edit FILE inplace

    -h, --help                       Show this.
    -v, --version                    Show Version


### Examples

    # grep --- all lines including foo
    ls -al | grep foo
    ls -al | pru /foo/

    # grep --- all lines including current date
    ls -al | grep $(date +"%Y-%m-%d")
    ls -al | pru 'include?(Time.now.strftime("%Y-%m-%d"))'

    # awk --- return second item
    ls -al | awk '{print $2}'
    ls -al | pru 'split(" ")[1]'

    # awk --- count and average of all integers on second position
    ls -al | awk '{ s += $2; } END {print "average" ,int(s/NR);print "count ",int(NR)}'
    ls -al | pru 'split(" ")[1]' '"average #{mean(&:to_i)}\ncount #{size}"'

    # wc --- count lines
    ls -al | wc -l
    ls -al | pru --reduce 'size'

    # sed -- replace a 5 with five
    ls -al | sed 's/5/five/'
    ls -al | pru 'gsub(/5/,"five")'

    # every second line
    ls -al | pru 'i % 2 == 0'

    # paste-friendly mime-types
    curl https://raw.github.com/mattetti/mimetype-fu/master/lib/mime_types.yml | grep image | pru 'gsub(/(.*): (.*)/, %{"\\1" => "\\2",})'

    # number of files by date:
    ls -al | pru 'split(" ")[5]' 'grouped.sort_by{|d, f| -1 * f.size }.map{|d, f| "#{d} : #{f.size}" }'
    ls -al | pru 'split(" ")[5]' 'counted'

    # quotes inside a string
    something | pru 'include?(%{"string"})'

    # Find a gem version matching a requirement e.g. ~> 1.0.0
    curl http://rubygems.org/api/v1/versions/bundler | pru --require json 'JSON.parse(self).map{|g|g["number"]}.find{|v| Gem::Requirement.new("~>1.0.1").satisfied_by? Gem::Version.new(v) }'

    # List your local repos by watchers
    ls | pru '[self, `curl --silent "https://github.com/grosser/#{self}"`.match(/<li class="watchers.*?(\d+)\s*<\/a/m)[1].to_i] rescue nil' 'sort_by(&:last).reverse.map{|n,i| "#{n} => #{i}" }'

    # Cleanup strange whitespace in a file
    pru -i Rakefile 'gsub(/\r\n/,"\n").gsub(/\t/,"  ")'

    # Removing certain lines from output vs ruby -npe
    ls -al | ruby -npe 'next unless $_.split(" ")[1].to_i > 3'
    ls -al | pru 'split(" ")[1].to_i > 3'

Gemsets
=======
Working with rvm / many gemsets -> only install once

    rvm 1.9.2 exec gem install pru
    echo 'alias pru="rvm 1.9.2 exec pru"' >> ~/.bash_profile


Authors
=======
### [Contributors](http://github.com/grosser/pru/contributors)
 - [John Hobbs](http://github.com/jmhobbs)
 - [Vasiliy Ermolovich](http://github.com/nashby)
 - [Jens Wille](http://blackwinter.de)
 - [SixArm](https://github.com/SixArm)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
