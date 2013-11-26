package com.tobykurien.sparkler

import spark.Request
import spark.Response

class Helper {
   def static handleError(Request request, Response response, Exception e) {
      response.status(500)
      e.class.name + ": " + e.message + "<br/>" + e.stackTrace.join("<br/>")
   }
   
   def static getEnvironment() {
      var ret = System.getProperty("environment")
      if (ret == null) ret = "production"
      //System.out.println("Using environment: " + ret)
      ret
   }
}