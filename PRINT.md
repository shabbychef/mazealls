


# dodecagon maze

<img src="nodist/ignore/figures_simple-dodecagon-1.png" title="plot of chunk simple-dodecagon" alt="plot of chunk simple-dodecagon" width="700px" height="700px" />
<img src="nodist/ignore/figures_simple-dodecagon-new-1.png" title="plot of chunk simple-dodecagon-new" alt="plot of chunk simple-dodecagon-new" width="700px" height="700px" />

# Rhombic Dissections


<img src="nodist/ignore/figures_simple-octagon-1.png" title="plot of chunk simple-octagon" alt="plot of chunk simple-octagon" width="700px" height="700px" />

<img src="nodist/ignore/figures_simple-decagon-1.png" title="plot of chunk simple-decagon" alt="plot of chunk simple-decagon" width="700px" height="700px" />

## Koch snowflake maze


<img src="nodist/ignore/figures_koch-flake-1.png" title="plot of chunk koch-flake" alt="plot of chunk koch-flake" width="700px" height="700px" />

<img src="nodist/ignore/figures_koch-meta-flake-1.png" title="plot of chunk koch-meta-flake" alt="plot of chunk koch-meta-flake" width="700px" height="700px" />

## Sierpinski Triangle


```r
library(TurtleGraphics)
library(mazealls)
turtle_init(2500, 2500, mode = "clip")
turtle_up()
turtle_hide()
turtle_do({
    turtle_setpos(50, 1250)
    turtle_setangle(0)
    sierpinski_maze(unit_len = 19, depth = 7, draw_boundary = TRUE, 
        boundary_lines = TRUE, boundary_holes = c(1, 
            3), color1 = "black", color2 = "gray60")
})
```

<img src="nodist/ignore/figures_sierpinski-1.png" title="plot of chunk sierpinski" alt="plot of chunk sierpinski" width="700px" height="700px" />

### Sierpinski Carpet


<img src="nodist/ignore/figures_sierpinski-carpet-1.png" title="plot of chunk sierpinski-carpet" alt="plot of chunk sierpinski-carpet" width="700px" height="700px" />

<img src="nodist/ignore/figures_menger-sponge-1.png" title="plot of chunk menger-sponge" alt="plot of chunk menger-sponge" width="700px" height="700px" />

### Sierpinski Hexagon

<img src="nodist/ignore/figures_sierpinski-hexagon-1.png" title="plot of chunk sierpinski-hexagon" alt="plot of chunk sierpinski-hexagon" width="700px" height="700px" />

```
## Error in sierpinski_hexagon_maze(depth = 6, unit_len = 9, boundary_lines = TRUE, : could not find function "sierpinski_hexagon_maze"
```


## Hexaflake 

<img src="nodist/ignore/figures_hexaflake-1.png" title="plot of chunk hexaflake" alt="plot of chunk hexaflake" width="700px" height="700px" />




## A rectangular spiral

<img src="nodist/ignore/figures_rect-spiral-1.png" title="plot of chunk rect-spiral" alt="plot of chunk rect-spiral" width="700px" height="700px" />


## A double rectangular spiral

<img src="nodist/ignore/figures_rect-double-spiral-1.png" title="plot of chunk rect-double-spiral" alt="plot of chunk rect-double-spiral" width="700px" height="700px" />


## A boustrophedon


<img src="nodist/ignore/figures_rect-boustrophedon-1.png" title="plot of chunk rect-boustrophedon" alt="plot of chunk rect-boustrophedon" width="700px" height="700px" />

