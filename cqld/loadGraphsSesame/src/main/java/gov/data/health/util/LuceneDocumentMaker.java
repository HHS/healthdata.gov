package gov.data.health.util;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


/**
 *
 * @author Doug Whitehead
 */
public abstract class LuceneDocumentMaker {
	private int count = 0;
	
//	public abstract void addDoc( String url, List<String> nTriple ) throws Exception;
	
	public abstract void init() throws Exception;
	public abstract void done() throws Exception;
	
   void pushIfReady() throws Exception {
		if (count%100 == 99) {
			done();
			init();
		}
		count++;
	}

	public abstract void addDoc(LuceneDoc doc) throws Exception;
	
	String[] fieldName = { "ntriple", "extendedNtripleHop2", "extendedNtripleHop3",
			"extendedNtripleHop4", "extendedNtripleHop5", "extendedNtripleHop6", 
			"extendedNtripleHop7", "extendedNtripleHop8", "extendedNtripleHop9"
	};

	public List<List<String>> gatherLinks( LuceneDoc doc, int hops ) {
		List<List<String>> hopsLists = new ArrayList<List<String>>( hops );
		for( int i=0; i<hops; i++) {
			hopsLists.add(i, new ArrayList<String>() );
		}
		gatherLinks1( doc, hopsLists, 0, hops );
		return hopsLists;
	}
	
	private void gatherLinks1( LuceneDoc doc, List<List<String>> hopsLists, int curHop, int hops) {
		if (curHop >= hops) return;
		if (doc == null) return;
		List<String> triples = doc.getTriples();
		if (triples==null) return;
//		System.out.println("doc= "+doc.getUri()+", curHop= "+curHop+", hops="+hops);
		for (String triple : triples) {
			hopsLists.get( curHop ).add( triple );
		}
		Iterator<String> links = doc.getLinks();
		if (links==null) return;
		while( links.hasNext() ) {
			String nxt = links.next();
			gatherLinks1( LuceneDoc.getDoc( nxt ), hopsLists, curHop+1, hops );
		}
	}
}
