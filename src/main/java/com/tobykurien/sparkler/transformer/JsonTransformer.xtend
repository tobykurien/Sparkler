package com.tobykurien.sparkler.transformer

import com.fasterxml.jackson.databind.ObjectMapper
import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.db.DatabaseManager
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.LazyList
import org.javalite.activejdbc.Model
import spark.Request
import spark.Response
import spark.ResponseTransformerRoute

/**
 * Returns a JSON serialized version of Model objects
 */
class JsonTransformer extends ResponseTransformerRoute {
   var (Request, Response)=>Object handler
   
   new(String path, (Request, Response)=>Object handler) {
      super(path, "application/json")
      this.handler = handler      
   }
   
   override render(Object json) {
      return json.toString
   } 
   
   def escapeString(String s) {
      s.replace("\"", "\\\"")     
   }

   def returnError(Request request, Response response, int statusCode, Exception e) {
      var error = Helper.handleError(request, response, statusCode, e)
      System.err.println(error)
      "{\"error\" : \""+ error.escapeString + "\"}"
   }
   
   override handle(Request request, Response response) {
      response.type("application/json")

      try {
         Base.open(DatabaseManager.newDataSource)
         var model = handler.apply(request, response)

         if (model == null) {
            response.status(404)
            "{\"error\": \"Object not found\"}"
         } else {
            if (model instanceof Model) {
               return new ObjectMapper().writeValueAsString(
                  (model as Model).toMap
               )
            } else if (model instanceof LazyList) {
               return new ObjectMapper().writeValueAsString(
                  (model as LazyList).toMaps
               )
            } else {
               new ObjectMapper().writeValueAsString(model);
            }
         }
      } catch (RestfulException e) {
         returnError(request, response, e.status, e)
      } catch (Exception e) {
         returnError(request, response, 500, e)
      } finally {
         Base.close()
      }
   }
}
