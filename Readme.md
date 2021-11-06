Pipeable Ruby - forget about grep / sed / awk / wc ... use pure, readable Ruby!

## Map - each line

    # count letters of each line
    ls -1 | pru size

    # select lines longer than five letters
    ls -1 | pru 'size > 5'

    # 2nd to last character
    ls -1 | pru self[2..-1]


## Reduce - all lines as Array

    # count lines
    ls -1 | pru -r size

    # are the more than five lines?
    ls -1 | pru -r 'size > 5'

    # get 2nd to last line
    ls -1 | pru -r self[2..-1]


## Map and Reduce

    # count letters in each line, then sum
    ls -1 | pru size sum

    # select lines longer than 5 letters, then join with commas
    ls -1 | pru 'size > 5' 'join(",")'
    
## Inplace edit

    pru -i Gemfile 'sub /ruby/, "foo"'

## Install

```Bash
gem install pru
```

or standalone
```Bash
curl https://rubinjam.herokuapp.com/pack/pru > pru && chmod +x pru
./pru -v
```

## Options

    -r, --reduce CODE                reduce via CODE

    -I, --libdir DIR                 Add DIR to load path
        --require LIB                Require LIB (also comma-separated)
    -i, --inplace-edit FILE          Edit FILE inplace

    -h, --help                       Show this.
    -v, --version                    Show Version


## Examples

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
(or use standalone binary)

    rvm 2.7.7 exec gem install pru
    echo 'alias pru="rvm 2.7.2 exec pru"' >> ~/.bash_profile


[Contributors](http://github.com/grosser/pru/contributors)
=======
 - [John Hobbs](http://github.com/jmhobbs)
 - [Vasiliy Ermolovich](http://github.com/nashby)
 - [Jens Wille](http://blackwinter.de)
 - [SixArm](https://github.com/SixArm)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/pru.svg?branch=master)](https://travis-ci.org/grosser/pru)



