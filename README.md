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

* [Xtend] a flexible and expressive dialect of Java, which compiles into readable Java 5 compatible source code. Think: CoffeeScript for Java
* [Spark] high-performance Sinatra-inspired web micro-framework
* [Jetty] high-performance embedded server (supports servlets, SPDY, WebSockets)
* [Mustache.java] for logic-less templating (with Django-style template inheritance)
* [ActiveJDBC] ActiveRecord-style ORM library (using a modified fork)
* [Apache DBCP] database connection pooling
* [Jackson] high-performance JSON processor

Features
------------

* Quick startup: simply Run/Debug as Java Application and it runs using an embedded Jetty server
* Quick turn-around: in Debug mode, hot code replacement is supported. Simply edit your code and reload the web page.
* Ruby-like code syntax thanks to Xtend
* Full IDE support in Eclipse (code-completion, refactoring, code formatting, etc.)
* High-performance: based on components like Spark, Jetty and Jackson that have proven themselves in the [TechEmpower Benchmarks].

Examples
------------

### Routing ###

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

### Templating ###

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

And in `templates/example1.html`:
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

Run it and access `http://localhost:4567/example1/hello` to get the output, 
which looks like:
```text
 The message is: hello

 Some additional stuff:

    1. Name: Alice
    2. Name: Bob 
```

#### Partials ####
You can include a template into another template, for example in `templates/main.html`:
```html
{{> my_partial}}
```

This would evaluate and include the contents of `templates/my_partial.html`, which would have 
access to all the variables in scope within `templates/main.html`.

#### Template Inheritance ####
Template inheritance is also supported by Mustache.java. You can create `templates/base.html` with:
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

You can now use that as a layout in `templates/example1.html` as follows:
```html
{{< base}}

{{$title}}Example 1{{/title}}

{{$content}}
  The overridden content
{{/content}}

{{/base}}
```

This works like the Jinja2 templating engine, where named blocks from the base file 
are overriden by the sub-template.

### Filters ###

You can add `before` and `after` filters to your routes for things like authentication. An example filter:
```xtend
   before("/admin") [ req, res, filter |
      var password = req.queryParams("password")
      if (!password.equals("openSesame")) {
         filter.haltFilter(401, "You are not welcome here!!!")
      }
   ]
```

### JSON RESTful API interfaces ###

You can quickly and easily create JSON RESTful API for data stored in a database as follows:
```xtend
class Book extends Model {
   // data model is inferred from the database
}

class JsonRestApi {
   def static void main(String[] args) {
      DatabaseManager.init(JsonRestApi.package.name) // init db with package containing db models
      val book = Model.with(Book) // get reference to ModelContext for Book
      
      // Gets all available book resources (id's)
      get(new JsonTransformer("/books") [req, res|
         book.findAll
      ])
      
      // Creates a new book resource
      // author and title are sent as query parameters e.g. /books?author=Foo&title=Bar
      put(new JsonTransformer("/books") [req, res|
         book.createIt(
            "title", req.queryParams("title"),
            "author", req.queryParams("author"))     
      ])
      
      // and so on for update, delete (see Example 2)      
   }
}      
```

The `JsonTransformer` class provides the database connection, and will automatically convert Model 
objects (and lists, or any other type of object) into JSON, as well as handle errors, etc.

To configure the database, edit the `/config/database.yml` file. By default, Sparkler will use the embedded H2 
database (which works like Sqlite). Running `java -jar libs/h2-1.3.174.jar` from the project root will 
allow you to manage your database.

### Environments ###

You can run Sparkler in various environments, e.g. development, test, or production. By default, Sparkler 
runs in "production" mode. To run in "development" mode, add `-Denvironment=development` to your java 
startup arguments.

Getting Started
----------------

To use Sparkler in it's current state: 

* Install Eclipse with the Xtend compiler (http://www.eclipse.org/xtend/download.html)
* Download a ZIP release from the releases folder (https://github.com/tobykurien/Sparkler/tree/master/releases)
* Unzip this into a folder
* From the unzipped folder, run: `./scripts/sparkler.sh app:init com.yourpackage.MainClassName`
* A Sparkler project is now created for you. At this point, you should import the project into Eclipse and open 
  the MainClassName.xtend and examine it. It should compile at this point, creating a src/main/xtend-gen source folder.
* You can now run your app from the command line: `./scripts/dev_server.sh` or from Eclipse by right-clicking your 
  MainClassName.xtend class and selecting Run As > Java Application (don't forget to add the -Devnironment=development 
  to the VM arguments if you are developing).
  
Database:
* You can create a database schema by defining the CREATE SQL statements in `config/database.schema`
* Now create the database by running `./scripts/sparkler.sh db:init development`. If you haven't changed 
  `config.database.yml`, this should create an H2 database in `db/development.db`
* You can now use the database as per Example 2. (https://github.com/tobykurien/Sparkler/tree/master/src/examples/java/com/tobykurien/sparkler_example)

Deployment
----------------

Sparkler applications are self-contained, so they can be copied to a server that has Java 1.7+, and 
run from there using the embedded Jetty. You can also deploy the application into a servlet container like 
Tomcat/Resin/Jetty - see here for details: http://sparkjava.com/readme.html#title17

References
------------

Refer to the following links for documentation on the various technologies used in 
Sparkler that you can access:

* Xtend language: http://www.eclipse.org/xtend/documentation.html
* Spark Java framework: http://sparkjava.com/readme.html
* Mustache.js templating: http://mustache.github.io/mustache.5.html
* ActiveJDBC ORM: http://javalt.org/p/activejdbc
* SnakeYAML for parsing YAML files: http://code.google.com/p/snakeyaml/wiki/Documentation
* Jackson JSON processor: https://github.com/FasterXML/jackson-docs

Limitations
-------------

Sparkler is currently work-in-progress. Here are some notable limitations:

* Maven build doesn't currently work. You need to use Eclipse with Xtend compiler installed, or use the pre-build releases.
* Test environment not supported yet (doesn't delete and re-create the database).
* Migrations not yet supported.
* No REPL.

License
----------

MIT


  [TechEmpower Benchmarks]: http://www.techempower.com/benchmarks/
  [Xtend]: http://xtend-lang.org
  [Spark]: http://sparkjava.com
  [Jetty]: http://www.eclipse.org/jetty/
  [Mustache.java]: https://github.com/spullara/mustache.java
  [activejdbc]: https://github.com/tobykurien/activejdbc
  [Jackson]: https://github.com/FasterXML/jackson
  [Carbon 5]: https://code.google.com/p/c5-db-migration/
  [Apache DBCP]: https://commons.apache.org/proper/commons-dbcp/
