Sparkler web framework
======================

As evident from the [TechEmpower Benchmarks], Java is significantly (often orders of magnitude) 
faster than other, more developer-friendly web frameworks like Django, Rails, or node.js. 
This means that you disadvantage yourself by creating web startups using these technologies, 
as scaling becomes a problem quite quickly, and scaling is not an easy problem to solve.

Sparkler is an attempt to bring developer-friendliness to Java web development by 
using Rails/Sinatra-style Java libraries/frameworks together with [Xtend] to provide 
syntactic sugar and other fun language features (like extension methods and lambdas). 
The result should be the best of both worlds: incredible performance with a 
developer-friendly framework. The idea is that Sparkler will be fun enough for use in 
hackathons, as a web startup prototyping tool, and a quick way to get RESTful JSON 
backends up.

Tech
-----------

Sparkler uses best-of-breed technologies and is (currently) based on:

* [Xtend] - is a flexible and expressive dialect of Java, which compiles into readable Java 5 compatible source code. Think: CoffeeScript for Java
* [Spark] high-performance Sinatra-inspired web framework
* [Jetty] high-performance embedded server (supports servlets, SPDY, WebSockets)
* [Mustache.java] for logic-less templating (with Django-style template inheritance)
* [ActiveJDBC] ActiveRecord-style ORM library (using a modified fork)
* [Apache DBCP] database connection pooling

Planned integrations:
* [Jackson] high-performance JSON processor
* [Carbon 5] database migrations

Features
------------

* Quick startup: simply Run/Debug as Java Application and it runs using an embedded Jetty server
* Quick turn-around: in Debug mode, hot code replacement is supported. Simply edit your code and reload the web page.
* Ruby-like code syntax thanks to Xtend
* Full IDE support in Eclipse (code-completion, refactoring, code formatting, etc.)
* High-performance: based on high-performance components like Spark, Jetty and Jackson.

Examples
------------

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

Run it and access http://localhost:4567/example1/hello to get the output, 
which looks like:
```text
 The message is: hello

 Some additional stuff:

    1. Name: Alice
    2. Name: Bob 
```

Partials and template inheritance are also supported by Mustache.java. You can 
create templates/base.html with:
```html
<html>
<head><title>{{$title}}Sparkler examples{{/title}}</title></head>
<body>
   <b>Header from base</b>
   <p/>
   {{$content}}
     Default base content.
   {{/content}}
   <p/>
   Footer from base.
</body>
</html>
```

You can now use that as a layout in templates/example1.html as follows:
```html
{{< base}}

{{$title}}Example 1{{/title}}

{{$content}}
  The overridden content
{{/content}}

{{/base}}
```

This works like the Jinja2 templating engine, where named sections from the base file 
are overriden by the sub-template.

Getting Started
----------------

To use Sparkler in it's current state: 

* Install Eclipse with the Xtend compiler (http://www.eclipse.org/xtend/download.html)
* Clone this repository and import into Eclipse as a Java project
* You should now be able to run the examples from the src/examples source tree, and 
  create your own project using Sparkler. As an example, right-click on Example1.java
  and select Run As > Java Application, then open a browser to http://localhost:4567/

References
------------

Refer to the following links for documentation on the various technologies used in 
Sparkler:

* Spark Java framework: http://sparkjava.com/readme.html
* Mustache.js templating: http://mustache.github.io/mustache.5.html
* Xtend language: http://www.eclipse.org/xtend/documentation.html

Limitations
-------------

Sparkler is currently work-in-progress. Here are some notable limitations:

* Maven build doesn't currently work. You need to use Eclipse with Xtend compiler installed.
* No REPL. This could be added later using JRuby, Bean Shell Scripting, or similar.

License
----------

MIT


  [TechEmpower Benchmarks]: http://www.techempower.com/benchmarks/
  [Xtend]: http://xtend-lang.org
  [Spark]: http://sparkjava.com
  [Jetty]: http://www.eclipse.org/jetty/
  [Mustache.java]: https://github.com/spullara/mustache.java
  [activejdbc]: https://code.google.com/p/activejdbc/
  [Jackson]: https://github.com/FasterXML/jackson
  [Carbon 5]: https://code.google.com/p/c5-db-migration/
  [Apache DBCP]: https://commons.apache.org/proper/commons-dbcp/