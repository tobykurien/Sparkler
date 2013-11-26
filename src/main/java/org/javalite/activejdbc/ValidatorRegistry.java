package org.javalite.activejdbc;

import java.util.*;

import org.javalite.activejdbc.validation.Validator;

public enum ValidatorRegistry {
  INSTANCE;
  private final static HashMap<String, List<Validator>> validators = new HashMap<String, List<Validator>>();

  public static ValidatorRegistry instance(){
    return INSTANCE;
  }

  protected List<Validator> getValidators(String daClass) {

    //TODO: this can be optimized - cached
    List<Validator> validatorList = validators.get(daClass);
    if (validatorList == null) {
      validatorList = new ArrayList<Validator>();
      validators.put(daClass, validatorList);
    }
    return validatorList;
  }

  @Deprecated
  public void addValidators(Class<? extends Model> daClass, List<? extends Validator> modelValidators) {
    getValidators(daClass.getName()).addAll(modelValidators);
  }

  public void addValidators(String daClass, List<? extends Validator> modelValidators) {
    getValidators(daClass).addAll(modelValidators);
  }

  public void removeValidator(Class<? extends Model> daClass, Validator validator) {
    getValidators(daClass.getName()).remove(validator);
  }

}
