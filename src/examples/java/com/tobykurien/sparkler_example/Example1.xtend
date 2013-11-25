package com.tobykurien.sparkler_example

import static extension com.tobykurien.sparkler.Sparkler.*

class Example1 {
   def static void main(String[] args) {
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
         render("templates/example1.html", #{ 
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
