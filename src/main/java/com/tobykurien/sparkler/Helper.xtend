package com.tobykurien.sparkler

import spark.Request
import spark.Response

class Helper {
   var static env = null
   
   def static handleError(Request request, Response response, Exception e) {
      response.status(500)
      e.class.name + ": " + e.message + "<br/>" + e.stackTrace.join("<br/>")
   }

   def static setEnvironment(String environ) {
      env = environ
   }
   
   def static getEnvironment() {
      if (env != null) {
         return env
      }
      
      var ret = System.getProperty("environment")
      if (ret == null) ret = "production"
      env = ret
      
      System.out.println("Using environment " + env)
      return env
   }
}