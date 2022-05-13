#!/bin/bash

/usr/bin/khal printics --format "
*** Calendar Event ***

Title........{repeat-symbol}{title}
Location.....{location}
Start........{start-date-long} {start-time-full}
End..........{end-date-long} {end-time-full}
Status.......{status}

{description}
" ${1} | awk '{if (NR>2) print}'
