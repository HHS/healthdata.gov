/*
 * Copyright Aduna (http://www.aduna-software.com/) (c) 2011.
 *
 * Licensed under the Aduna BSD-style license.
 */
package gov.data.health.util;

public class Query {
	String label;
	String content;
	
	public Query( String label, String content ) {
		this.label = label;
		this.content = content;
	}
	
	public String getLabel() {
		return label;
	}
	
	public String getContent() {
		return content;
	}
}
