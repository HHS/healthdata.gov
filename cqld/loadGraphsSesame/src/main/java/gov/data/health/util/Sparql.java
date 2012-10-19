package gov.data.health.util;

import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.XMLOutputter;

public class Sparql {
//	static Runtime runtime = Runtime.getRuntime();
	static SAXBuilder builder = new SAXBuilder();
   String endpoint = "" ;  // example "http://health.data.gov/sparql?query="
   
   public Sparql( String endpoint ) {
   	this.endpoint = endpoint;
   }

	public List<Result> getResults(Query query) {
		String enc = urlEncode(query.getContent());
		String url = endpoint + enc;
		try {
			Document doc = curlToXml(url);
			Element e = doc.getRootElement();
			Namespace ns = e.getNamespace();
			Element e1 = e.getChild("results", ns);
			List<Element> elements = e1.getChildren("result", ns);
			if (elements!=null && elements.size()>0) {
				List<Result> rslts = new ArrayList();
				for (Element element:elements) {
					rslts.add( new Result( element ) );
				}
				return rslts;
			}	
		} catch (Exception e) {
			System.err.println("\nFailure on Query: "+query.getLabel());
		}
		return null;
	}
	
	private static XMLOutputter prettyPrinter = new XMLOutputter();
	

	private static String urlEncode(String str) {
		try {
			return java.net.URLEncoder.encode(str, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			// UTF-8 should work
		}
		return null;
	}


	public static Document curlToXml(String str) throws Exception {
//         The following is an alternate invocation method, using the Unix "curl"
//		Process conn = runtime.exec("curl -L " + str);  
		URL url = new URL( str );
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("accept", "application/sparql-results+xml");
		
		Document doc = builder.build(conn.getInputStream());
		return doc;
	}
	

	public static Element getBinding(Element e, String name) throws Exception {
		List<Element> l = e.getChildren();
		if (l != null)
			for (Element e1 : l) {
				String v = e1.getAttributeValue("name");
				if (name.equals(v)) {
					return (Element) e1.getChildren().get(0);
				}
			}
		return null;
	}

}
