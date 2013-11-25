package com.tobykurien.sparkler

import spark.Filter
import spark.Request
import spark.Response

/**
 * Implementation of Filter to accept Xtend lambdas
 */
class SFilter extends Filter {
   var (Request, Response)=>Object handler

   protected new((Request, Response)=>Object handler) {
      super()
      this.handler = handler
   }

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