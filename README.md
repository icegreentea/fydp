fydp
====

Single-Robot Dynamic Obstacle Avoidance - 4th year design project

CV Approach:
1. Lanes
2. Flags


Ayman to-do's - 2/10

- figure out a way to make it adaptable to red OR blue, rather than looking for one colour
- making lane and colour detection work together, separate right now
- push everything
- annotate images for testing:
-   use ginput in MATLAB. For each image, save top left pixel and bottom right pixel.
-   write to text file to store 
-   that way, when testing, convex hull pts can be used
-   right now, do one image at a time, but later:
fid = fopen( 'results.txt', 'wt' );
for image = 1:N
  [a1,a2,a3,a4] = ProcessMyImage( image );
  fprintf( fid, '%f,%f,%f,%f\n', a1, a2, a3, a4);
end
fclose(fid);

Algorithm:
- normalize everything: histogram equalization
- RGB2HSV, threshold S and V using large intervals, hard-coded values.
- threshold H using one hardcoded threshold which looks at extremes and automatically gets rid of them
- then employ moving threshold - need to find way to do this
- use some sort of boolean logic to use all three separate results (from HSV) to classify the pixel as red/not red
- THEN, we might want to use difference between two subsequent frames to eliminate outliers by using position stats and get closer to identifying actual flags (do this by looking at change in distance?)
- once we have identified the "right" red pixels, ie. ones we think comprise red flag, fit them with convex hulls
