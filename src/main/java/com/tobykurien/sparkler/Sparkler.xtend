package com.tobykurien.sparkler

import com.github.mustachejava.DefaultMustacheFactory
import java.io.StringWriter
import java.util.Map
import java.util.concurrent.Executors
import spark.Request
import spark.Response
import spark.Spark
import com.tobykurien.sparkler.transformer.JsonTransformer

class Sparkler {

   /**
    * Render a Mustache.java template
    */
   def static render(String template, Map<String, ? extends Object> scopes) {
      try {
         var writer = new StringWriter()
         var mf = new DefaultMustacheFactory()
         mf.setExecutorService(Executors.newCachedThreadPool())
         var mustache = mf.compile(template)
         mustache.execute(writer, scopes)
         writer.toString
      } catch (Exception e) {
         e.toString + "<br/>" + e.message + "<br/>" + e.stackTrace.toString
      }
   }

   // Extension methods for Spark's static methods, for easier syntax
   def static get(String path, (Request, Response)=>Object handler) {
      Spark.get(path, new SRoute(path, handler))
   }

   def static get(SRoute route) {
      Spark.get(route.path, route)
   }

   def static post(String path, (Request, Response)=>Object handler) {
      Spark.post(path, new SRoute(path, handler))
   }

   def static post(SRoute route) {
      Spark.post(route.path, route)
   }

   def static options(String path, (Request, Response)=>Object handler) {
      Spark.options(path, new SRoute(path, handler))
   }

   def static options(SRoute route) {
      Spark.options(route.path, route)
   }

   def static head(String path, (Request, Response)=>Object handler) {
      Spark.head(path, new SRoute(path, handler))
   }

   def static head(SRoute route) {
      Spark.head(route.path, route)
   }

   def static patch(String path, (Request, Response)=>Object handler) {
      Spark.patch(path, new SRoute(path, handler))
   }

   def static patch(SRoute route) {
      Spark.patch(route.path, route)
   }

   def static put(String path, (Request, Response)=>Object handler) {
      Spark.put(path, new SRoute(path, handler))
   }

   def static put(SRoute route) {
      Spark.put(route.path, route)
   }

   def static connect(String path, (Request, Response)=>Object handler) {
      Spark.connect(path, new SRoute(path, handler))
   }

   def static connect(SRoute route) {
      Spark.connect(route.path, route)
   }

   def static delete(String path, (Request, Response)=>Object handler) {
      Spark.delete(path, new SRoute(path, handler))
   }

   def static delete(SRoute route) {
      Spark.delete(route.path, route)
   }

   def static trace(String path, (Request, Response)=>Object handler) {
      Spark.trace(path, new SRoute(path, handler))
   }

   def static trace(SRoute route) {
      Spark.trace(route.path, route)
   }

   def static getJson(String path, (Request, Response)=>Object handler) {
      Spark.get(path, new JsonTransformer(path, handler))
   }

   def static postJson(String path, (Request, Response)=>Object handler) {
      Spark.post(path, new JsonTransformer(path, handler))
   }

   def static putJson(String path, (Request, Response)=>Object handler) {
      Spark.put(path, new JsonTransformer(path, handler))
   }

   def static deleteJson(String path, (Request, Response)=>Object handler) {
      Spark.delete(path, new JsonTransformer(path, handler))
   }

   def static before((Request, Response, SFilter)=>void handler) {
      Spark.before(new SFilter(handler))
   }

   def static before(String path, (Request, Response, SFilter)=>void handler) {
      Spark.before(new SFilter(path, handler))
   }

   def static before(String path, String acceptType, (Request, Response, SFilter)=>void handler) {
      Spark.before(new SFilter(path, acceptType, handler))
   }

   def static after((Request, Response, SFilter)=>void handler) {
      Spark.after(new SFilter(handler))
   }

   def static after(String path, (Request, Response, SFilter)=>void handler) {
      Spark.after(new SFilter(path, handler))
   }

   def static after(String path, String acceptType, (Request, Response, SFilter)=>void handler) {
      Spark.after(new SFilter(path, acceptType, handler))
   }

   def static setIpAddress(String ipAddress) {
      Spark.ipAddress(ipAddress)
   }

   def static setPort(int port) {
      Spark.port(port)
   }

   def static setSecure(String keystoreFile, String keystorePassword, String truststoreFile, String truststorePassword) {
      Spark.secure(keystoreFile, keystorePassword, truststoreFile, truststorePassword)
   }

   def static externalStaticFileLocation(String path) {
      Spark.externalStaticFileLocation(path)
   }

   def static staticFileLocation(String path) {
      Spark.staticFileLocation(path)
   }
}
