package com.tobykurien.sparkler_example

import spark.servlet.SparkApplication

import static com.tobykurien.sparkler.Sparkler.*

class Example1 implements SparkApplication {
   
   override init() {
      // these are optional initializers, must be set before routes
      setPort(4567) // port to bind on startup, default is 4567
      //staticFileLocation("/public") // this references static files inside JAR file
      externalStaticFileLocation("/var/www/public") // external static files (css, js, jpg)
      
      // Simplest example
      get("/") [req, res|
         "Hi there!"
      ]
      
      // Named parameters
      get("/hello/:name") [req, res|
         "Well hello there, " + req.params("name")
      ]
      
      // Rendering a Mustache template
      get("/example1/:message") [req, res|
         render("views/example1.html", #{ 
            "message" -> req.params("message"),
            "items" -> #[
               #{ "name" -> "Alice" },
               #{ "name" -> "Bob" }
            ]
         })
      ]
   }
   
   def static void main(String[] args) {
      new Example1().init();
   }
}
