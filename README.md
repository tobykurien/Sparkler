Sparkler web framework
======================

As evident from the [TechEmpower Benchmarks], Java is significantly faster than other, more developer-friendly web frameworks like Django, Rails, or node.js. 

Sparkler is an attempt to bring developer-friendliness to Java web development by using Rails/Sinatra-style Java libraries/frameworks together with [Xtend] to provide the syntactic sugar and other nice language features. The result should be the best of both worlds: incredible performance with a developer-friendly framework to make Java web development fun.

Tech
-----------

Sparkler is based on (or planning to be based on):

* [Spark] web framework
* [ActiveJDBC] ORM library

Example
--------

Here's a basic (but complete) example of using Sparkler:

```xtend
import static extension com.tobykurien.sparkler.Sparkler.*

class Main {
   def static void main(String[] args) {
      get("/", [req, res|
         "Hi there!"
      ])
      
      get("/hello/:name", [req, res|
         "Well hello, " + req.params("name")
      ])
   }
}
```


License
-

MIT


  [TechEmpower Benchmarks]: http://www.techempower.com/benchmarks/
  [Xtend]: http://xtend-lang.org
  [Spark]: http://sparkjava.com
  [activejdbc]: https://code.google.com/p/activejdbc/
