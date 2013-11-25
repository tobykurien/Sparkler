package com.tobykurien.sparkler

import spark.Request
import spark.Response
import spark.Route

/**
 * Implementation of Route to accept Xtend lambdas
 */
class SRoute extends Route {
   var (Request, Response)=>Object handler

   protected new(String path, (Request, Response)=>Object handler) {
      super(path)
      this.handler = handler
   }

   protected new(String path, String acceptType, (Request, Response)=>Object handler) {
      super(path, acceptType)
      this.handler = handler
   }

   override handle(Request req, Response res) {
      handler.apply(req, res)
   }
}
