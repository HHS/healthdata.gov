BEGIN {}
/^(Final_)?CAC_National_File/ {
   abbreviation = "cacn";
   topic = "http://reference.data.gov/def/govdata/Country";
   title = "Childrens Asthma Care National (CACN)";
   description = "National data regarding children's asthma care measures.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/country/US";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "National data regarding children's asthma care measures.";
   label = "CACN";
}
/^(Final_)?CAC_Provider_File/ {
   abbreviation = "cacp";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Childrens Asthma Care Providers (CACP)";
   description = "Information about hospitals that provide care for children's asthma.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Information about hospitals that provide care for children's asthma.";
   label = "CACP";
}
/^(Final_)?CAC_State_File/ {
   abbreviation = "cacs";
   topic = "http://reference.data.gov/def/govdata/State";
   title = "Childrens Asthma Care State (CACS)";
   description = "State data regarding children's asthma care measures.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/state";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "State data regarding children's asthma care measures.";
   label = "CACS";
}
/^[Ff]inal_Provider_Payment_Volume/ {
   abbreviation = "ppv";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Provider Payment Volume (PPV)";
   description = "Hospital payment volumes.";
   vocab = "http://health.data.gov/def/hospital";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Hospital payment volumes.";
   label = "PPV";
}
/^[Ff]inal_National_Payment_Volume/ {
   abbreviation = "npv";
   topic = "http://reference.data.gov/def/govdata/Country";
   title = "National Payment Volume (NPV)";
   description = "US payment volumes.";
   vocab = "http://health.data.gov/def/govdata";
   uriSpace = "http://health.data.gov/id/country/US";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "US payment volumes.";
   label = "NPV";
}
/^[Ff]inal_State_Payment_Volume/ {
   abbreviation = "spv";
   topic = "http://reference.data.gov/def/govdata/State";
   title = "State Payment Volume (SPV)";
   description = "State payment volumes.";
   vocab = "http://health.data.gov/def/govdata";
   uriSpace = "http://health.data.gov/id/state";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "State payment volumes.";
   label = "SPV";
}
/^(Final_)?CACOnly_Providers/ {
   abbreviation = "cacop";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Childrens Asthma Care Only Providers (CACOP)";
   description = "Hospitals that are Childrens Asthma Care providers.";
   vocab = "http://health.data.gov/def/hospital";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital";
   comment = "Hospitals that are Childrens Asthma Care providers.";
   label = "CACOP";
}
/^Hopqdrp_finalfile_hsp_characteristics/ {
   abbreviation = "hophc";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Hospital Outpatient Quality Data Reporting Program - Hospital Characteristics (HOPHC)";
   description = "General hospital characteristic information as measured by HOPQDRP.";
   vocab = "http://health.data.gov/def/hospital";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://www.w3.org/2006/vcard/ns#VCard";
   comment = "General hospital characteristic information as measured by HOPQDRP.";
   label = "HOPHC";
}
/^final_hsp_characteristics/ {
   abbreviation = "hosp";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Hospital Characteristics (HOSP)";
   description = "General hospital characteristic information.";
   vocab = "http://health.data.gov/def/hospital";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://www.w3.org/2006/vcard/ns#VCard";
   comment = "General hospital characteristic information.";
   label = "HOSP";
}
/^Final_Hsp_[cC]har_Payment_Volume/ {
   abbreviation = "hpv";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Hospital Payment Volume (HPV)";
   description = "Payment volume and hospital characteristic information.";
   vocab = "http://health.data.gov/def/hospital";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://www.w3.org/2006/vcard/ns#VCard";
   comment = "Payment volume and hospital characteristic information.";
   label = "HPV";
}
/^(Final_)?MPVonly_Providers/ {
   abbreviation = "mpvop";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Medicare Payment Volume Only Providers (MPVOP)";
   description = "Hospitals that are Medicare Payment Volume providers.";
   vocab = "http://health.data.gov/def/hospital";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital";
   comment = "Hospitals that are Medicare Payment Volume providers.";
   label = "MPVOP";
}
/^final_clinical_national/ {
   abbreviation = "cn";
   topic = "http://reference.data.gov/def/govdata/Country";
   title = "Clinical National (CN)";
   description = "National clinical information.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/country/US";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "National clinical information.";
   label = "CN";
}
/^final_clinical_provider/ {
   abbreviation = "cp";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Clinical Provider (CP)";
   description = "Measurements regarding how well hospitals treat specific conditions.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Measurements regarding how well hospitals treat specific conditions.";
   label = "CP";
}
/^final_clinical_state/ {
   abbreviation = "cs";
   topic = "http://reference.data.gov/def/govdata/State";
   title = "Clinical State (CS)";
   description = "State clinical information.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/state";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "State clinical information.";
   label = "CS";
}
/^(final_)?structural_measures/ {
   abbreviation = "sm";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Structural Measures (SM)";
   description = "Structural measurements for hospitals.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Structural measurements for hospitals.";
   label = "SM";
}
/^Hopqdrp_finalfile_hosp_perf/ {
   abbreviation = "hophp";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Hospital Outpatient Quality Data Reporting Program - Hospital Performance (HOPHP)";
   description = "Survey information about hospital HOPQDRP performance measures and metrics.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Survey information about hospital HOPQDRP performance measures and metrics.";
   label = "HOPHP";
}
/^Hopqdrp_finalfile_natl_perf/ {
   abbreviation = "hopnp";
   topic = "http://reference.data.gov/def/govdata/Country";
   title = "Hospital Outpatient Quality Data Reporting Program - National Outcomes (HOPNP)";
   description = "HOPQDRP national outcome performance measures and metrics.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "HOPQDRP national outcome performance measures and metrics.";
   label = "HOPNP";
}
/^Hopqdrp_finalfile_state_perf/ {
   abbreviation = "hopsp";
   topic = "http://reference.data.gov/def/govdata/State";
   title = "Hospital Outpatient Quality Data Reporting Program - State Performance";
   description = "Survey information about state outpatient performance measures and metrics.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Survey information about state outpatient performance measures and metrics.";
   label = "HOPSP";
}
/^final_outcome_national/ {
   abbreviation = "on";
   topic = "http://reference.data.gov/def/govdata/Country";
   title = "National Outcomes (ON)";
   description = "National outcome performance measures and metrics.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "National outcome performance measures and metrics.";
   label = "ON";
}
/^final_outcome_provider/ {
   abbreviation = "op";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Provider Outcomes (OP)";
   description = "Risk standardized mortality and readmission information about hospital performance for various measures and metrics.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Risk standardized mortality and readmission information about hospital performance for various measures and metrics.";
   label = "OP";
}
/^final_outcome_state/ {
   abbreviation = "os";
   topic = "http://reference.data.gov/def/govdata/State";
   title = "State Outcomes (OS)";
   description = "Survey information about state outcome performance measures and metrics.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Survey information about state outcome performance measures and metrics.";
   label = "OS";
}
/^final_hcahps_national/ {
   abbreviation = "hn";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Hospital Consumer Assessment of Healthcare Providers and Systems - National (HN)";
   description = "Survey information about US performance measures and metrics.";
   vocab = "http://health.data.gov/def/hospital-compare/HCAHPSSurveyMeasure";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Survey information about US performance measures and metrics.";
   label = "HN";
}
/^Hopqdrp_finalfile_quarters/ {
   abbreviation = "hopqdrpq";
   topic = "http://health.data.gov/def/compare/ProcessMeasure";
   title = "Hospital Outpatient Quality Data Reporting Program Quarters (HOPQDRPQ)";
   description = "Quarterly reporting information for HOPQDRP measures.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/compare/ProcessMeasure";
   comment = "Quarterly reporting information for HOPQDRP measures.";
   label = "HOPQDRPQ";
}
/^final_hcahps_provider/ {
   abbreviation = "hp";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Hospital Consumer Assessment of Healthcare Providers and Systems - Providers (HP)";
   description = "Survey information about performance measures and metrics for providers.";
   vocab = "http://health.data.gov/def/hospital-compare/HCAHPSSurveyMeasure";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Survey information about performance measures and metrics for providers.";
   label = "HP";
}
/^final_hcahps_state/ {
   abbreviation = "hs";
   topic = "http://reference.data.gov/def/govdata/State";
   title = "Hospital Consumer Assessment of Healthcare Providers and Systems - State (HS)";
   description = "Survey information about performance measures and metrics for states.";
   vocab = "http://health.data.gov/def/hospital-compare/HCAHPSSurveyMeasure";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Survey information about performance measures and metrics for states.";
   label = "HS";
}
/^final_[qQ]uarters/ {
   abbreviation = "q";
   topic = "http://health.data.gov/def/compare/Measure";
   title = "Quarters (Q)";
   description = "Quarterly reporting information for various measures.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/compare/ProcessMeasure";
   comment = "Quarterly reporting information for various measures.";
   label = "Q";
}
/^Outpatient_FinalFile_Quarters/ {
   abbreviation = "oq";
   topic = "http://health.data.gov/def/compare/Measure";
   title = "Outpatient Quarters (Q)";
   description = "Quarterly reporting information for various measures.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/measure";
   exampleResource = "http://health.data.gov/def/compare/ProcessMeasure";
   comment = "Quarterly reporting information for various measures.";
   label = "OQ";
}
/^final_ahrq_outcome_national/ {
   abbreviation = "ahrqn";
   topic = "http://reference.data.gov/def/govdata/Country";
   title = "Healthcare Research and Quality Indicators, Natioanal data";
   description = "National data regarding the Agency for Healthcare Research and Quality Indicators";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/state";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "AHRQ is a collection of Patient Safety and Inpatient Quality Indicators";
   label = "AHRQN";
}
/^final_ahrq_outcome_provider/ {
   abbreviation = "ahrqp";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Healthcare Research and Quality Indicators, Providers";
   description = "Information regarding hospitals that provide various Patient Saftey Indicators and Inpatient Quality Indicators.";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/state";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "AHRQ is a collection of Patient Safety and Inpatient Quality Indicators";
   label = "AHRQP";
}
/^final_ahrq_outcome_state/ {
   abbreviation = "ahrqs";
   topic = "http://reference.data.gov/def/govdata/State";
   title = "Healthcare Research and Quality Indicators, State data";
   description = "State data regarding the Agency for Healthcare Research and Quality Indicators";
   vocab = "http://health.data.gov/def/compare";
   uriSpace = "http://health.data.gov/id/state";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "AHRQ is a collection of Patient Safety and Inpatient Quality Indicators";
   label = "AHRQS";
}
/^final_hai_state/ {
   abbreviation = "hais";
   topic = "http://reference.data.gov/def/govdata/State";
   title = "Healthcare-Associated Infections, State data (HAIS)";
   description = "State data regarding Healtcare-Associated Infections";
   vocab = "http://health.data.gov/def/hospital-compare";
   uriSpace = "http://health.data.gov/id/state";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "State data regarding Healtcare-Associated Infections";
   label = "HAIS";
}
/^final_hai_national/ {
   abbreviation = "hain";
   topic = "http://reference.data.gov/def/govdata/Country";
   title = "Healthcare-Associated Infections, National data (HAIN)";
   description = "National data regarding Healtcare-Associated Infections";
   vocab = "http://health.data.gov/def/hospital-compare";
   uriSpace = "http://health.data.gov/id/country/US";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "National data regarding Healtcare-Associated Infections";
   label = "HAIN";
}
/^final_hai_hospital/ {
   abbreviation = "haip";
   topic = "http://health.data.gov/def/hospital/Hospital";
   title = "Healthcare-Associated Infections, Provider data (HAIP)";
   description = "Provider data regarding Healthcare-Associated Infections";
   vocab = "http://health.data.gov/def/hospital-compare";
   uriSpace = "http://health.data.gov/id/hospital";
   exampleResource = "http://health.data.gov/def/hospital-compare/Record";
   comment = "Provider data regarding Healtcare-Associated Infections";
   label = "HAIP";
}
END {
   if (get=="abbreviation") print abbreviation;
   if (get=="topic") print topic;
   if (get=="title") print title;
   if (get=="description") print description;
   if (get=="vocab") print vocab;
   if (get=="uriSpace") print uriSpace;
   if (get=="exampleResource") print exampleResource;
   if (get=="comment") print comment;
   if (get=="label") print label;
}
