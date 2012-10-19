package gov.data.health.util;

import java.util.List;

public class CqldTimingTest {
	private static Query[] cqldQueries;
	
	static {
		cqldQueries = new Query[] {
//	#######################################
//	#
//	# 1) List all ConditionIds and Conditions
//	#
//	#      Every ConditionId has exactly one Condition (description).
//	#      Use this query to populate a Hashmap, so you don't have to use
//	#      Virtuoso to get the Condition from a ConditionId ever again
//	#      (as it slows down dynamic retrieval in other queries).
//	#
//	#######################################
//	#
		new Query( "1",
			"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
			"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
			"	SELECT DISTINCT ?conditionId ?condition WHERE {\n" + 
			"	   ?conditionId a comp:Condition.\n" + 
			"	   OPTIONAL { ?conditionId rdfs:comment ?condition. }\n" + 
			"	} ORDER BY ?conditionId" ),
						
//	#######################################
//	#
//	# 2) List all MeasureIds and Measures
//	#
//	#      Every MeasureId has exactly one Measure (description).
//	#      Use this query to populate a Hashmap, so you don't have to use
//	#      Virtuoso to get the Measure from a MeasureId ever again
//	#      (as it slows down dynamic retrieval in other queries).
//	# 
//	#######################################
//	#
			new Query( "2",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?measureId ?measure where { \n" + 
	"	  {\n" + 
	"	    ?subClass1 rdfs:subClassOf comp:Measure.\n" + 
	"	    ?subClass rdfs:subClassOf ?subClass1.\n" + 
	"	    ?measureId a ?subClass. \n" + 
	"	  } UNION {\n" + 
	"	    ?subClass rdfs:subClassOf comp:Measure.\n" + 
	"	    ?measureId a ?subClass. \n" + 
	"	  } UNION {\n" + 
	"	    ?measureId a comp:Measure.\n" + 
	"	  } \n" + 
	"	  ?measureId rdfs:comment ?measure.\n" + 
	"	} ORDER BY ?measureId"),

//	#######################################
//	#
//	# 3) List all MetricIds and Metrics
//	#
//	#      Every MetricId has exactly one Metric (description).
//	#      Use this query to populate a Hashmap, so you don't have to use
//	#      Virtuoso to get the Metric from a MetricId ever again
//	#      (as it slows down dynamic retrieval in other queries).
//	#
//	#######################################
//	#
	new Query( "3",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?metricId ?metric where { \n" + 
	"	  {\n" + 
	"	    ?subClass1 rdfs:subClassOf comp:Metric.\n" + 
	"	    ?subClass rdfs:subClassOf ?subClass1.\n" + 
	"	    ?metricId a ?subClass. \n" + 
	"	  } UNION {\n" + 
	"	    ?subClass rdfs:subClassOf comp:Metric.\n" + 
	"	    ?metricId a ?subClass.  \n" + 
	"	  } UNION {\n" + 
	"	    ?metricId a comp:Metric.\n" + 
	"	  } \n" + 
	"	  ?metricId rdfs:comment ?metric.\n" + 
	"	} ORDER BY ?metricId"),



//	#
//	# 4.1) What are the Measures that can be used in conjunction with Conditon 9?
//	#      (when the Outpatient has AMI/Chest Pain)
//	#
	new Query( "4.1",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:condition <http://health.data.gov/id/condition/9>.\n" + 
	"	   ?record comp:measure ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),

//	#
//	# 4.2) What are the Metrics that can be used in conjunction with Conditon 9?
//	#      (when the Outpatient has AMI/Chest Pain)
//	#
	new Query( "4.2",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:condition <http://health.data.gov/id/condition/9>.\n" + 
	"	   ?record comp:metric ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),

//	#
//	# 4.3) What are the Conditions that can be used in conjunction with Measure 39?
//	#      (where the patient was given an Aspirin at Arrival)
//	#
	new Query( "4.3",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/39>.\n" + 
	"	   ?record comp:condition ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),

//	#
//	# 4.4) What are the Metrics that can be used in conjunction with Measure 39?
//	#      (where the patient was given an Aspirin at Arrival)
//	#
	new Query( "4.4",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/39>.\n" + 
	"	   ?record comp:metric ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),

//	#
//	# 4.5) What are the Conditions that can be used in conjunction with Metric 1?
//	#      (where the performance was "90th Percentile")
//	#
	new Query( "4.5",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:metric <http://health.data.gov/id/metric/1>.\n" + 
	"	   ?record comp:condition ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),

//	#
//	# 4.6) What are the Measures that can be used in conjunction with Metric 1?
//	#      (where the performance was "90th Percentile")
//	#
	new Query( "4.6",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:metric <http://health.data.gov/id/metric/1>.\n" + 
	"	   ?record comp:measure ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),


//	#
//	# 5.1) What are the Metrics that can be used 
//	#      in conjunction with Condition 2 and Measure 27?
//	#      (where the patient had a heart failure condition, and died within 30 days)
//	#
	new Query( "5.1",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:condition <http://health.data.gov/id/condition/2>.\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/27>.\n" + 
	"	   ?record comp:metric ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),

//	#
//	# 5.2) What are the Measures that can be used 
//	#      in conjunction with Condition 2 and Metric 13?
//	#      (where the patient had a heart failure condition, 
//	#      and the hospital mortality rate is the same as the national average)
//	#
	new Query( "5.2",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:condition <http://health.data.gov/id/condition/2>.\n" + 
	"	   ?record comp:metric <http://health.data.gov/id/metric/13>.\n" + 
	"	   ?record comp:measure ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),

//	#
//	# 5.3) What are the Conditions that can be used 
//	#      in conjunction with Measure 27 and Metric 13?
//	#      (where the patient died within 30 days, 
//	#      and the hospital mortality rate is the same as the national average)
//	#
	new Query( "5.3",
	"PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	SELECT DISTINCT ?desiredId WHERE {\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/27>.\n" + 
	"	   ?record comp:metric <http://health.data.gov/id/metric/13>.\n" + 
	"	   ?record comp:condition ?desiredId.\n" + 
	"	} ORDER BY ?desiredId"),


//	#######################################
//	#
//	# 6) List all HospitalIds and Hospitals. 
//	#
//	#      Every HospitalId has exactly one Hospital (description).
//	#      Use this query to populate a Hashmap, so you don't have to use
//	#      Virtuoso to get the Hospital from a HospitalId ever again
//	#      (as it slows down dynamic retrieval in other queries). 
//	#
//	#######################################
//	#
	new Query( "6",
	"PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>    \n" + 
	"	SELECT DISTINCT ?hospitalId ?hospital WHERE {\n" + 
	"	   ?hospitalId a hosp:Hospital.\n" + 
	"	   ?hospitalId rdfs:label ?hospital.\n" + 
	"	}"),

//	#
//	# 6.1) Count the number of Hospitals 
//	#
	new Query( "6.1",
	"PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	SELECT (COUNT( ?hospitalId ) as ?numberOfHospitals) WHERE {\n" + 
	"	   { SELECT DISTINCT ?hospitalId WHERE {\n" + 
	"	      ?hospitalId a hosp:Hospital. \n" + 
	"	   } }\n" + 
	"	}"),

//	#######################################
//	#
//	# 7) Retrieve metadata/contact information about a Hospital
//	#    (Fair Oaks Hospital, in this example)
//	#
//	# In this and in all following queries, instances/literals found in the query
//	# such as <http://health.data.gov/id/hospital/490101> are merely examples.
//	# You should replace it with the hospitalId of the hospital for which you want information.
//	#
//	#######################################
//	#
	new Query( "7",
	"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX ns: <http://www.w3.org/ns/org#>\n" + 
	"	PREFIX vcard: <http://www.w3.org/2006/vcard/ns#>\n" + 
	"	SELECT ?lat ?lon ?hospital ?hospitalType ?hasER ?phone ?streetAddr ?city \n" + 
	"	       ?stateCode ?countyCode ?zip ?ownershipType WHERE {\n" + 
	"	    { SELECT ?lat ?lon ?phone ?city ?zip ?streetAddr WHERE {\n" + 
	"	       <http://health.data.gov/id/hospital/490101> hosp:site ?site.\n" + 
	"	       ?site ns:siteAddress ?vcard.\n" + 
	"	       OPTIONAL { ?vcard vcard:latitude ?lat. }\n" + 
	"	       OPTIONAL { ?vcard vcard:longitude ?lon. }\n" + 
	"	       OPTIONAL { ?vcard vcard:tel ?phone. }\n" + 
	"	       OPTIONAL { ?vcard vcard:locality ?city. }\n" + 
	"	       OPTIONAL { ?vcard vcard:postal-code ?zip. }\n" + 
	"	       OPTIONAL { ?vcard vcard:street-address ?streetAddr.  }\n" + 
	"	    } LIMIT 1 }\n" + 
	"	    <http://health.data.gov/id/hospital/490101> rdfs:label ?hospital.\n" + 
	"	    <http://health.data.gov/id/hospital/490101> gd:stateCode ?stateId.\n" + 
	"	    ?stateId rdfs:label ?stateCode.\n" + 
	"	    <http://health.data.gov/id/hospital/490101> gd:countyCode ?countyCode.\n" + 
	"	    <http://health.data.gov/id/hospital/490101> hosp:ownership ?ownershipType.\n" + 
	"	    <http://health.data.gov/id/hospital/490101> hosp:type ?hospitalType.\n" + 
	"	    <http://health.data.gov/id/hospital/490101> hosp:emergencyServices ?hasER.  \n" + 
	"	} LIMIT 1"),


//	#######################################
//	#
//	# 8) Retrieve all clinical data for a given hospital 
//	#    (Fair Oaks Hospital, in this example)
//	#
//	#######################################
//	#
	new Query( "8",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>    \n" + 
	"	SELECT DISTINCT ?date ?conditionId ?measureId ?metricId ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
	"	   <http://health.data.gov/id/hospital/490101> hoco:recordset ?rs. \n" + 
	"	   {\n" + 
	"	      GRAPH ?g { ?rs comp:metric  ?metricId. }\n" + 
	"	      ?g dcterms:issued ?date.\n" + 
	"	      OPTIONAL { ?rs gd:percentage ?percentage. }\n" + 
	"	      OPTIONAL { ?rs comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	   } UNION {\n" + 
	"	      GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	      ?g dcterms:issued ?date.\n" + 
	"	      OPTIONAL { ?record comp:condition ?conditionId. }\n" + 
	"	      OPTIONAL { ?record comp:measure ?measureId. }\n" + 
	"	      OPTIONAL { ?record comp:metric  ?metricId.  }\n" + 
	"	      OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	      OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	      OPTIONAL { ?record gd:denominator ?denominator. }\n" + 
	"	      OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	      OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	      OPTIONAL { ?record hoco:admissions ?admissions. }\n" + 
	"	      OPTIONAL { ?record hoco:rsmrLow ?rsmrLow. }\n" + 
	"	      OPTIONAL { ?record hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	      OPTIONAL { ?record hoco:rsrrLow ?rsrrLow. }\n" + 
	"	      OPTIONAL { ?record hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	      OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	      OPTIONAL { ?record hoco:medianPayment ?medianPayment. }\n" + 
	"	      OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   } \n" + 
	"	}"),


//	#######################################
//	#
//	# 9) Retrieve all clinical quality averages for a state 
//	#    (The state of Virginia, in this example)
//	#
//	#######################################
//	#
	new Query( "9",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?date ?conditionId ?measureId ?metricId ?percentage ?ratio ?medianTime \n" + 
	"	      ?stateCount ?nationalCount ?msdrg ?footnote ?footnoteId WHERE {\n" + 
	"	   <http://reference.data.gov/id/state/VA> rdfs:label ?stateCode.\n" + 
	"	   <http://reference.data.gov/id/state/VA> hoco:recordset ?rs. \n" + 
	"	   GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
	"	   OPTIONAL { ?record comp:condition ?conditionId.  }\n" + 
	"	   OPTIONAL { ?record comp:measure ?measureId. }\n" + 
	"	   OPTIONAL { ?record comp:metric  ?metricId.  }\n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:nationalCount ?nationalCount. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	}"), 


//	#######################################
//	#
//	# 10) Retrieve all clinical quality averages for the US
//	#
//	#######################################
//	#
	new Query( "10",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?date ?conditionId ?measureId ?metricId ?percentage ?ratio ?medianTime \n" + 
	"	      ?nationalCount ?msdrg ?footnote ?footnoteId WHERE {\n" + 
	"	   <http://reference.data.gov/id/country/US> hoco:recordset ?rs. \n" + 
	"	   GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
	"	   OPTIONAL { ?record comp:condition ?conditionId. }\n" + 
	"	   OPTIONAL { ?record comp:measure ?measureId. }\n" + 
	"	   OPTIONAL { ?record comp:metric  ?metricId. }\n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:nationalCount ?nationalCount. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	}"),


//	#######################################
//	#
//	# 11) Retrieve the values for a Condition, Measure, and Metric at a given hospital 
//	#
//	#     In this example: Where the patient was admitted with outpatient AMI/Chest Pain, 
//	#     what is the median transfer time to another facility for Acute Coronary Intervention?
//	#
//	#######################################
//	#
	new Query( "11",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?date ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
	"	   {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490101>  hoco:recordset ?rs. }\n" + 
	"	     ?rs hoco:record ?record.\n" + 
	"	   } UNION {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490101>  hoco:recordset ?record. }\n" + 
	"	   }\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
	"	   ?record comp:condition <http://health.data.gov/id/condition/9>.\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/38>.  \n" + 
//	"	#          ?record comp:metric <>.                    # No metric filter in this example\n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage.}\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	   OPTIONAL { ?record gd:denominator ?denominator. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:admissions ?admissions. }\n" + 
	"	   OPTIONAL { ?record hoco:rsmrLow ?rsmrLow. }\n" + 
	"	   OPTIONAL { ?record hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	   OPTIONAL { ?record hoco:rsrrLow ?rsrrLow. }\n" + 
	"	   OPTIONAL { ?record hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:medianPayment ?medianPayment. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	}"), 


//	#######################################
//	#
//	# 12) Retrieve the values for a condition/measure/metric for a state 
//	#
//	#     In this example: According to survey, what percentage of patients 
//	#     felt they always had communication with doctors in the state of Virginia? 
//	#
//	#######################################
//	#
	new Query( "12",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?date ?stateCode \n" + 
//	"	# ?condition                  # No condition filter in this example\n" + 
	"	      ?measure ?metric ?percentage ?ratio ?medianTime \n" + 
	"	      ?stateCount ?nationalCount ?msdrg ?footnote ?footnoteId WHERE {\n" + 
	"	   <http://reference.data.gov/id/state/VA> rdfs:label ?stateCode.\n" + 
	"	   GRAPH ?g { <http://reference.data.gov/id/state/VA>  hoco:recordset ?rs. }\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
	"	   ?rs hoco:record ?record.\n" + 
//	"	#     ?record comp:condition <>.                 # No condition filter in this example\n" + 
//	"	#     <> rdfs:comment ?condition.                # No condition filter in this example\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/51>. \n" + 
	"	   <http://health.data.gov/id/measure/51> rdfs:comment   ?measure. \n" + 
	"	   ?record comp:metric  <http://health.data.gov/id/metric/20>. \n" + 
	"	   <http://health.data.gov/id/metric/20>  rdfs:comment   ?metric. \n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:nationalCount ?nationalCount. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	}"),


//	#######################################
//	#
//	# 13) Retrieve the values for a condition/measure/metric for the US
//	#
//	#     In this example: According to survey, what is the US average percentage of patients 
//	#     who checked "Usually" when asked about the responsiveness of the hospital staff.
//	#
//	#######################################
//	#
	new Query( "13",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?date\n" + 
//	"	#     ?condition                        # No condition filter in this example\n" + 
	"	      ?measure ?metric ?percentage ?ratio ?medianTime \n" + 
	"	      ?nationalCount ?msdrg WHERE {\n" + 
	"	   <http://reference.data.gov/id/country/US> hoco:recordset ?rs. \n" + 
	"	   GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
//	"	#     ?record comp:condition <>.                 # No condition filter in this example\n" + 
//	"	#     <> rdfs:comment ?condition.                # No condition filter in this example\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/52>. \n" + 
	"	   <http://health.data.gov/id/measure/52> rdfs:comment   ?measure. \n" + 
	"	   ?record comp:metric  <http://health.data.gov/id/metric/19>. \n" + 
	"	   <http://health.data.gov/id/metric/19>  rdfs:comment   ?metric. \n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:nationalCount ?nationalCount. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	}"), 


//	#######################################
//	#
//	# 14) Retrieve all data publication dates
//	#
//	# All queries greater than 14 require a publication date.
//	# Presumably, a developer might use this query to drive a script in a loop
//	#
//	#######################################
//	#
	new Query( "14",
	"PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX void: <http://rdfs.org/ns/void#>\n" + 
	"	SELECT DISTINCT ?date  WHERE {\n" + 
	"	  ?s void:dataset ?ds .\n" + 
	"	  ?ds dcterms:issued ?date.\n" + 
	"	}"),

	
//	#######################################
//	#
//	# 15) Retrieve the hospital with the Highest value 
//	# for some condition/measure/metric for some date published. 
//	#
//	# In this example: As reported for June 7, 2011, what hospital performed the greatest 
//	# percentage of MRIs performed for outpatients suffering from lower back pain?
//	#
//	#######################################
//	#
	new Query( "15",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>\n" + 
	"	PREFIX void: <http://rdfs.org/ns/void#>\n" + 
	"	SELECT DISTINCT ?hospitalId ?hospital ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#     Find the hospital with the highest value\n" + 
//	"	#\n" + 
	"	  { SELECT DISTINCT ?bag ?hospitalId ?percentage WHERE {\n" + 
	"	      ?bag comp:condition <http://health.data.gov/id/condition/9>. \n" + 
	"	      ?bag comp:measure <http://health.data.gov/id/measure/43>.\n" + 
//	"	#        ?bag comp:metric <http://health.data.gov/id/metric/>. # This query doesn't use a metric\n" + 
	"	      GRAPH ?g { ?bag gd:percentage ?percentage. }\n" + 
	"	      ?g dcterms:issued \"2011-06-07\"^^xsd:date.\n" + 
	"	      {\n" + 
	"	         ?rs hoco:record ?bag.\n" + 
	"	         ?hospitalId  hoco:recordset ?rs.\n" + 
	"	      } UNION {\n" + 
	"	         ?hospitalId  hoco:recordset ?bag.\n" + 
	"	      }\n" + 
	"	   } ORDER BY DESC( ?percentage ) LIMIT 1 }\n" + 
//	"	#\n" + 
//	"	#     Now retrieve all the information about that performance at that hospital\n" + 
//	"	#\n" + 
	"	   ?hospitalId  rdfs:label ?hospital.\n" + 
	"	   OPTIONAL { ?bag comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. } \n" + 
	"	   OPTIONAL { ?bag gd:denominator ?denominator. }\n" + 
	"	   OPTIONAL { ?bag hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?bag hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?bag hoco:admissions ?admissions. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsmrLow ?rsmrLow. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsrrLow ?rsrrLow. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	   OPTIONAL { ?bag hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?bag hoco:medianPayment ?medianPayment. }\n" + 
	"	   OPTIONAL { ?bag hoco:msdrg ?msdrg. }\n" + 
	"	}"),

	/*
//	#######################################
//	#
//	# 16) Retrieve the hospital with the lowest value 
//	# for some condition/measure/metric of ANY date published. 
//	#
//	# In this example: What hospital had the overall least  
//	# percentage of MRIs performed for outpatients suffering from lower back pain?
//	#
//	#######################################
//	#
	new Query( "16",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	PREFIX void: <http://rdfs.org/ns/void#>\n" + 
	"	SELECT DISTINCT ?date ?hospitalId ?hospital ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#     Find the hospital with the lowest value for some CMM for any date\n" + 
//	"	#\n" + 
	"	  { SELECT DISTINCT ?date ?bag ?hospitalId ?percentage WHERE {\n" + 
	"	      ?bag comp:condition <http://health.data.gov/id/condition/9>. \n" + 
	"	      ?bag comp:measure <http://health.data.gov/id/measure/43>.\n" + 
//	"	#        ?bag comp:metric <http://health.data.gov/id/metric/>.\n" + 
	"	      GRAPH ?g { ?bag gd:percentage ?percentage. }\n" + 
	"	      ?g dcterms:issued ?date.\n" + 
	"	      {\n" + 
	"	         ?rs hoco:record ?bag.\n" + 
	"	         ?hospitalId  hoco:recordset ?rs.\n" + 
	"	         ?hospitalId a hosp:Hospital.\n" + 
	"	      } UNION {\n" + 
	"	         ?hospitalId  hoco:recordset ?bag.\n" + 
	"	         ?hospitalId a hosp:Hospital.\n" + 
	"	      }\n" + 
	"	   } ORDER BY ASC( ?percentage ) LIMIT 1 }\n" + 
//	"	#\n" + 
//	"	#     Now retrieve all related information about that hospital record\n" + 
//	"	#\n" + 
	"	   ?hospitalId  rdfs:label ?hospital.\n" + 
	"	   OPTIONAL { ?bag comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. } \n" + 
	"	   OPTIONAL { ?bag gd:denominator ?denominator. }\n" + 
	"	   OPTIONAL { ?bag hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?bag hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?bag hoco:admissions ?admissions. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsmrLow ?rsmrLow. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsrrLow ?rsrrLow. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	   OPTIONAL { ?bag hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?bag hoco:medianPayment ?medianPayment. }\n" + 
	"	   OPTIONAL { ?bag hoco:msdrg ?msdrg. }\n" + 
	"	}"), 
	*/

//	#######################################
//	#
//	# 16.1) Retrieve the hospital with the lowest value with sufficient sample size
//	# for some condition/measure/metric of ANY date published. 
//	#
//	# In this example: What hospital had the overall least percentage of MRIs 
//	# performed, where there is no note indicating insuffient sample size,
//	# for outpatients suffering from lower back pain?
//	#
//	#######################################
//	#
	new Query( "16.1",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	PREFIX void: <http://rdfs.org/ns/void#>\n" + 
	"	SELECT DISTINCT ?date ?hospitalId ?hospital ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#     Find the hospital with the lowest value for some CMM \n" + 
//	"	#     where there is no note indicating an insufficient sample.\n" + 
//	"	#\n" + 
	"	  { SELECT DISTINCT ?date ?bag ?hospitalId ?percentage WHERE {\n" + 
	"	      ?bag comp:condition <http://health.data.gov/id/condition/9>. \n" + 
	"	      ?bag comp:measure <http://health.data.gov/id/measure/43>.\n" + 
//	"	#        ?bag comp:metric <http://health.data.gov/id/metric/>.\n" + 
	"	      GRAPH ?g { ?bag gd:percentage ?percentage. }\n" + 
	"	      ?g dcterms:issued ?date.\n" + 
	"	      {\n" + 
	"	         ?rs hoco:record ?bag.\n" + 
	"	         ?hospitalId  hoco:recordset ?rs.\n" + 
	"	         ?hospitalId a hosp:Hospital.\n" + 
	"	         OPTIONAL { ?bag comp:footnote ?footId. }\n" + 
	"	         FILTER ( ! bound( ?footId ) OR ?footId != <http://health.data.gov/id/footnote/1> )\n" + 
	"	      } UNION {\n" + 
	"	         ?hospitalId  hoco:recordset ?bag.\n" + 
	"	         ?hospitalId a hosp:Hospital.\n" + 
	"	         OPTIONAL { ?bag comp:footnote ?footId. }\n" + 
	"	         FILTER ( ! bound( ?footId ) OR ?footId != <http://health.data.gov/id/footnote/1> )\n" + 
	"	      }\n" + 
	"	   } ORDER BY ASC( ?percentage ) LIMIT 1 }\n" + 
//	"	#\n" + 
//	"	#     Now retrieve all information about that record at that hospital\n" + 
//	"	#\n" + 
	"	   ?hospitalId  rdfs:label ?hospital.\n" + 
	"	   OPTIONAL { ?bag comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. } \n" + 
	"	   OPTIONAL { ?bag gd:denominator ?denominator. }\n" + 
	"	   OPTIONAL { ?bag hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?bag hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?bag hoco:admissions ?admissions. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsmrLow ?rsmrLow. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsrrLow ?rsrrLow. }\n" + 
	"	   OPTIONAL { ?bag hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	   OPTIONAL { ?bag hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?bag hoco:medianPayment ?medianPayment. }\n" + 
	"	   OPTIONAL { ?bag hoco:msdrg ?msdrg. }\n" + 
	"	}"), 


//	#######################################
//	#
//	# 17) Retrieve the state that performs the highest percentage for some
//	#  condition/measure/metric for a date published. 
//	#
//	# In this example: What state had the overall highest percentage of MRIs performed  
//	# outpatients suffering from lower back pain, as published on June 7, 2011?
//	#
//	#######################################
//	#
	new Query( "17",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>\n" + 
	"	SELECT DISTINCT ?stateCode ?stateId \n" + 
	"	      ?percentage ?ratio ?medianTime \n" + 
	"	      ?stateCount ?nationalCount ?msdrg ?footnote ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#     First find the state with the highest percentage for some CMM on some date\n" + 
//	"	#\n" + 
	"	  { SELECT DISTINCT ?stateId ?percentage ?record WHERE {\n" + 
	"	     ?stateId a gd:State.\n" + 
	"	     GRAPH ?g { ?stateId  hoco:recordset ?rs. }\n" + 
	"	     ?g dcterms:issued \"2011-06-07\"^^xsd:date.\n" + 
	"	     ?rs hoco:record ?record.\n" + 
	"	     ?record comp:condition <http://health.data.gov/id/condition/9>.\n" + 
	"	     ?record comp:measure <http://health.data.gov/id/measure/43>. \n" + 
	"	     ?record gd:percentage ?percentage.\n" + 
//	"	#      ?record comp:metric  <>. \n" + 
	"	   } ORDER BY DESC( ?percentage ) LIMIT 1 }\n" + 
//	"	#\n" + 
//	"	#     Now retrieve all other information about that state statistic\n" + 
//	"	#\n" + 
	"	   ?stateId rdfs:label ?stateCode.\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:nationalCount ?nationalCount. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	}"), 


//	#######################################
//	#
//	# 18) Retrieve the Hospital that has the highest value for a 
//	# condition/measure/metric within a state, for a publication date.
//	#
//	# In this example: In Virginia, for June 7, 2011, what hospital had the highest  
//	# percentage of MRIs performed for outpatients suffering from lower back pain?
//	#
//	#######################################
//	#
	new Query( "18",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>\n" + 
	"	SELECT ?hospitalId ?hospital ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#     Find the hospital that had the highest percentage for some CMM on a date\n" + 
//	"	#\n" + 
	"	{ SELECT DISTINCT ?hospitalId ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
	"	   ?hospitalId a hosp:Hospital.\n" + 
	"	   ?hospitalId gd:stateCode <http://reference.data.gov/id/state/VA>. \n" + 
	"	   GRAPH ?g { ?hospitalId  hoco:recordset ?rs. }\n" + 
	"	   ?g dcterms:issued \"2011-06-07\"^^xsd:date.\n" + 
	"	   {\n" + 
	"	       ?rs hoco:record ?record.\n" + 
	"	       ?record comp:condition <http://health.data.gov/id/condition/9>. \n" + 
	"	       ?record comp:measure <http://health.data.gov/id/measure/43>.  \n" + 
//	"	#          ?record comp:metric <>.                    # No metric filter in this example\n" + 
	"	       OPTIONAL { ?record gd:percentage ?percentage.}\n" + 
	"	       OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. } \n" + 
	"	       OPTIONAL { ?record gd:denominator ?denominator. }\n" + 
	"	       OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	       OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	       OPTIONAL { ?record hoco:admissions ?admissions. }\n" + 
	"	       OPTIONAL { ?record hoco:rsmrLow ?rsmrLow. }\n" + 
	"	       OPTIONAL { ?record hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	       OPTIONAL { ?record hoco:rsrrLow ?rsrrLow. }\n" + 
	"	       OPTIONAL { ?record hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	       OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	       OPTIONAL { ?record hoco:medianPayment ?medianPayment. }\n" + 
	"	       OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   } UNION {\n" + 
	"	       ?rs comp:condition <http://health.data.gov/id/condition/9>. \n" + 
	"	       ?rs comp:measure <http://health.data.gov/id/measure/43>.\n" + 
//	"	#          ?rs comp:metric <>.                        # No metric filter in this example   \n" + 
	"	       OPTIONAL { ?rs gd:percentage ?percentage.}\n" + 
	"	       OPTIONAL { ?rs comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. } \n" + 
	"	   } \n" + 
	"	} ORDER BY DESC( ?percentage ) LIMIT 1 }\n" + 
	"	?hospitalId  rdfs:label ?hospital.\n" + 
	"	} LIMIT 1"),
	


//	#######################################    
//	#
//	# 19) what is the national data on some condition/measure/metric, 
//	# and how does my state compare?
//	#
//	# In this example: Compare the Survey results of Virginia and US averages over time;
//	# What percentage of patients responded "Usually" when asked about communication with doctors. 
//	#
//	#######################################
//	#
	new Query( "19",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?date ?place \n" + 
//	"	#     ?condition                        # No condition filter in this example\n" + 
	"	      ?measure ?metric ?percentage ?ratio ?medianTime \n" + 
	"	      ?nationalCount ?msdrg WHERE {\n" + 
//	"	#\n" + 
//	"	#     Compare US and VA averages\n" + 
//	"	#\n" + 
	"	   {\n" + 
	"	     <http://reference.data.gov/id/country/US> hoco:recordset ?rs. \n" + 
	"	   } UNION {\n" + 
	"	     <http://reference.data.gov/id/state/VA>  hoco:recordset ?rs.\n" + 
	"	   }\n" + 
	"	   GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	   ?place hoco:recordset ?rs.\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
//	"	#\n" + 
//	"	#     Select only the CMM we care about\n" + 
//	"	   \n" + 
//	"	#     ?record comp:condition <>.                 # No condition filter in this example\n" + 
//	"	#     <> rdfs:comment ?condition.                # No condition filter in this example\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/51>. \n" + 
	"	   <http://health.data.gov/id/measure/51> rdfs:comment   ?measure. \n" + 
	"	   ?record comp:metric  <http://health.data.gov/id/metric/19>. \n" + 
	"	   <http://health.data.gov/id/metric/19>  rdfs:comment   ?metric. \n" + 
//	"	#\n" + 
//	"	#     Now get the rest of the information about these statistics\n" + 
//	"	#\n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:nationalCount ?nationalCount. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	} ORDER BY ?date"),


//	#######################################
//	#
//	# 20) what is the national data on this condition/measure/metric, 
//	# and how does my hospital compare?
//	#
//	# In this example: Compare the Survey results from Fair Oaks Hospital and US averages over time;
//	# What percentage of patients responded "Usually" when asked about communication with doctors. 
//	#
//	#######################################
//	#
	new Query( "20",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?date ?place \n" + 
//	"	#     ?condition                        # No condition filter in this example\n" + 
	"	      ?measure ?metric ?percentage ?footnote ?denominator ?ratio ?medianTime \n" + 
	"	      ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount     \n" + 
	"	      ?nationalCount ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#     Compare the US average with a hospital\n" + 
//	"	#\n" + 
	"	   {\n" + 
	"	     <http://reference.data.gov/id/country/US> hoco:recordset ?rs. \n" + 
	"	     GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	     ?place hoco:recordset ?rs.\n" + 
	"	   } UNION {\n" + 
	"	     <http://health.data.gov/id/hospital/490101>  hoco:recordset ?rs.\n" + 
	"	     GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	     ?place hoco:recordset ?rs.\n" + 
	"	   } UNION {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490101>  hoco:recordset ?record. }\n" + 
	"	     ?place hoco:recordset ?record.\n" + 
	"	   }\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
//	"	#\n" + 
//	"	#     Select only the CMM we care about\n" + 
//	"	#\n" + 
//	"\n" + 
//	"	#     ?record comp:condition <>.                 # No condition filter in this example\n" + 
//	"	#     <> rdfs:comment ?condition.                # No condition filter in this example\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/51>. \n" + 
	"	   <http://health.data.gov/id/measure/51> rdfs:comment   ?measure. \n" + 
	"	   ?record comp:metric  <http://health.data.gov/id/metric/19>. \n" + 
	"	   <http://health.data.gov/id/metric/19>  rdfs:comment   ?metric. \n" + 
//	"	#\n" + 
//	"	#     Now retrieve the rest of the information about these statistics\n" + 
//	"	#\n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:nationalCount ?nationalCount. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	   OPTIONAL { ?record gd:denominator ?denominator. }\n" + 
	"	   OPTIONAL { ?record hoco:admissions ?admissions. }\n" + 
	"	   OPTIONAL { ?record hoco:rsmrLow ?rsmrLow. }\n" + 
	"	   OPTIONAL { ?record hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	   OPTIONAL { ?record hoco:rsrrLow ?rsrrLow. }\n" + 
	"	   OPTIONAL { ?record hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:medianPayment ?medianPayment. }\n" + 
	"	} ORDER BY ?date"),


//	#######################################
//	#
//	# 21) of the 3 hospitals in my area, what are their stats on this condition/measure/metric? 
//	#
//	# Presumably, some other script will figure out what 3 hospitals are near the user.
//	#
//	# In this example: Compare the median time to transfer to another facility for accute
//	# coronary intervention for the local hospitals: Fair Oaks, Fairfax, and Reston
//	#
//	#######################################
//	#
	new Query( "21",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	SELECT DISTINCT ?date ?hospital ?condition ?measure \n" + 
//	"	# ?metric\n" + 
	"	      ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?hospitalId ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#     Specify the hospitals\n" + 
//	"	#\n" + 
	"	   {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490101>  hoco:recordset ?rs. }\n" + 
	"	     ?hospitalId hoco:recordset ?rs.\n" + 
	"	     ?rs hoco:record ?record.\n" + 
	"	   } UNION {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490101>  hoco:recordset ?record. }\n" + 
	"	     ?hospitalId hoco:recordset ?record.\n" + 
	"	   } UNION {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490107>  hoco:recordset ?rs. }\n" + 
	"	     ?hospitalId hoco:recordset ?rs.\n" + 
	"	     ?rs hoco:record ?record.\n" + 
	"	   } UNION {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490107>  hoco:recordset ?record. }\n" + 
	"	     ?hospitalId hoco:recordset ?record.\n" + 
	"	   } UNION {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490063>  hoco:recordset ?rs. }\n" + 
	"	     ?hospitalId hoco:recordset ?rs.\n" + 
	"	     ?rs hoco:record ?record.\n" + 
	"	   } UNION {\n" + 
	"	     GRAPH ?g { <http://health.data.gov/id/hospital/490063>  hoco:recordset ?record. }\n" + 
	"	     ?hospitalId hoco:recordset ?record.\n" + 
	"	   }\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
//	"	#\n" + 
//	"	#     Select only the CMM we are interested in\n" + 
//	"	#\n" + 
	"	   ?record comp:condition <http://health.data.gov/id/condition/9>.\n" + 
	"	   <http://health.data.gov/id/condition/9> rdfs:comment ?condition.\n" + 
	"	   ?record comp:measure <http://health.data.gov/id/measure/38>.\n" + 
	"	   <http://health.data.gov/id/measure/38> rdfs:comment  ?measure.\n" + 
//	"	#          ?record comp:metric <>.                    # No metric filter in this example\n" + 
//	"	#          <>  rdfs:comment  ?metric.                 # No metric filter in this example\n" + 
	"	   ?hospitalId rdfs:label ?hospital.\n" + 
//	"	#\n" + 
//	"	#     Now retrieve the rest of the information about these records from these hospitals\n" + 
//	"	#\n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage.}\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	   OPTIONAL { ?record gd:denominator ?denominator. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:admissions ?admissions. }\n" + 
	"	   OPTIONAL { ?record hoco:rsmrLow ?rsmrLow. }\n" + 
	"	   OPTIONAL { ?record hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	   OPTIONAL { ?record hoco:rsrrLow ?rsrrLow. }\n" + 
	"	   OPTIONAL { ?record hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:medianPayment ?medianPayment. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	} ORDER BY ?date"),


//	#######################################
//	#
//	# 23) Retrieve all clinical information available,
//	# about the hospital that had the best performance on a 
//	# condition/measure/metric on a publication date.
//	#
//	# In this example: In Virginia, for June 7, 2011, what hospital had the highest  
//	# percentage of MRIs performed for outpatients suffering from lower back pain?
//	# And retrieve all clinical information for that hospital on that publication date.
//	#
//	#######################################
//	#
	new Query( "23",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	PREFIX void: <http://rdfs.org/ns/void#>\n" + 
	"	PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>\n" + 
	"	SELECT DISTINCT ?date ?hospitalId ?conditionId ?measureId ?metricId \n" + 
	"	      ?percentage ?footnote ?denominator\n" + 
	"	      ?ratio ?medianTime ?admissions ?rsmrLow ?rsmrHigh ?rsrrLow ?rsrrHigh ?stateCount\n" + 
	"	      ?medianPayment ?msdrg ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#       Find the hospital that had the best performance on a \n" + 
//	"	#       condition/measure/metric on a publication date. \n" + 
//	"	#\n" + 
	"	  { SELECT  ?hospitalId WHERE {\n" + 
	"	      ?bag comp:condition <http://health.data.gov/id/condition/9>. \n" + 
	"	      ?bag comp:measure <http://health.data.gov/id/measure/43>.\n" + 
//	"	#        ?bag comp:metric <http://health.data.gov/id/metric/>.\n" + 
	"	      GRAPH ?g { ?bag gd:percentage ?percentage. }\n" + 
	"	      ?g dcterms:issued \"2011-06-07\"^^xsd:date.\n" + 
	"	      {\n" + 
	"	         ?rs hoco:record ?bag.\n" + 
	"	         ?hospitalId  hoco:recordset ?rs.\n" + 
	"	         ?hospitalId  a    hosp:Hospital.\n" + 
	"	      } UNION {\n" + 
	"	         ?hospitalId  hoco:recordset ?bag.\n" + 
	"	         ?hospitalId  a    hosp:Hospital.\n" + 
	"	      }\n" + 
	"	   } ORDER BY DESC( ?percentage ) LIMIT 1 }\n" + 
//	"	#\n" + 
//	"	#       Retrieve all clinical information about that hospital\n" + 
//	"	#   \n" + 
	"	   ?hospitalId hoco:recordset ?rs. \n" + 
	"	   {\n" + 
	"	      GRAPH ?g { ?rs comp:metric  ?metricId. }\n" + 
	"	      ?g dcterms:issued ?date.\n" + 
	"	      OPTIONAL { ?rs gd:percentage ?percentage. }\n" + 
	"	      OPTIONAL { ?rs comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	   } UNION {\n" + 
	"	      GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	      ?g dcterms:issued ?date.\n" + 
	"	      OPTIONAL { ?record comp:condition ?conditionId. }\n" + 
	"	      OPTIONAL { ?record comp:measure ?measureId. }\n" + 
	"	      OPTIONAL { ?record comp:metric  ?metricId.  }\n" + 
	"	      OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	      OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	      OPTIONAL { ?record gd:denominator ?denominator. }\n" + 
	"	      OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	      OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	      OPTIONAL { ?record hoco:admissions ?admissions. }\n" + 
	"	      OPTIONAL { ?record hoco:rsmrLow ?rsmrLow. }\n" + 
	"	      OPTIONAL { ?record hoco:rsmrHigh ?rsmrHigh. }\n" + 
	"	      OPTIONAL { ?record hoco:rsrrLow ?rsrrLow. }\n" + 
	"	      OPTIONAL { ?record hoco:rsrrHigh ?rsrrHigh. }\n" + 
	"	      OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	      OPTIONAL { ?record hoco:medianPayment ?medianPayment. }\n" + 
	"	      OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   } \n" + 
	"	}"),

	
	/*
//	#######################################
//	#
//	# 24) Retrieve all data for the state that is highest 
//	#  for a condition/measure/metric for a date published
//	#
//	# In this example: Search data published on June 7, 2011 for the state 
//	# with the highest percentage of MRIs performed for outpatients suffering 
//	# from lower back pain? And return all clinical data averages for that state,
//	# for June 7, 2011.
//	#
//	#######################################
//	#
	new Query( "24",
	"PREFIX gd: <http://reference.data.gov/def/govdata/>\n" + 
	"	PREFIX hosp: <http://health.data.gov/def/hospital/>\n" + 
	"	PREFIX hoco: <http://health.data.gov/def/hospital-compare/>\n" + 
	"	PREFIX dcterms: <http://purl.org/dc/terms/>\n" + 
	"	PREFIX comp: <http://health.data.gov/def/compare/>\n" + 
	"	PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" + 
	"	PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>\n" + 
	"	SELECT DISTINCT ?date ?stateId ?conditionId ?measureId ?metricId ?percentage ?ratio ?medianTime \n" + 
	"	      ?stateCount ?nationalCount ?msdrg ?footnote ?footnoteId WHERE {\n" + 
//	"	#\n" + 
//	"	#     Retrieve the state that performs the BEST for some\n" + 
//	"	#     condition/measure/metric for a date published. \n" + 
//	"	#\n" + 
	"	  { SELECT DISTINCT ?stateId WHERE {\n" + 
	"	     ?stateId a gd:State.\n" + 
	"	     GRAPH ?g { ?stateId  hoco:recordset ?rs. }\n" + 
	"	     ?g dcterms:issued \"2011-06-07\"^^xsd:date.\n" + 
	"	     ?rs hoco:record ?record.\n" + 
	"	     ?record comp:condition <http://health.data.gov/id/condition/9>.\n" + 
	"	     ?record comp:measure <http://health.data.gov/id/measure/43>. \n" + 
	"	     ?record gd:percentage ?percentage.\n" + 
//	"	#      ?record comp:metric  <>.            # this example does not use a metric filter\n" + 
	"	   } ORDER BY DESC( ?percentage ) LIMIT 1 }\n" + 
//	"	#\n" + 
//	"	#    Retrieve all clinical quality averages for that state \n" + 
//	"	#\n" + 
	"	   ?stateId rdfs:label ?stateCode.\n" + 
	"	   ?stateId hoco:recordset ?rs. \n" + 
	"	   GRAPH ?g { ?rs hoco:record ?record. }\n" + 
	"	   ?g dcterms:issued ?date.\n" + 
	"	   OPTIONAL { ?record comp:condition ?conditionId.  }\n" + 
	"	   OPTIONAL { ?record comp:measure ?measureId. }\n" + 
	"	   OPTIONAL { ?record comp:metric  ?metricId.  }\n" + 
	"	   OPTIONAL { ?record gd:percentage ?percentage. }\n" + 
	"	   OPTIONAL { ?record hoco:stateCount ?stateCount. }\n" + 
	"	   OPTIONAL { ?record hoco:ratio ?ratio. }\n" + 
	"	   OPTIONAL { ?record hoco:medianTime ?medianTime. }\n" + 
	"	   OPTIONAL { ?record hoco:nationalCount ?nationalCount. }\n" + 
	"	   OPTIONAL { ?record hoco:msdrg ?msdrg. }\n" + 
	"	   OPTIONAL { ?record comp:footnote ?footnoteId. ?footnoteId rdfs:comment ?footnote. }\n" + 
	"	}")
	*/
		};
	}


	public static void main(String[] args) {
		if (args.length<1) {
			System.out.println("Usage: java -cp loadGraphsSesame-1.0.0-jar-with-dependencies.jar gov.data.health.util.CqldTimingTest <sparqlEndpoint>");
			System.out.println("     where <sparqlEndpoint> it the URL of the endpoint to test");
			System.out.println("     an example sparqlEndpoint might be, http://health.data.gov/sparql?query=");
			System.exit(0);
		}
		Sparql sparql = new Sparql(args[0]);
		long startTime = System.currentTimeMillis();
		double[] queryTime = new double[cqldQueries.length];
		for (int i = 0; i < cqldQueries.length; i++) {
			startTime = System.currentTimeMillis();
			List<Result> rslts = sparql.getResults(cqldQueries[i]);
			queryTime[i] = ((double)(System.currentTimeMillis() - startTime)) / 1000.0;
			if (rslts==null) queryTime[i] = -1.0;
			System.out.println("\nQuery #" + cqldQueries[i].getLabel() + ", numberOfResults= " 
			      +((rslts==null)?(-1):(rslts.size()))
					+", executionTime= "+queryTime[i]);
			if (rslts != null) {
				System.out.println( "     A sample result follows:");
					synchronized( sparql ) {
						System.out.println(rslts.get(0).prettyPrint());
					}
			}
		}
		
		System.out.print( "\nQuery, ");
		for (int i = 0; i<cqldQueries.length; i++) {
			System.out.print( cqldQueries[i].getLabel() );
			if (i<queryTime.length-1) {
				System.out.print( ", " );
			}
		}
		double total = 0.0;
		System.out.print( "\nTime, ");
		for (int i = 0; i<queryTime.length; i++) {
			if (queryTime[i]>0) {
			   total = total + queryTime[i];
			}
			System.out.print( queryTime[i] );
			if (i<queryTime.length-1) {
				System.out.print( ", " );
			}
		}
		System.out.println("\n****** Total Execution Time in secs (negative time is failure, and not added to Total) = " + total);
	}
}
