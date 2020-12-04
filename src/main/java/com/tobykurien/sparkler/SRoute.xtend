package com.tobykurien.sparkler

import spark.Request
import spark.Response
import spark.Route

/**
 * Implementation of Route to accept Xtend lambdas
 */
class SRoute implements Route {
	protected var (Request, Response)=>Object handler
	protected String path
	protected String acceptType

	protected new(String path, (Request, Response)=>Object handler) {
		this.handler = handler
		this.path = path
	}

	protected new(String path, String acceptType, (Request, Response)=>Object handler) {
		this.handler = handler
		this.path = path
		this.acceptType = acceptType
	}

	override handle(Request req, Response res) {
		try {
			handler.apply(req, res)
		} catch (Exception e) {
			Helper.handleError(req, res, e)
		}
	}

	def getPath() {
		path
	}
	
	def getAcceptType() {
		acceptType
	}
}
