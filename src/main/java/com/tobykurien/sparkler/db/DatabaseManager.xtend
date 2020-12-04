package com.tobykurien.sparkler.db

import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.utils.Log
import java.io.FileInputStream
import java.util.Map
import java.util.Properties
import javax.sql.DataSource
import org.apache.commons.dbcp2.BasicDataSource
import org.javalite.activejdbc.LogFilter
import org.javalite.activejdbc.Registry
import org.yaml.snakeyaml.Yaml

class DatabaseManager {
	public var static Map<String, Object> dbConfig
	var static BasicDataSource bds = null;

	/**
	 * Initialize the database system
	 * 
	 * @param modelsPackageName - the root package where your database model classes
	 * are stored. Sub-packages will also be searched for database models.
	 */
	def static init(String modelsPackageName) {
		// initialize ActiveJDBC with correct parameters
		var p = new Properties
		p.put("model.loader.strategy", "auto")
		p.put("model.loader.package", modelsPackageName)
		// p.put("cache.manager", "") // add OSCache cache manager here
		Registry.instance.configuration.init(p)
		if (!"production".equalsIgnoreCase(Helper.environment)) {
			// log activejdbc queries only
			LogFilter.setLogExpression("Query\\:.*");
		}

		// load the database config
		var yaml = new Yaml()
		var config = yaml.load(new FileInputStream("config/database.yml")) as Map<String, Map<String, Object>>
		dbConfig = config.get(Helper.environment)

		Class.forName(getConfig("driver")) // load database driver
	}

	def static DataSource newDataSource() {
		if(dbConfig === null) throw new IllegalStateException("DatabaseManager.init() has not been called")
		newDataSource2(getConfig("driver"), getConfig("database"), getConfig("user"), getConfig("password"), null)
	}

	def static DataSource newDataSource(Properties props) {
		if(dbConfig === null) throw new IllegalStateException("DatabaseManager.init() has not been called")
		newDataSource2(getConfig("driver"), getConfig("database"), getConfig("user"), getConfig("password"), props)
	}

	private synchronized def static DataSource newDataSource2(String driver, String uri, String user, String password,
		Properties properties) {
		if(bds !== null) return bds;

		val props = properties.clone() as Properties;
		bds = new BasicDataSource();
		bds.setDriverClassName(driver);
		bds.setUrl(uri);
		bds.setMaxTotal(getMaxActive(props));
		bds.setMaxIdle(getMaxIdle(props));

		Log.d("DB", "Max active connections: " + getMaxActive(props));
		Log.d("DB", "Max idle connections: " + getMaxIdle(props));

		if (props === null) {
			bds.setUsername(user);
			bds.setPassword(password);
		} else {
			if (props.get("user") === null) {
				props.put("user", user)
				props.put("password", password)
			}

			// BasicDataSource uses "setUserName" instead of "setUser"
			props.setProperty("username", props.get("user") as String)
			props.remove("user")
			props.remove("maxActive") // already parsed above
			props.remove("maxIdle") // already parsed above
			// apply properties using reflection
			var iter = props.propertyNames
			while (iter.hasMoreElements) {
				val key = iter.nextElement as String
				var m = bds.class.getDeclaredMethod("set" + key.toFirstUpper, props.get(key).class);
				if (m !== null) {
					m.invoke(bds, props.get(key))
				}
			}
		}

		return bds;
	}

	def static String toFirstUpper(String s) {
		s.substring(0, 1).toUpperCase + s.substring(1)
	}

	private def static int getMaxActive(Properties props) {
		if (props === null || props.get("maxActive") === null) {
			dbConfig.get("max_active") as Integer;
		} else {
			props.get("maxActive") as Integer
		}
	}

	private def static int getMaxIdle(Properties props) {
		if (props === null || props.get("maxIdle") === null) {
			dbConfig.get("max_idle") as Integer
		} else {
			props.get("maxIdle") as Integer
		}
	}

	private def static String getConfig(String key) {
		switch value: dbConfig.get(key) {
			String case value.startsWith("$"):
				if (System.getenv(value.substring(1)) !== null) {
					// get the parameter from the environment
					return System.getenv(value.substring(1));
				} else {
					return value
				}
			case null:
				return ""
			default:
				return value.toString()
		}
	}
}
