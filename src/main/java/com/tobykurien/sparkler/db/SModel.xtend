package com.tobykurien.sparkler.db

import org.javalite.activejdbc.Model

class SModel {
   def static findById(Model m, Object id) {
      Model.with(m.class).findById(id)
   }

   def static findAll(Model m) {
      Model.with(m.class).findAll
   }

   def static createIt(Model m, Object... params) {
      Model.with(m.class).createIt(params)
   }
}