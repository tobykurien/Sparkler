package com.tobykurien.sparkler

import spark.Request
import spark.Response
import com.tobykurien.sparkler.utils.Log

class Helper {
   var static String env = null
   
   def static handleError(Request request, Response response, int status, Exception e) {
      response.status(status)
      e.class.name + ": " + e.message + "<br/>" + e.stackTrace.take(3).join("<br/>")
   }

   def static handleError(Request request, Response response, Exception e) {
      handleError(request, response, 500, e)
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
      
      Log.i("env", "Using environment " + env)
      return env
   }
}
