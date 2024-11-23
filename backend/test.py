from dominos_server.report import getting_match

ingre = ['WHOLE WHITE WHEAT FLOUR', 'SUGAR', 'RICE FLOUR', 'CANOLA OIL', 'FRUCTOSE', 'DEXTROSE', 'MALTODEXTRIN', 'SALT', 'CALCIUM CARBONATE', 'CINNAMON', 'TRISODIUM PHOSPHATE', 'VITAMIN C SODIUM ASCORBAT', 'COLOR (CARAMEL, ANNATTO EXTRACT)', 'SOY LECITHIN', 'NATURAL FLAVOR', 'IRON (FERROUS FUMARATE)']
report, best_worst = getting_match(ingre)
print(report)
print(best_worst)