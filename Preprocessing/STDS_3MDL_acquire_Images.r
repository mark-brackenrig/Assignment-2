

# Pull image link and listing id columns from listings dataset
# Write to a file
# Feed images into S3  (paste image link into demo link - not sure how to automate yet)
# Returns words and confidence levels, save to a file
# dataset is something like ....
#  id, image url, word, confidence level
#   1   1            
#                  1        1
#       1         n


# Merge aproach:

# ?? ... What have we got to start with ... ??
# id, image url     
# one word file per id/image combo


# Do features in an image drive occupancy?

# determine which are the top words for all images (use freq() ?)
# add these as a listing attribute called 'feature' 
# (eg: has water view, has balcony)
