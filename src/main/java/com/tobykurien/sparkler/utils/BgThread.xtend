package com.tobykurien.sparkler.utils

/**
 * Convert Xtend closure to Thread. Usage:
 * 
 *    new BgThread [
 *       // code for run() method here
 *    ].start()
 * 
 */ 
class BgThread extends java.lang.Thread {
   val (Void)=>void closure
   
   new((Void)=>void closure) {
      this.closure = closure   
   }
   
   override run() {
      closure.apply(null)
   }   
}
