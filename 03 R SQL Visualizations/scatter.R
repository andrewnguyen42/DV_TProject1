#df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="SELECT * from NYCAUSEOFDEATH"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
df <- read.csv( "./01 Data/New_York_City_Leading_Causes_of_Death.csv")

