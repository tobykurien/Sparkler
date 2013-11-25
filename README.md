Sparkler web framework
======================

As evident from the [TechEmpower Benchmarks], Java is significantly faster than other, more developer-friendly web frameworks like Django, Rails, or node.js. 

Sparkler is an attempt to bring developer-friendliness to Java web development by using Rails/Sinatra-style Java libraries/frameworks together with Xtend to provide syntactic sugar and other fun language features (like extension methods and lambdas). The result should be the best of both worlds: incredible performance with a developer-friendly framework to make Java web development fun.

Tech
-----------

Sparkler is based on:

* [Spark] web framework
* [Mustache.java] for templating (with Django-style template inheritance)
* [ActiveJDBC] ORM library

Example
--------

Here's a basic (but complete) example of using Sparkler:

```xtend
import static extension com.tobykurien.sparkler.Sparkler.*

class Main {
   def static void main(String[] args) {
      // Simplest example
      get("/") [req, res|
         "Hi there!"
      ]
      
      // Using named parameters
      get("/hello/:name") [req, res|
         "Well hello, " + req.params("name")
      ]
   }
}
```

An example of using the templating system:
```xtend
   // Rendering a Mustache template
   get("/example1/:message") [req, res|
      render("templates/example1.html", #{ 
         "message" -> req.params("message"),
         "items" -> #[
            #{ "name" -> "Alice" },
            #{ "name" -> "Bob" }
         ] 
      })
   ]
```

And in templates/example1.html:
```html
<html>
<head><title>Example 1</title></head>
<body>
   The message is: {{message}}
   <p/>
   Some additional stuff:
   <ol>
      {{#items}}
        <li> Name: {{name}}
      {{/items}}
   </ol>
</body>
```

Partials and template inheritance are also supported by Mustache.java.


License
-

MIT


  [TechEmpower Benchmarks]: http://www.techempower.com/benchmarks/
  [Xtend]: http://xtend-lang.org
  [Spark]: http://sparkjava.com
  [Mustache.java]: https://github.com/spullara/mustache.java
  [activejdbc]: https://code.google.com/p/activejdbc/
