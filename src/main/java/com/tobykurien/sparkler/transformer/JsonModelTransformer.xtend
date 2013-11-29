package com.tobykurien.sparkler.transformer

import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.db.DatabaseManager
import com.tobykurien.sparkler.db.Model
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.LazyList
import spark.Request
import spark.Response
import spark.ResponseTransformerRoute

/**
 * Returns a JSON serialized version of Model objects
 */
class JsonModelTransformer extends ResponseTransformerRoute {
   var (Request, Response)=>Object handler
   
   new(String path, (Request, Response)=>Object handler) {
      super(path, "application/json")
      this.handler = handler      
   }
   
   override render(Object json) {
      return json.toString
   } 
   
   def escapeString(String s) {
      s.replace("'", "\\'")      
   }
   
   override handle(Request request, Response response) {
      response.type("application/json")
      
      try {
         Base.open(DatabaseManager.newDataSource)
         var model = handler.apply(request, response)
         
         if (model == null) {
            response.status(404)
            "{'error': 'Object not found'}"
         } else {
            if (model instanceof Model) {
               return (model as Model).toJson(false)
            } else if (model instanceof LazyList) {
               return (model as LazyList).toJson(false)
            } else if (model == null) {
               null
            } else {
               '''{ 'result': '«model.toString.escapeString»' }'''
            }         
         }
      } catch (Exception e) {
         var error = Helper.handleError(request, response, e)
         '''{'error': '«error.escapeString»'}'''
      } finally {
         Base.close()
      }
   }
}