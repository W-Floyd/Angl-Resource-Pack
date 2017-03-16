All benchmarks run on i7 6500U, 16GB RAM.  
Each run includes XML parsing, run from a cleaned git instance.  

```
$ smelt --xml-only -t && echo && smelt -qt --no-optimize
INFO - Only processing XML files
TIME - Processed XML in 9.508343449 seconds

32   - 100% done - 219/219
TIME - Rendered size 32 in 23.324574388 seconds

64   - 100% done - 219/219
TIME - Rendered size 64 in 24.124233469 seconds

128  - 100% done - 219/219
TIME - Rendered size 128 in 26.801240566 seconds

256  - 100% done - 219/219
TIME - Rendered size 256 in 30.837473290 seconds

512  - 100% done - 219/219
TIME - Rendered size 512 in 47.024099812 seconds

1024 - 100% done - 219/219
TIME - Rendered size 1024 in 95.014352058 seconds
TIME - Rendered all in 247.397958435 seconds
```

Produced:
```
Angl-32px.zip   -     179,098 bytes
Angl-64px.zip   -     400,685 bytes
Angl-128px.zip  -   1,003,472 bytes
Angl-256px.zip  -   2,524,342 bytes
Angl-512px.zip  -   6,110,674 bytes
Angl-1024px.zip -  13,822,266 bytes
```

```
$ smelt --xml-only -t && echo && smelt -qt --force-optimize --optimizer optipng 
INFO - Only processing XML files
TIME - Processed XML in 9.817593965 seconds

32   - 100% done - 219/219
TIME - Rendered size 32 in 26.270035028 seconds

64   - 100% done - 219/219
TIME - Rendered size 64 in 27.925394145 seconds

128  - 100% done - 219/219
TIME - Rendered size 128 in 41.342890664 seconds

256  - 100% done - 219/219
TIME - Rendered size 256 in 77.033461626 seconds

512  - 100% done - 219/219
TIME - Rendered size 512 in 152.775401288 seconds

1024 - 100% done - 219/219
TIME - Rendered size 1024 in 334.836394413 seconds
TIME - Rendered all in 660.449772161 seconds
```

```
Angl-32px.zip   -    143,371 bytes
Angl-64px.zip   -    348,379 bytes
Angl-128px.zip  -    897,770 bytes
Angl-256px.zip  -  2,276,049 bytes
Angl-512px.zip  -  5,508,213 bytes
Angl-1024px.zip - 12,407,678 bytes
```

```
$ smelt --xml-only -t && echo && smelt -qt --force-optimize --optimizer zopflipng 
INFO - Only processing XML files
TIME - Processed XML in 12.634905151 seconds

32   - 100% done - 219/219
TIME - Rendered size 32 in 30.868336177 seconds

64   - 100% done - 219/219
TIME - Rendered size 64 in 31.434168852 seconds

128  - 100% done - 219/219
TIME - Rendered size 128 in 43.674362875 seconds

256  - 100% done - 219/219
TIME - Rendered size 256 in 81.541640615 seconds

512  - 100% done - 219/219
TIME - Rendered size 512 in 158.384737965 seconds

1024 - 100% done - 219/219
TIME - Rendered size 1024 in 394.270155288 seconds
TIME - Rendered all in 740.435107166 seconds
```

```
Angl-32px.zip   -    143,371 bytes
Angl-64px.zip   -    348,379 bytes
Angl-128px.zip  -    897,770 bytes
Angl-256px.zip  -  2,276,049 bytes
Angl-512px.zip  -  5,508,213 bytes
Angl-1024px.zip - 12,407,678 bytes
```

```
$ smelt --xml-only -t && echo && smelt -qt --force-optimize --optimizer pngcrush
INFO - Only processing XML files
TIME - Processed XML in 9.960904180 seconds

32   - 100% done - 219/219
TIME - Rendered size 32 in 28.020069680 seconds

64   - 100% done - 219/219
TIME - Rendered size 64 in 31.042041523 seconds

128  - 100% done - 219/219
TIME - Rendered size 128 in 44.548824187 seconds

256  - 100% done - 219/219
TIME - Rendered size 256 in 77.264573307 seconds

512  - 100% done - 219/219
TIME - Rendered size 512 in 151.352064876 seconds

1024 - 100% done - 219/219
TIME - Rendered size 1024 in 326.498175662 seconds
TIME - Rendered all in 659.048128279 seconds
```

```
Angl-32px.zip   -    143,371 bytes
Angl-64px.zip   -    348,379 bytes
Angl-128px.zip  -    897,770 bytes
Angl-256px.zip  -  2,276,049 bytes
Angl-512px.zip  -  5,508,213 bytes
Angl-1024px.zip - 12,407,678 bytes
```
