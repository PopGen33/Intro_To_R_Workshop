# This R script reads a .kml file (Keyhole Markup Language, often output from Google
# Earth) and renders the points in that KML file on a map. Here, I'm assuming the KML
# file contains points (as opposed to other things KML can define, like paths). This
# uses ggmap to fetch maps from a web server.

#############################
## Install / Load Packages ##
#############################
# Automatically download and install the required packages in the vector 'libNames'.
# This will only install the package if it isn't installed and will load the packages 
# in the order they're listed in 'libNames'. For me, installing these libraries caused 
# the R session to restart. If that happens, re-run the for loop until it doesn't restart.

libNames <- c('dplyr', 'sf', 'terra', 'ggmap', 'gridExtra') 

for(i in 1:length(libNames)){
  if (!libNames[i] %in% rownames(installed.packages())){
    install.packages(libNames[i], dependencies = TRUE)
  }
  library(libNames[i], character.only=TRUE)
}

##############
## Read KML ##
##############
# This assumes that both this script and the KML you're reading in are in the 
# current working directory. You can check the current working directory using
# getwd():
getwd()

# **** This is where you specify the name of your KML file ~*~*~*~*~*~*~*~
kmlFile <- "x.kml"

# read the kml file using 'read_sf' from the sf package.
# Turns out this kml file has multiple "sections" that I'm calling layers here (just b/c that's the 
# variable name that I chose).Each layer contains a set of points, so we'll read in a list of those layers
layers <- list()
index <- 1
for(lvl in st_layers(kmlFile)$name){
    layers[[index]] <- st_read(kmlFile, layer = lvl)
    index <- index + 1
}

# So, layers is a list of the sets of points we read in from the kml file with st_read()
str(layers)
# You can access different items in the list with indices, like this... (if I want the first item, for example)
layers[[1]]

####################################
## Calculations to get Map Extent ##
####################################
# To get our maps, we need to figure out the spatial extent of our data. There's a function for that: st_bbox
# So, we need to call it on each layer to get all the bounding boxes
boundingBoxes <- list()
for(i in 1:length(layers)){
    boundingBoxes[[i]] <- st_bbox(layers[[i]])
}

# Let's make a function to get a single bounding box that includes everything
allBoundingBox <- function(listOfBbox){
    # Set all of our extreme values to the values in the first bounding box
    x_min <- listOfBbox[[1]]['xmin']
    y_min <- listOfBbox[[1]]['ymin']
    x_max <- listOfBbox[[1]]['xmax']
    y_max <- listOfBbox[[1]]['ymax']
    # ...and update them as we iterate over the bounding boxes
    for(i in 2:length(listOfBbox)){
        bbox <- listOfBbox[[i]]
        if(bbox['xmin'] < x_min){
            x_min <- bbox['xmin']
        }
        if(bbox['ymin'] < y_min){
            y_min <- bbox['ymin']
        }
        if(bbox['xmax'] > x_max){
            x_max <- bbox['xmax']
        }
        if(bbox['ymax'] > y_max){
            y_max <- bbox['ymax']
        }
    }
    return(st_bbox(c(xmin = as.numeric(x_min), ymin = as.numeric(y_min), xmax = as.numeric(x_max), ymax = as.numeric(y_max)))) # unsure why as.numeric() is needed here, but fixes a problem with NA
}

# NOW, let's use that function to get a bounding box around everything

everythingBox <- allBoundingBox(boundingBoxes)

# we probably want the map we get to be slightly bigger than the points we're plotting onto it,
# so let's add or subtract a buffer to make that box bigger. We can define a function to make this 
# really easy.

boundExtend <- function(bbox, buffer){
  bbox <- replace(bbox,1,bbox[1] - buffer)
  bbox <- replace(bbox,2,bbox[2] - buffer)
  bbox <- replace(bbox,3,bbox[3] + buffer)
  bbox <- replace(bbox,4,bbox[4] + buffer)
  return(bbox)
}

# Extend the bounding box by 1 degree latitude/longitude
# Getting the buffer here looks complicated, but it's actually just, like, "find the width, find the height
# figure out which of those is bigger, and make the buffer 5% of that"
myBounds <- boundExtend(everythingBox, max(abs(everythingBox['xmax']-everythingBox['xmin']), abs(everythingBox['ymax']-everythingBox['ymin']))*0.05)

# Rename the names here so we can use it as input to get_map()
names(myBounds) <- c("left", "bottom", "right", "top")

###########################
## Retrieve map and plot ##
###########################
# This next part is largely based on this: https://www.nceas.ucsb.edu/sites/default/files/2020-04/ggmapCheatsheet.pdf
# maptype is one of "toner", "terrain", "watercolor" when using "stamen" as source.
# You can try other sources as well. Just be aware that some will make you generate an API key.
# Another thing to not here is that I set 'zoom' by just experimenting and tuning it manually.
# Setting zoom too high (above 13) seems to break retrieving the map files from the server...
# You might try another source, but, again, might need an API key. The real solution is probably downloading 
# you're own maps from, for example, USGS: https://www.usgs.gov/products/maps/map-releases
# You can work with those in R, too, using the terra package (or others), or you can work with them 
# in a GIS program (e.g. ArcGIS (you can get a license for free from the school), QGIS (open source and free))

# Anyway, let's plot this as well as we can

myMap <- get_map(location = myBounds, maptype = "terrain", source = "stamen", zoom = 13)

# Make the plot and add the points from each layer
myPlot <- ggmap(myMap)
for(layer in layers){
    # Let's extract just the x y coords; this uses dplyr
    coords <- do.call(rbind, st_geometry(layer)) %>% as_tibble(.name_repair = "minimal") %>% setNames(c("lon","lat","elev"))
    myPlot <- myPlot + geom_point(aes(x = lon, y = lat), data = coords, color = "red", size = 0.8)
}
myPlot <- myPlot + xlab("Longitude") + ylab("Latitude") + ggtitle("Map of Points")
myPlot
