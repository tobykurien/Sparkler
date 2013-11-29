package com.tobykurien.sparkler.tools

/**
 * Used by the scripts to generate Sparkler apps, views, db migrations, etc.
 */
class SparklerTools {


   def static void main(String[] args) {
      System.out.println("Sparkler v0.01\r\n")
      
   	if (args.length == 0) {
   	   System.out.println('''
Please supply a command argument. Commands are:

* db:init - initialize database with current config/database.schema
* console - open a REPL
* test    - run test suite
   	   ''')
   	   return
   	}
   	
   	val command = args.get(0)
   	switch (command.toLowerCase) {
   	   case "db:init": {
   	      // TODO
   	   }
   	   
   	   default: {
   	      System.err.println('''Unknown or unimplemented command "«command»"''')
   	   }
   	}
   }
}