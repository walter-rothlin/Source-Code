// Belongs to: 04_a_Webservice_Simple

package com.rothlin.webservice;

import javax.jws.WebMethod;
import javax.jws.WebService;


@WebService
public class FirstWebService {

	// Methodes in a web-Service are called Operations
	// Operation names can not be overloaded!!
	@WebMethod(exclude=false)
	public String ping() {
		return "Webservice (1.0.0.0)::FirstWebService:ping() called!!!!!!";
	}
	
	@WebMethod() // ctrl-space shows you the options
	public String sayHelloName(String name) {
		return "Hello " + name;
	}
	
	@WebMethod() // ctrl-space shows you the options
	public String sayHelloHWZ(String name) {
		return "Hello du " + name + "! Gruss von der HWZ";
	}
	
	@WebMethod(exclude=false)
	public String sayAnredeName(String anrede, String name) {
		return anrede + " " + name;
	}
	
	@WebMethod(exclude=false)
	public double calcCircleArea(double radius) {
		return radius*radius*Math.PI;
	}
}
