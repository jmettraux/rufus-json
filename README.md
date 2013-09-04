
# rufus-json

One interface for various JSON Ruby backends.

```ruby
require 'rubygems'

# load your favourite JSON backend
require 'yajl'
#require 'json'
#require 'active_support'

require 'rufus-json' # gem install rufus-json

p Rufus::Json.decode('{"a":2,"b":true}')
p Rufus::Json.load('{"a":2,"b":true}')
  # => { 'a' => 2, 'b' => true }

p Rufus::Json.encode({ 'a' => 2, 'b' => true })
p Rufus::Json.dump({ 'a' => 2, 'b' => true })
  # => '{"a":2,"b":true}'
```

If multiple libs are present, it will favour yajl-ruby and json, and then active_support. It's OK to force a backend.

```
Rufus::Json.backend = :yajl
#Rufus::Json.backend = :json
#Rufus::Json.backend = :active
```

To know if there is currently a backend set :

```ruby
Rufus::Json.has_backend?
```

It's OK to load a lib and force detection :

```ruby
require 'json'
Rufus::Json.detect_backend

p Rufus::Json.backend
  # => :json
```


There is a dup method, it may be useful in an all JSON system (flattening stuff that will anyway get flattened later).

```ruby
o = Rufus::Json.dup(o)
```


### require 'rufus-json/automatic'

```ruby
require 'rufus-json/automatic'
```

will require 'rufus-json' and load the first JSON lib available (in the order yajl, oj, jrjackson, active_support, json, json/pure.

It is equivalent to

```ruby
  require 'rufus-json'
  Rufus::Json.load_backend
```

(the .load_backend method accepts a list/order of backends to try).


## issue tracker

http://github.com/jmettraux/rufus-json/issues


## irc

irc.freenode.net #ruote


## authors

see [CREDITS.txt](CREDITS.txt)


## license

MIT, see [LICENSE.txt](LICENSE.txt)

