package com.tobykurien.sparkler_example

import static extension com.tobykurien.sparkler.Sparkler.*

class Example1 {
   def static void main(String[] args) {
      // these are optional initializers, must be set before routes
      setPort(4567) // port to bind on startup, default is 4567
      staticFileLocation("/public") // where static files like images and javascript are served from
      
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
            ],
            "uppercase" -> [String s|
               s.toUpperCase
            ] 
         })
      ]
   }
}
