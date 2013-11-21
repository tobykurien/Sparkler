package com.tobykurien.sparkler

import spark.Filter
import spark.Request
import spark.Response
import spark.Route
import spark.Spark

class Sparkler {
   def static get(String path, (Request, Response)=>Object handler) {
      Spark.get(new SRoute(path, handler))
   }

   def static post(String path, (Request, Response)=>Object handler) {
      Spark.post(new SRoute(path, handler))
   }

   def static options(String path, (Request, Response)=>Object handler) {
      Spark.options(new SRoute(path, handler))
   }

   def static head(String path, (Request, Response)=>Object handler) {
      Spark.head(new SRoute(path, handler))
   }

   def static patch(String path, (Request, Response)=>Object handler) {
      Spark.patch(new SRoute(path, handler))
   }

   def static put(String path, (Request, Response)=>Object handler) {
      Spark.put(new SRoute(path, handler))
   }

   def static connect(String path, (Request, Response)=>Object handler) {
      Spark.connect(new SRoute(path, handler))
   }

   def static delete(String path, (Request, Response)=>Object handler) {
      Spark.delete(new SRoute(path, handler))
   }

   def static trace(String path, (Request, Response)=>Object handler) {
      Spark.trace(new SRoute(path, handler))
   }

   def static before(String path, (Request, Response)=>Object handler) {
      Spark.before(new SFilter(path, handler))
   }

   def static after(String path, (Request, Response)=>Object handler) {
      Spark.after(new SFilter(path, handler))
   }
   
   def static setIpAddress(String ipAddress) {
      Spark.setIpAddress(ipAddress)
   }

   def static setPort(int port) {
      Spark.setPort(port)
   }

   def static setSecure(String keystoreFile, String keystorePassword, 
      String truststoreFile, String truststorePassword) {
      Spark.setSecure(keystoreFile, keystorePassword, truststoreFile, truststorePassword)
   }

   def static externalStaticFileLocation(String path) {
      Spark.externalStaticFileLocation(path)
   }
   
   def static staticFileLocation(String path) {
      Spark.staticFileLocation(path)
   }
}

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
