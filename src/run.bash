# MARS
#java -jar mars.jar nc sm $1 | sed -e "$ d"

# SPIM
spim -file $1 | sed -e "5d;4d;3d;2d;1d"

