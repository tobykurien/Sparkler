package org.javalite.activejdbc;

import java.util.List;

import org.javalite.activejdbc.validation.*;

public class ModelContext<T extends Model> {
  private Class<T> cls;

  public ModelContext(Class<T> cls) {
    this.cls = cls;
  }

  public LazyList<T> where(String subquery, Object... params) {
    return Model.where(cls, subquery, params);
  }

  public void findWith(@SuppressWarnings("rawtypes") final ModelListener listener, String query, Object... params) {
    Model.findWith(cls, listener, query, params);
  }

  public int deleteAll() {
    return Model.deleteAll(cls);
  }

  public T createIt(Object... namesAndValues) {
    return Model.createIt(cls, namesAndValues);
  }

  public T create(Object... namesAndValues) {
    return Model.create(cls, namesAndValues);
  }

  public LazyList<T> findBySQL(String fullQuery, Object... params) {
    return Model.findBySQL(cls, fullQuery, params);
  }

  public T findFirst(String subQuery, Object... params) {
    return Model.findFirst(cls, subQuery, params);
  }

  public T first(String subQuery, Object... params) {
    return findFirst(subQuery, params);
  }

  public LazyList<T> findAll() {
    return Model.findAll(cls);
  }
  public LazyList<T> all(){
    return this.findAll();
  }

  public LazyList<T> find(String subquery, Object... params) {
    return Model.find(cls, subquery, params);
  }

  public T findById(Object id) {
    return Model.findById(cls, id);
  }

  public int delete(String query, Object... params) {
    return Model.delete(cls, query, params);
  }

  public Long count() {
    return Model.count(cls);
  }

  public Long count(String query, Object... params){
    return Model.count(cls, query, params);
  }
  public int updateAll(String updates, Object... params) {
    return update(updates, null, params);
  }

  public int update(String updates, String conditions, Object... params) {
    return Model.update(cls, updates, conditions, params);
  }
  
  public boolean exists(Object id){
    return Model.exists(cls, id);
  }
  public List<Association> associations(){
    return Model.associations(cls);
  }
  public boolean belongsTo(Class<? extends Model> targetClass) {
    return Model.belongsTo(cls, targetClass);
  }
  public void purgeCache(){
    Model.purgeCache(cls);
  }
  public String getTableName(){
    return Model.getTableName(cls);
  }
  public MetaModel getMetaModel(){
    return Model.getMetaModel(cls);
  }
  public List<String> attributes(){
    return Model.attributes(cls);
  }
  public ValidationBuilder addValidator(Validator validator){
    return Model.addValidator(cls, validator);
  }
  public void removeValidator(Validator validator){
    Model.removeValidator(cls, validator);
  }
}
