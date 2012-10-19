package gov.data.health.util;

import java.util.List;

public class SampleSparqlQuery {
   public static void main( String[] args ) {
      Query query = new Query( "test",
        "SELECT DISTINCT ?measureId ?measure WHERE { "
         + "?record comp:condition <http://health.data.gov/id/condition/1>."
         + "?record comp:metric <http://health.data.gov/id/metric/1>. "
         + "?record comp:measure ?measureId. "
         + "?measureId rdfs:comment ?measure. "  
         + "} ORDER BY ?measureId" );

      Sparql sparql = new Sparql( "http://health.data.gov/sparql?query=" );
      long startTime = System.currentTimeMillis();
      List<Result> rslts = sparql.getResults( query );
      double queryTime = ((double)(System.currentTimeMillis() - startTime))/1000.0;
      System.out.println( "Total query time in secs = " + queryTime);
      if (rslts !=null) for (Result rslt : rslts) {
    	  System.out.println( "\n**************" );
    	  System.out.println( rslt.prettyPrint() +"\n" );
    	  System.out.println( "measureId = " + rslt.getValue("measureId") );
    	  System.out.println( "measure = " + rslt.getValue("measure") );
      }
      System.out.println( "Total query time in secs = " + queryTime);
      
   }
}
