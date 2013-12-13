package com.tobykurien.sparkler.transformer

import java.lang.Exception

/**
 * Exception that takes a response code
 */
class RestfulException extends Exception {
   public val int status
   
   new(int status) {
      super()
      this.status = status
   }
   
   new(int status, String arg0) {
      super(arg0)
      this.status = status
   }
   
   new(int status, String arg0, Throwable arg1) {
      super(arg0, arg1)
      this.status = status
   }
   
   protected new(int status, String arg0, Throwable arg1, boolean arg2, boolean arg3) {
      super(arg0, arg1, arg2, arg3)
      this.status = status
   }
   
   new(int status, Throwable arg0) {
      super(arg0)
      this.status = status
   }
   
}