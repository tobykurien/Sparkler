package com.tobykurien.sparkler.utils

import org.slf4j.Logger
import org.slf4j.LoggerFactory

/**
 * Simple Android-style logging for Sparkler. To use:
 * 
 *    Log.i("temp", "The temperature is {} with a max of {}", temperature, maxTemp)
 *
 * The output goes to System.err by default (uses SLF4J SimpleLogger)
 * @see http://www.slf4j.org/api/org/slf4j/impl/SimpleLogger.html
 */
class Log {
   // one static Logger to improve performance, although you loose configurability
   val static Logger logger = LoggerFactory.getLogger("Sparkler") 

   // A searchable tag prefix for filtering the log output
   def static tagPrefix(String tag) {
      '''#[«tag»] '''
   }

   def static t(String tag, String message, Object... args) {
      logger.trace(tag.tagPrefix + message, args)
   }

   def static d(String tag, String message, Object... args) {
      logger.debug(tag.tagPrefix  + message, args)
   }

   def static i(String tag, String message, Object... args) {
      logger.info(tag.tagPrefix  + message, args)
   }

   def static w(String tag, String message, Object... args) {
      logger.warn(tag.tagPrefix  + message, args)
   }

   def static t(String tag, String message, Exception e) {
      logger.trace(tag.tagPrefix  + message, e)
   }

   def static d(String tag, String message, Exception e) {
      logger.debug(tag.tagPrefix  + message, e)
   }

   def static i(String tag, String message, Exception e) {
      logger.info(tag.tagPrefix  + message, e)
   }

   def static w(String tag, String message, Exception e) {
      logger.warn(tag.tagPrefix  + message, e)
   }

   def static e(String tag, String message, Exception e) {
      logger.error(tag.tagPrefix  + message, e)
   }
}