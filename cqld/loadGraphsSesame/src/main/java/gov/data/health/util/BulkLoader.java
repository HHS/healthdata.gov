package gov.data.health.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader; 
import java.util.ArrayList;
import java.util.Collection;

public abstract class BulkLoader  {
	public abstract void init() throws Exception;
	public abstract void loadOne( File f, String graphName ) throws Exception;
	public abstract void done() throws Exception;
	
	private static void printArgList() {
		System.out.println("Usage: java -jar loadGraphsSesame.jar <token> <dir> [<filenamePreamble>]");
		System.out.println("   where <dir> is the root directory of a tree of RDF files to load");
		System.out.println("   if <token> is \"siren\", then the RDF found in <dir> will be loaded into lucene/solr/siren");
		System.out.println("   if <token> is \"xml\", then RDF found in <dir> will be converted into XML using <filenamePreamble> as a name.");
		System.out.println("   otherwise <token> is the the name of the repository to load into sesame");
	}

	public static void main(String[] args) {
		try {
			if (args.length < 2) {
				printArgList();
				System.exit(1);
			}
			String root = args[1];
         
			BulkLoader loader;
			if (args[0].equals("siren")) {	
			   int hops = 1;
				if (args.length >2 && args[2].startsWith("hops=")) {
					hops = Integer.parseInt(args[2].substring(5));
				}
				System.out.println("Requested to create docs with hops="+hops);
				loader = new SolrLoader( new DirectLuceneDocumentMaker( hops ) );
			} else if (args[0].equals("xml")) {
				if (args.length<3) {
					printArgList();
					System.out.println("Please specify a <filenamePreamble>.");
					System.exit(1);
				}
				int hops = 1;
				if (args.length >3  && args[3].startsWith("hops=")) {
					hops = Integer.parseInt(args[3].substring(5));
				}
				
				System.out.println("Requested to create docs with hops="+hops);
				loader = new SolrLoader( new XmlLuceneDocumentMaker( args[2], hops) );
			} else if (args[0].equals("mulgara")) {
				loader = new MulgaraLoader();
			} else {
				loader = new SesameLoader( args[0] );
			}
			
			loader.init();
			
			final Collection<File> all = new ArrayList<File>();
			traverse(new File(root), all);
			
                        int count = 0;
			if (all!=null) for (File one : all) {
                                count++;
				System.out.println( "Loading #"+count+": " + one.getName() );
				String oneFullName = one.getAbsolutePath();
				String oneGraph = System.getProperty( "oneGraph" );
                                if (oneGraph==null) {
				   oneGraph = readFileToString(oneFullName + ".graph").trim();
                                } 
				
				loader.loadOne( one, oneGraph );
			}
			
			loader.done();
		}
		catch (Exception e) {
			System.err.println("Ooops: " + e.toString());
			e.printStackTrace();
		}
	}

	private static void traverse(File file, Collection<File> all) {
		if (file.isFile() ) {
			if (! file.isHidden()) {

			if (file.getName().endsWith(".rdf")) {
				all.add(file);
			} else if (file.getName().endsWith(".ttl")) {
				all.add(file);
//			} else if (file.getName().endsWith(".nt")) {
//				all.add(file);
			}
			}
			return;
		}
		final File[] children = file.listFiles();
		if (children != null) {
			for (File child : children) {	
					traverse(child, all);
			}
		}
	}

	private static String readFileToString(String filePath)
		throws java.io.IOException {
		StringBuffer fileData = new StringBuffer(1000);
		BufferedReader reader = new BufferedReader(new FileReader(filePath));
		char[] buf = new char[1024];
		int numRead = 0;
		while ((numRead = reader.read(buf)) != -1) {
			String readData = String.valueOf(buf, 0, numRead);
			fileData.append(readData);
		}
		reader.close();
		return fileData.toString();
	}
	
	public static Collection<File> getRDFs(String root) {
		final Collection<File> all = new ArrayList<File>();
		getFiles(new File(root), all, new String[]{ ".rdf" });
		return all;
	}
	
	private static void getFiles(File file, 
			Collection<File> all, String[] extensions) {
		if (file==null || file.isHidden()) return;
		if (file.isDirectory()) {
			File[] children = file.listFiles();
			if (children==null) return;
			for (File child : children) {
				getFiles(child, all, extensions);
			}
			return;
		} 
		for( String ext : extensions ) {
			if (file.getName().endsWith( ext )) {
				all.add(file);
				return;
			}
		}
	}
}
