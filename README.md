NOTE: CHANGE RUNTIME TYPE → RUNTIME → CHANGE RUNTIME TYPE → SELECT T4 GPU → SAVE

DEPTHMAPS

https://colab.google/

command:
!curl -sL https://raw.githubusercontent.com/niyeee4/Script/main/depthmap.sh | bash

upload your video to /Depth-Anything-V2

to run: !depthmap "yourfile.mp4" 

output path: /Depth-Anything-V2/output/yourfile.mp4

RIFE

https://colab.google/

command:
curl -sL https://raw.githubusercontent.com/niyeee4/Script/refs/heads/main/rife.sh | bash

upload your video to /Practical-RIFE

to run: !rife "yourfile.mp4" multi 4

output path: /Practical-RIFE/output_x4_yourfile.mp4

what is “multi”?

yourfile.mp4 = 30 fps → multi 2 → 60 fps

yourfile.mp4 = 30 fps → multi 6 → 180 fps

use only multi 2-8 higher multi values increase processing time
