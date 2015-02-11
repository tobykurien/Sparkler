package com.tobykurien.sparkler.db

import org.eclipse.xtend.lib.macro.AbstractFieldProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

@Active(DbFieldProcessor)
annotation DbField {
}

class DbFieldProcessor extends AbstractFieldProcessor {

   override doTransform(MutableFieldDeclaration field, extension TransformationContext context) {
      // rename the field as it is not used directly
      val fieldName = field.simpleName
      field.simpleName = "_" + field.simpleName
      field.markAsRead
      
      // add synthetic init-method
      var getter = if(field.type.simpleName.equalsIgnoreCase("Boolean")) "is" else "get"
      field.declaringType.addMethod(getter + fieldName.upperCaseFirst) [
         visibility = Visibility::PUBLIC
         returnType = field.type
         // reassign the initializer expression to be the init method’s body
         // this automatically removes the expression as the field’s initializer
         body = [
            '''
               return («field.type») get("«fieldName»");
            '''
         ]
      ]

      // add a getter method which lazily initializes the field
      field.declaringType.addMethod("set" + fieldName.upperCaseFirst) [
         visibility = Visibility::PUBLIC
         returnType = context.primitiveVoid
         addParameter("value", field.type)
         body = [
            '''
               set("«fieldName»", value);
            ''']
      ]
      
   }
   
   def upperCaseFirst(String s) {
      s.toFirstUpper
   }
}
