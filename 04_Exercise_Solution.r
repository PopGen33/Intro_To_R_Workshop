# Install / load packages
#install.packages("dplyr") # https://dplyr.tidyverse.org/
library(dplyr) 

# Read in data
avonetData <- read.delim("AVONET_averages_BirdLifeInternationalTaxonomy.txt", sep = "\t", header = TRUE, stringsAsFactors = TRUE)

###########################################
##  Exercise: Solution  ##
###########################################
# Step 1: Filter the data

avonetData_Gruiformes_noPartialMigration <- filter(avonetData, (Order1 == "Gruiformes") & (Migration != 2))

# Step 2: Re-coding the Migration column.

avonetData_Gruiformes_noPartialMigration <- avonetData_Gruiformes_noPartialMigration %>% 
    mutate(Migration = case_when(Migration == 3 ~ 1, .default = 0))
avonetData_Gruiformes_noPartialMigration <- avonetData_Gruiformes_noPartialMigration %>% 
    mutate(Migration = factor(Migration, levels = c(0,1), labels = c("Sedentary", "Migratory")))

# Step 3: Create boxplots.

for(family in unique(avonetData_Gruiformes_noPartialMigration$Family1)){
    boxplot(formula = Hand.Wing.Index ~ Migration, main = family, data = filter(avonetData_Gruiformes_noPartialMigration, Family1 == family))
}