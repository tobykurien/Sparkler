package com.tobykurien.sparkler_example

import com.tobykurien.sparkler.db.DatabaseManager
import com.tobykurien.sparkler.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import spark.servlet.SparkApplication

import static com.tobykurien.sparkler.Sparkler.*
import spark.Spark

/**
 * A simple RESTful example showing howto create, get, update and delete book resources.
 * The database configuration is stored in /config/database.yml
 * To initialize your database with the schema in /config/database.schema, 
 * run this from the project root:
 * 
 *    ./scripts/sparkler.sh db:init development
 * 
 * Manage the database by running (from project root): 
 * 
 *    java -jar libs/h2-1.3.174.jar
 * 
 * @see http://code.google.com/p/spark-java/#Examples
 */
class Example2 implements SparkApplication {

   override init() {
      DatabaseManager.init(Example2.package.name) // init db with package containing db models
      val book = Model.with(Book)
      
      // Gets all available book resources (id's)
      get(new JsonTransformer("/books") [req, res|
         // JsonTransform provides db connection, and can take a Model 
         // (or LazyList of Models) and generate JSON
         book.findAll
      ])
       
      // Gets the book resource for the provided id
      get(new JsonTransformer("/books/:id") [req, res|
         book.findById(req.params("id"))
      ])
      
      // Creates a new book resource, will return the ID to the created resource
      // author and title are sent as query parameters e.g. /books?author=Foo&title=Bar
      put(new JsonTransformer("/books") [req, res|
         book.createIt(
            "title", req.queryParams("title"),
            "author", req.queryParams("author"))     
      ])
      
      // Updates the book resource for the provided id with new information
      // author and title are sent as query parameters e.g. /books/<id>?author=Foo&title=Bar
      post(new JsonTransformer("/books/:id") [req, res|
         // JsonTransformer will return other data types as: {'result': '[object.toString]'}
         var b = book.findById(req.params("id"))
         if (b != null) {
           b.set(
             "title", req.queryParams("title"), 
             "author", req.queryParams("author"))
           b.saveIt
         }
         
         b
      ])
      
      // Deletes the book resource for the provided id 
      delete(new JsonTransformer("/books/:id") [req, res|
         book.findById(req.params("id"))?.delete
      ])
   }
   
   def static void main(String[] args) {
      new Example2().init
   }
}

/**
 * Books table in the database
 */
class Book extends Model {
   // data model is inferred from the database 
}

