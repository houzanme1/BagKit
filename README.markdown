BagKit
======

a quick and dirty gui wrapper around bagit (Library of Congress Transfer Tools)

Building
--------

* install [jruby](http://jruby.org/) and [rawr](http://rawr.rubyforge.org/) if necessary
* run `jruby -S rake rawr:bundle:app` to build the mac app
* run `jruby -S rake rawr:bundle:exe` to build the windows app
* run `jruby -S rake -T` to view all tasks
