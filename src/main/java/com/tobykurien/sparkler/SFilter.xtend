package com.tobykurien.sparkler

import spark.Filter
import spark.Request
import spark.Response
import spark.Spark

/**
 * Implementation of Filter to accept Xtend lambdas
 */
class SFilter implements Filter {
   protected var (Request, Response, SFilter)=>void handler
   protected var String path
   protected var String acceptType

   protected new((Request, Response, SFilter)=>void handler) {
      this.handler = handler
   }

   protected new(String path, (Request, Response, SFilter)=>void handler) {
      this.handler = handler
      this.path = path
   }

   protected new(String path, String acceptType, (Request, Response, SFilter)=>void handler) {
      this.handler = handler
      this.path = path
      this.acceptType = acceptType
   }

   override handle(Request req, Response res) {
      handler.apply(req, res, this)
   }
   
   def haltFilter() {
      Spark.halt
   }

   def haltFilter(int code) {
      Spark.halt(code)
   }

   def haltFilter(String body) {
      Spark.halt(body)
   }

   def haltFilter(int code, String body) {
      Spark.halt(code, body)
   }
}