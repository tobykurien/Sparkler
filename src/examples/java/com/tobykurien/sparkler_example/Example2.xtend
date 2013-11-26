package com.tobykurien.sparkler_example

import com.tobykurien.sparkler.db.Model

import static com.tobykurien.sparkler.Sparkler.*

/**
 * A simple RESTful example showing howto create, get, update and delete book resources.
 * @see http://code.google.com/p/spark-java/#Examples
 */
class Example2 {
   def static void main(String[] args) {
      // Gets all available book resources (id's)
      get("/books") [req, res|
         
      ]
       
      // Gets the book resource for the provided id
      get("/books/:id") [req, res|
         
      ]
      
      // Creates a new book resource, will return the ID to the created resource
      // author and title are sent as query parameters e.g. /books?author=Foo&title=Bar
      post("/books") [req, res|
         
      ]
      
      // Updates the book resource for the provided id with new information
      // author and title are sent as query parameters e.g. /books/<id>?author=Foo&title=Bar
      put("/books/:id") [req, res|
         
      ]
      
      // Deletes the book resource for the provided id 
      delete("/books/:id") [req, res|
         
      ]
   }
}

/**
 * Books table in the database
 */
class Books extends Model {
   // data model is inferred from the database, see the migration for details  
}