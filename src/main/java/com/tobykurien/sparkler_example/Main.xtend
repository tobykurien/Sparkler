package com.tobykurien.sparkler_example

import static extension com.tobykurien.sparkler.Sparkler.*

class Main {
   def static void main(String[] args) {
      get("/") [req, res|
         "Hi there!"
      ]
      
      get("/hello/:name") [req, res|
         "Well hello, " + req.params("name")
      ]
   }
}
