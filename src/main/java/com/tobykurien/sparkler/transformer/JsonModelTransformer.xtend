package com.tobykurien.sparkler.transformer

import com.tobykurien.sparkler.db.Model
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
      if (model instanceof Model) {
         return (model as Model).toJson(false)
      } else if (model instanceof LazyList) {
         return (model as LazyList).toJson(false)
      } else {
         throw new UnsupportedOperationException("Not implemented for generic objects yet")
      }
   } 
   
   override handle(Request request, Response response) {
      handler.apply(request, response)
   }
}