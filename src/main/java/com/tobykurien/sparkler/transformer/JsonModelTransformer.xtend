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
   
   override render(Object model) {
      Base.open(DatabaseManager.newDataSource)
      try {
         if (model instanceof Model) {
            return (model as Model).toJson(false)
         } else if (model instanceof LazyList) {
            return (model as LazyList).toJson(false)
         } else if (model == null) {
            ""
         } else {
            model.toString
         }         
      } finally {
         Base.close()
      }
   } 
   
   override handle(Request request, Response response) {
      try {
         Base.open(DatabaseManager.newDataSource)
         handler.apply(request, response)
      } catch (Exception e) {
         Helper.handleError(request, response, e)
      } finally {
         Base.close()
      }
   }
}