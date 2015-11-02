---
title: "Project 3 Doc"
output: html_document
---





# Project 3 Documentation

## Extract, Transform, and load:

The first step in our project was to load the data onto Oracle in a usable format.
We separated the columns into numerical and non-numerical types, using  3 versions of R\_ETL.R for each csv file. 
Our data was mostly well-behaved, so there wasn't much more to do here
```
file_path <- "./01 Data/New_York_City_Leading_Causes_of_Death.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)


# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))
names(df)
df <- rename(df, Game = G)



# str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("Year","Count","Percent")


#measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(df), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}

library(lubridate)

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
```


--------------

## Data 
We created a bar-chart to display some of the more prominent causees of death.

![Death counts in NYC by cause](./Bar\ Chart.jpg)

We also created a crosstab of death-counts, grouping by ethnicity and cause. We also
created a KPI to indicate tabs with deaths over 5000

![Death Count Crosstab and KPI](./Crosstab.jpg)

Then we created a scatterplot of the various causes of death over the years, colored by
ethnicity. This particular visualization would probably be better served by means other
than a scatterplot, but unfortunately our dataset did not lend itself much flexibility
with regards to scatterplots.

![Death Count by year](./Scatterplot.jpg)


