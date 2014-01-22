package com.tobykurien.sparkler.db

import org.eclipse.xtend.lib.macro.AbstractFieldProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.TypeReference
import org.eclipse.xtend.lib.macro.declaration.Visibility

@Active(DbFieldProcessor)
annotation DbField {
}

class DbFieldProcessor extends AbstractFieldProcessor {

   override doTransform(MutableFieldDeclaration field, extension TransformationContext context) {
//      if (field.initializer == null)
//         field.addError("A Preference field must have an initializer.")

      // add synthetic init-method
      var getter = if(field.type.simpleName.equalsIgnoreCase("Boolean")) "is" else "get"
      field.declaringType.addMethod(getter + field.simpleName.upperCaseFirst) [
         visibility = Visibility::PUBLIC
         returnType = field.type
         // reassign the initializer expression to be the init method’s body
         // this automatically removes the expression as the field’s initializer
         body = [
            '''
               return («field.type») get("«field.simpleName»");
            '''
         ]
      ]

      // add a getter method which lazily initializes the field
      field.declaringType.addMethod("set" + field.simpleName.upperCaseFirst) [
         visibility = Visibility::PUBLIC
         returnType = context.primitiveVoid
         addParameter("value", field.type)
         body = [
            '''
               set("«field.simpleName»", value);
            ''']
      ]
   }
   
   def upperCaseFirst(String s) {
      s.toFirstUpper
   }
}
