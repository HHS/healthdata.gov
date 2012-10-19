package gov.data.health.util;

import java.util.ArrayList;
import java.util.List;

import org.jdom.Element;
import org.jdom.output.XMLOutputter;

public class Result {
	private static XMLOutputter prettyPrinter = new XMLOutputter();
	Element element = null;
	
	public Result( Element element ) {
		this.element = element;
	}

	public Element getElement() {
		return element;
	}
	
	public String getValue( String name ) {
		List<Element> fields = element.getChildren();
		if (fields != null) {
			for (Element field : fields) {
				if (name.equals(field.getAttributeValue("name"))) {
					List<Element> list = field.getContent();
			  	    if (list!=null)
			           return list.get(0).getValue();
					return null;
				}
			}
		}
		return null;
	}

	public String prettyPrint() {
		 return prettyPrint( element );
	}
	
	public static String prettyPrint( Element e ) {
		return prettyPrinter.outputString( e );
	}
}
