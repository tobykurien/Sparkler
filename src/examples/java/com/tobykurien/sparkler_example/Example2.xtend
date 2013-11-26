package com.tobykurien.sparkler_example

import com.tobykurien.sparkler.db.Model

import static com.tobykurien.sparkler.Sparkler.*
import com.tobykurien.sparkler.transformer.JsonModelTransformer

/**
 * A simple RESTful example showing howto create, get, update and delete book resources.
 * @see http://code.google.com/p/spark-java/#Examples
 */
class Example2 {
   def static void main(String[] args) {
      // Gets all available book resources (id's)
      get(new JsonModelTransformer("/books") [req, res|
         // JsonModelTransform can take a Model (or LazyList of Models) and generate JSON
         Book.findAll
      ])
       
      // Gets the book resource for the provided id
      get(new JsonModelTransformer("/books/:id") [req, res|
         Book.findById(req.params("id")) as Book
      ])
      
      // Creates a new book resource, will return the ID to the created resource
      // author and title are sent as query parameters e.g. /books?author=Foo&title=Bar
      post(new JsonModelTransformer("/books") [req, res|
         Book.createIt(#{
            "title" -> req.queryParams("title"),
            "author" -> req.queryParams("author")
         }) as Book         
      ])
      
      // Updates the book resource for the provided id with new information
      // author and title are sent as query parameters e.g. /books/<id>?author=Foo&title=Bar
      put(new JsonModelTransformer("/books/:id") [req, res|
         Book.findById(req.params("id"))?.set(
            "title, author",
            #[req.params("title"), req.params("author")]
         ).saveIt        
      ])
      
      // Deletes the book resource for the provided id 
      delete("/books/:id") [req, res|
         Book.findById(req.params("id")).delete
      ]
   }
}

/**
 * Books table in the database
 */
class Book extends Model {
   // data model is inferred from the database 
}