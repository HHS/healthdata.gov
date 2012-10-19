
package gov.data.health.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class LuceneDoc {
	String uri;
	List<String> triples;
	Set<String> links;
	
	private static Map<String,LuceneDoc> map = new HashMap<String,LuceneDoc>();
	
	public LuceneDoc( String uri ) {
		this.uri = uri;
		triples = new ArrayList<String>();
		links = new HashSet<String>();
	}
	
	public static void addTriplesToMap( List<String> triples ) {
		for (final String triple : triples) {
	   	 String subj = parseSubject( triple );
	   	 LuceneDoc doc = map.get( subj );
	   	 if (doc==null) {
	   		 doc = new LuceneDoc( subj );
	   		 map.put( subj, doc);
	   	 }
	   	 doc.add( triple );
		}
	}
	
	public static LuceneDoc getDoc( String name ) {
		return map.get( name );
	}
	
	public static Set<String> getDocNames() {
		return map.keySet();
	}
	
	public String getUri() {
		return uri;
	}
	
	public List<String> getTriples() {
		return triples;
	}
	
	public Iterator<String> getLinks() {
		return links.iterator();
	}
	
	public void add( String triple ) {
		 if (triple != null) {
			 String processedTriple = parseTriple( triple );
			 if (processedTriple!=null) triples.add( processedTriple );
			 String directObj = parseDirectObjectUrl( triple );
//			 System.out.println( "line="+triple);
//			 System.out.println( "directObj="+directObj);
			 if (directObj!=null) links.add( directObj );
	      }
	}
	
	public static String parseSubject( String triple ) {
		final int firstWhitespace = triple.indexOf(' ');
      final int secondWhitespace = triple.indexOf(' ', firstWhitespace + 1);
      final int lastDot = triple.lastIndexOf('.');
      if (firstWhitespace == -1 || secondWhitespace == -1 || lastDot == -1) {
        return null; // probably invalid triple, just skip it
      }
      final String subject = triple.substring(1, firstWhitespace-1);
      return subject;
	}
	
	public static String parseDirectObjectUrl( String triple ) {
		if (triple != null) {
	        final int firstWhitespace = triple.indexOf(' ');
	        final int secondWhitespace = triple.indexOf(' ', firstWhitespace + 1);
	        final int lastDot = triple.lastIndexOf('.');
	        if (firstWhitespace == -1 || secondWhitespace == -1 || lastDot == -1) {
	          return null; // probably invalid triple, just skip it
	        }
	        final String value = triple.substring(0, lastDot - 1);
	        if (value.endsWith(">")) {
	      	  final int lastLessThan = value.lastIndexOf('<');
	      	  if (lastLessThan != -1) {
	      		  return value.substring(lastLessThan+1, value.length()-1);
	      	  }
	        }
	     }
		return null;
	}
	
	public static String parseTriple( String triple ) {
		if (triple != null) {
	        final int firstWhitespace = triple.indexOf(' ');
	        final int secondWhitespace = triple.indexOf(' ', firstWhitespace + 1);
	        final int lastDot = triple.lastIndexOf('.');
	        if (firstWhitespace == -1 || secondWhitespace == -1 || lastDot == -1) {
	          return null; // probably invalid triple, just skip it
	        }
	        final String value = triple.substring(0, lastDot - 1);
	        return value;
		}
		return null;
	}
}
