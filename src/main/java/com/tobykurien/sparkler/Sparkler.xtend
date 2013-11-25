package com.tobykurien.sparkler

import com.github.mustachejava.DefaultMustacheFactory
import com.github.mustachejava.MustacheException
import java.io.StringWriter
import java.util.Map
import spark.Request
import spark.Response
import spark.Spark

class Sparkler {

   /**
    * Render a Mustache.java template
    */
   def static render(String template, Map<String, ? extends Object> scopes) {
      try {
         var writer = new StringWriter()
         var mf = new DefaultMustacheFactory()
         var mustache = mf.compile(template)
         mustache.execute(writer, scopes)
         writer.toString
      } catch (Exception e) {
         e.toString + "<br/>" + e.message + "<br/>" + e.stackTrace.toString
      }
   }

   // Extension methods for Spark's static methods, for easier syntax
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

   def static setSecure(String keystoreFile, String keystorePassword, String truststoreFile, String truststorePassword) {
      Spark.setSecure(keystoreFile, keystorePassword, truststoreFile, truststorePassword)
   }

   def static externalStaticFileLocation(String path) {
      Spark.externalStaticFileLocation(path)
   }

   def static staticFileLocation(String path) {
      Spark.staticFileLocation(path)
   }
}
