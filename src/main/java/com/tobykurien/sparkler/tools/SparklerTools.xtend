package com.tobykurien.sparkler.tools

/**
 * Used by the scripts to generate Sparkler apps, views, db migrations, etc.
 */
class SparklerTools {

   /**
    * Print help for the various Sparkler tool commands
    */
   def static help() {
      System.out.println('''
Please supply a command argument. Commands are:

* app:init <package and class>
     Create a new app entry point. This will create the class and configure it in web.xml. Note that previous
     contents of web.xml will be overwritten!
     e.g.: app com.tobykurien.example.Example1
* db:init [environment]
     initialize database with current config/database.schema. The database settings are read
     from config/database.yml. By default, it will run in production mode unless environment
     is specified.
* console 
     open a REPL
* test    
     run test suite
      ''')
   }

   /**
    * Main entry point to the Sparkler tool
    */
   def static void main(String[] args) {
      val db = new Database
      val app = new App
      
      System.out.println("Sparkler v0.0.1\r\n")
      
   	if (args.length == 0) {
   	   help
   	   return
   	}
   	
   	try {
         val command = args.get(0)
         switch (command.toLowerCase) {
            case "app:init": app.init(args.drop(1))
            case "db:init": db.init(args.drop(1))
            default: {
               System.err.println('''Unknown or unimplemented command "«command»"''')
            }
         }
      } catch (Exception e) {
         System.err.println("ERROR: " + e.message)   	   
   	}
   	
   	System.out.println("Done.")
   }
}